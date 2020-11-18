Close Databases All
Close Tables All
Set Exclusive Off
Set Escape On


cVer    = Sys(2015)
cDir    = '\\DCRPO\bdmdc$\'

Use cDir+'CONTRATO' In 0 Shared
Use cDir+'ASSOCIADO' In 0 Shared
Use cDir+'FILIAL'   In     0 Shared
Use cDir+'FILIAL_CHAVES' In 0 Shared


Select idAssoc, idContrato From (cDir+'ASSOCIADO') Where Empty(codigo) Into Cursor (cVer)

SET STEP ON 

Select (cVer)
Scan All

   ?? '.'

   Select ASSOCIADO
   =SEEK( &cVer..idContrato, 'CONTRATO',  'I_D' )
   =SEEK( &cVer..idAssoc,    'ASSOCIADO', 'idAssoc' )
   
   FI_CODIFICA( 'TITULAR' )

   Select (cVer)

Endscan

Endif

