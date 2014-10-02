require './page_tree'

class PageParser
  include PageTree

  attr_accessor :doc, :info

  def initialize(file)
    @doc = Nokogiri::HTML(open(file))
    @info = {}
  end

  def parse
    @@page_tree.each do |section, fields|
      if section_node = doc.at_css("##{section}")
        fields.each do |field, options|
          parse_node section_node, field, options
        end
      end
    end
    return self
  end

  def self.parse(file)
    new(file).parse
  end

  def self.fields
    @@page_tree.map do |section, fields|
      fields.map do |field, options|
        {field => human_field_name(field)}
      end.reduce(:merge)
    end.reduce(:merge)
  end

  def to_csv(fields)
    fields.map do |field|
      "\"#{info[field].to_s.gsub('"', "'")}\""
    end.join("\t")
  end

private

  def parse_node(parent_node, field, options = {})
    node = parent_node.at_css(options[:selector] || ".#{field}#{' a' if options[:link]}")
    if node
      info[field] = options[:link] ? node['href'] : node.text
      info[field].gsub! options[:gsub], '' if options[:gsub]
    end
  end

  def self.human_field_name(field)
    @@human_fields_names[field] || field.to_s.capitalize
  end
end
