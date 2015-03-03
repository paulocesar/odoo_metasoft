jsRoot = @

{ Metasoft } = jsRoot
{ Sample } = Metasoft.components
tpls = Metasoft.tpls

Metasoft.addCss([ 'metasoft' ])
Metasoft.addJs([ 'components/sample' ])

Metasoft.init("metasoft")

Metasoft.render("index", { title: 'Metasoft' })
