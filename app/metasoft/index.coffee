jsRoot = @

{ Metasoft } = jsRoot
{ Sample } = Metasoft.components
tpls = Metasoft.tpls

Metasoft.init("metasoft")

Metasoft.addCss([ 'metasoft' ])
Metasoft.addJs([ 'components/sample' ])

Metasoft.render("index", { title: 'Metasoft' })
