module PageTree
private
  @@page_tree = {
    factsheet: {
      nom:     {},
      adresse: {},
      ville:   {},
      url:     {link: true},
      tel:     {gsub: "Tél. : "},
      fax:     {gsub: "Fax : "},
      email:   {gsub: "mailto:", link: true}
    },
    box_caracteristiques: {
      statut: {},
      apl:    {gsub: "Etablissement habilité à l’APL : "},
      aide:   {gsub: "Habilité à l'Aide Sociale : "},
      cantou: {gsub: "Unité Alzheimer (Cantou) : "},
      uphv:   {gsub: "Unité pour personnes handicapées vieillissantes : "},
      usl:    {gsub: "Unité de Soins Longue Durée (USLD) : "}
    },
    box_personnel: {
      salaries:         {gsub: "Médecins salariés : "},
      infirmieres_nuit: {gsub: "Infirmières la nuit : "},
      aides_nuit:       {gsub: "Aides-soignants la nuit : "},
      kine:             {gsub: "Intervention d'un kinésithérapeute : "},
      ergo:             {gsub: "Intervention d'un ergothérapeute ou d'un psychomotricien : "},
      psycho:           {gsub: "Intervention d'un psychologue : "}
    },
    box_hebergement: {
      nb_lits:    {gsub: "Nombre de lits dans l’établissement : "},
      nb_ch1:     {gsub: "Nombre de chambres simples : "},
      nb_ch2:     {gsub: "Nombre de chambres doubles ou communicantes : "},
      nb_appt:    {gsub: "Nombre d’appartements  : "},
      surf_ch1:   {gsub: "Chambres simples (en moyenne) : "},
      surf_ch2:   {gsub: "Chambres doubles (en moyenne) : "},
      surf_appt:  {gsub: "Appartements (en moyenne) : "},
      clim:       {gsub: "Chambres climatisées : "},
      signal:     {gsub: "Chambres équipées de signal d'appel : "},
      hote:       {gsub: "L'établissement propose des chambres d'hôte : ", selector: '.signal ~ li'}
    },
    box_vie: {
      restau_directe: {gsub: "Gestion directe de la restauration par l'établissement : ", selector: '.titre_restauration ~ li'},
      sous_traitance: {gsub: "Sous traitance de la restauration : ", selector: '.titre_restauration ~ li ~ li'},
      sous_traitant:  {gsub: "Sous-traitant : ", selector: '.titre_restauration ~ li ~ li ~ li'},
      dieteticienne:  {gsub: "Les repas sont préparés avec l'aide d'une diététicienne : ", selector: '.titre_restauration ~ li ~ li ~ li ~ li'},
      restau_famille: {gsub: "La famille ou les amis peuvent se joindre au résident pour les repas : ", selector: '.titre_restauration ~ li ~ li ~ li ~ li ~ li'},
      loisirs:        {gsub: "Loisirs : ", selector: '.titre_loisirs ~ li'},
      benevoles:      {gsub: "Présence de bénévoles : ", selector: '.titre_loisirs ~ li ~ li'},
      coiffeur:       {gsub: "Coiffeur : ", selector: '.titre_autres ~ li'},
      esthetique:     {gsub: "Esthétique : ", selector: '.titre_autres ~ li ~ li'},
      pedicure:       {gsub: "Pedicure : ", selector: '.titre_autres ~ li ~ li ~ li'},
      balneo:         {gsub: "Balnéothérapie ou espace de bien-être : ", selector: '.titre_autres ~ li ~ li ~ li ~ li'},
      animaux:        {gsub: "Animaux de compagnie autorisés : ", selector: '.titre_animaux'}
    },
    box_tarifs: {
      tarif_ch1:     {gsub: "en chambre simple : ", selector: '.titre_tarifs ~ li'},
      tarif_ch2:     {gsub: "en chambre double : ", selector: '.titre_tarifs ~ li ~ li'},
      tarif_appt:    {gsub: "en appartement : ", selector: '.titre_tarifs ~ li ~ li ~ li'},
      gir_1_2:       {gsub: "GIR 1/2 : ", selector: '.titre_gir ~ li'},
      gir_3_4:       {gsub: "GIR 3/4 : ", selector: '.titre_gir ~ li ~ li'},
      gir_5_6:       {gsub: "GIR 5/6 : ", selector: '.titre_gir ~ li ~ li ~ li'},
      blanchisserie: {gsub: "Prestation blanchisserie incluse : ", selector: '.titre_blanchisserie'}
    },
    box_cadre: {
      exterieur: {gsub: "Espace extérieur accessible à toute dépendance : ", selector: 'ul > li:first'},
      bus:       {gsub: "Bus : ", selector: 'ul > li:first ~ li > ul > li:first'},
      tramway:   {gsub: "Tramway : ", selector: 'ul > li:first ~ li > ul > li:first ~ li'},
      metro:     {gsub: "Métro : ", selector: 'ul > li:first ~ li > ul > li:first ~ li ~ li'},
      train:     {gsub: "Train : ", selector: 'ul > li:first ~ li > ul > li:first ~ li ~ li ~ li'}
    }
  }

  @@human_fields_names = {
    apl:              "Etablissement habilité à l’APL",
    aide:             "Habilité à l'Aide Sociale",
    cantou:           "Unité Alzheimer (Cantou)",
    uphv:             "Unité pour personnes handicapées vieillissantes",
    usl:              "Unité de Soins Longue Durée (USLD)",
    salaries:         "Médecins salariés",
    infirmieres_nuit: "Infirmières la nuit",
    aides_nuit:       "Aides-soignants la nuit",
    kine:             "Intervention d'un kinésithérapeute",
    ergo:             "Intervention d'un ergothérapeute ou d'un psychomotricien",
    psycho:           "Intervention d'un psychologue",
    nb_lits:          "Nombre de lits dans l’établissement",
    nb_ch1:           "Nombre de chambres simples",
    nb_ch2:           "Nombre de chambres doubles ou communicantes",
    nb_appt:          "Nombre d’appartements ",
    surf_ch1:         "Chambres simples (en moyenne)",
    surf_ch2:         "Chambres doubles (en moyenne)",
    surf_appt:        "Appartements (en moyenne)",
    clim:             "Chambres climatisées",
    signal:           "Chambres équipées de signal d'appel",
    host:             "L'établissement propose des chambres d'hôte",
    restau_directe:   "Gestion directe de la restauration par l'établissement",
    sous_traitance:   "Sous traitance de la restauration",
    dieteticienne:    "Les repas sont préparés avec l'aide d'une diététicienne",
    restau_famille:   "La famille ou les amis peuvent se joindre au résident pour les repas",
    benevoles:        "Présence de bénévoles",
    balneo:           "Balnéothérapie ou espace de bien-être",
    animaux:          "Animaux de compagnie autorisés",
    tariff_ch1:       "Tarif journalier d'hébergement en chambre simple (à partir de)",
    tariff_ch2:       "Tarif journalier d'hébergement en chambre double (à partir de)",
    tariff_appt:      "Tarif journalier d'hébergement en appartement (à partir de)",
    gir_1_2:          "GIR 1/2",
    gir_3_4:          "GIR 3/4",
    gir_5_6:          "GIR 5/6",
    exterieur:        "Espace extérieur accessible à toute dépendance"
  }
end
