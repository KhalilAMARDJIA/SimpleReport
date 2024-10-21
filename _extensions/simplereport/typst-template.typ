// main variables settings

#let main_color = rgb(0,0,255)
#let main_font = ("Latin Modern Roman", "Libertinus Serif",  "IBM Plex Serif", "Times New Roman")
#let secondary_font = ("Cantarell", "Helvetica", "IBM Plex Sans",  "Noto Sans", "Arial")



#let report(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  version: none,
  margin: (top: 4cm, bottom: 4cm, left: 4cm, right: 4cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: main_font,
  fontsize: 11pt,
  bibliography: none,

  doc,
) = {
  ////////////////////////// Page settings ////////////////////////////
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  // Footer settings
  // Configure footer
  set page(footer: grid(
    columns: (1fr, 1fr, 1fr),
    align: (left, center, right),
    gutter: 0.5em,
    if version != none {
      text([VERSION: #version],  size: 1em)
    },
    [],
    align(counter(page).display("1 of 1", both: true), right),
  ))


  ///////////////////////////// Text settings ////////////////////////////
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize, hyphenate: false
           )


  // heading settings         
  set heading(numbering: "1.1")
  show heading: set text(font: secondary_font)
  show heading.where(level: 1): it =>  {
    pagebreak()
    set text(font: secondary_font, weight: 600, size: 1.35em)
    it
    v(1.5em)
    }
   show heading.where(level: 2): it =>  {

    set text(font: secondary_font, weight: 400, size: 1.15em)
    it
    v(1em)
    }

  // title settings
  if title != none {
    align(left)[
      #box(
      inset: 2em,
      width: 100%,
      )[
        #text(weight: "bold", size: 2.2em, font: secondary_font)[#upper(title)]
    ]
    ]
  }

  if subtitle != none {
    align(left)[#box(inset: (bottom: 5em, rest: 2em))[
      #text(weight: 300, size: 1.5em, font: secondary_font)[#subtitle]
    ]]
  } else {
    v(2em)
  }



    if date != none {
    align(right)[
      #v(0.5fr)
      #box(
        inset: 1em,
        )[
      #text(date, weight: 600, size: 2em, font: secondary_font)
    ]]
  
  }





  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  // Authors and approuval settings
  if authors != none {

    heading(
      "Author(s) and approuval(s)",  
    
     numbering: none
      )
    let count = authors.len()
    let ncols = calc.min(count, 1)
    grid(
      stroke: 0.5pt + black,
      inset: 1em,
      columns: (1fr, ) * ncols,
      row-gutter: 0.5em,
      ..authors.map(author =>
          align(left)[
            #strong(author.name) \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  let custom_outline_fill = box(width: 1fr, repeat(" ."))
  // table of contents settings

  context { 
    show outline.entry.where(level: 1): it => { 
      v(0.2em)
      set text(font: secondary_font, weight: 600)
      box(it.body, width: 1fr)
      text(it.page)
      
      }
    let outline_title = box(text([Table of contents], size: 1.2em, weight: 600), inset: (bottom: 1.5em, rest: 0em))
    outline(
      fill: custom_outline_fill, 
      indent: auto,
      title: outline_title,
      )

  }

  // Set bulette list settings
  set list(
    tight: false,
    indent: 1.5em,
    body-indent: 1em,
    spacing: auto,
    marker: ([•], [--], [○], [‣]))

  // Set number list settings
  set enum(
    tight: false,
    indent: 1.5em,
    body-indent: 1em,
    spacing: auto,
  )


  // links settings
    show link: set text(fill: main_color)
    show ref: set text(fill: main_color)
    

  doc
  context {
    show outline.entry: it => {

      text(it, fill: main_color)
    }    

  outline(
    title: [List of Figures],
    target: figure.where(kind: "quarto-float-fig"),
    fill: custom_outline_fill,
  )
    outline(
    title: none,
    target: figure.where(kind: image),
    fill: custom_outline_fill,
  )


  outline(
    title: [List of Tables],
    target: figure.where(kind: "quarto-float-tbl"),
    fill: custom_outline_fill
  )
    outline(
    title: none,
    target: figure.where(kind: table),
    fill: custom_outline_fill
  )

  }
   // Display bibliography.
  if bibliography != none {
    pagebreak()
    show bibliography: set text(0.85em)
    // Use default paragraph properties for bibliography.
    show bibliography: set par(leading: 0.65em, justify: false, linebreaks: auto)
    bibliography()
  }
  
}
  // Figure settings
  #show figure.caption: it =>{
    // set text(weight: 400, size: 1.1em)
    block(it, inset: 1em)
  }

  // Table settings

  #show figure.where(kind: table): set figure.caption (position: top)
  #show figure.where(kind: table): set block(breakable: true)
  #show table.cell : set text(size: 0.8em)
  #show figure.where(kind: "quarto-float-tbl"): set block(breakable: true)
  #show figure.where(kind: "quarto-float-tbl"): set table.header(repeat: true) 


#set table(
  stroke: (_, y) => (
    top:  if y == 1 { 0.5pt } else if y < 1 { 1pt } else { 0pt },
    bottom: if y != 1 { 1pt } else if y == calc.max(y) { 0.5pt } else if y > 1 { 1pt } else { 0pt }
  ),
)