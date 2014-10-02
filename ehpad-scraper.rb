require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require './page_parser'

def download_all_pages(index_file)
  doc = Nokogiri::HTML(open(index_file))
  doc.css('#liste .result_item').each do |item|
    item.css('.margeur > h2 > a').each do |title|
      `wget -O data/#{File.basename(title['href'])}.html #{title['href']}` unless File.exist? "data/#{File.basename(title['href'])}.html"
    end
  end
end

download_all_pages 'data/maison-retraite-ehpad.index'
fields = PageParser.fields
puts fields.values.join("\t")
Dir.glob('data/*.html').each do |f|
  puts PageParser.parse(f).to_csv(fields.keys)
end
