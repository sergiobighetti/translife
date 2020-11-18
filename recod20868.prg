Close Databases All
Close Tables All
Set Exclusive Off
Set Escape On


cVer    = Sys(2015)
cDir    = 'c:\desenv\win\vfp9\sca_new\'

Use cDir+'CONTRATO' In 0 Shared
Use cDir+'ASSOCIADO' In 0 Shared
Use cDir+'FILIAL'   In     0 Shared
Use cDir+'FILIAL_CHAVES' In 0 Shared


Select idAssoc, idContrato From (cDir+'ASSOCIADO') Where idContrato=20868 Into Cursor (cVer)



Select (cVer)
Scan All

   ?? '.'

   Select ASSOCIADO
   =SEEK( &cVer..idContrato, 'CONTRATO',  'I_D' )
   =SEEK( &cVer..idAssoc,    'ASSOCIADO', 'idAssoc' )
   
   FI_CODIFICA( 'TITULAR' )
 
   Select (cVer)

Endscan
RETURN



 
