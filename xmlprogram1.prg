o = CREATEOBJECT('Microsoft.xmlDom')
o.load( LOCFILE('CN0402200001.094'))
o.async= .F.
oPes =  o.childNodes(1).childNodes(3).childNodes(0).childNodes(3)
_ClipText = oPes.childNodes(0).xml
