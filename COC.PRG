Close Databases All
Close Tables All
Set Escape On
Clear

cTmp = Sys(2015)

Use c:\Users\sergio\Desktop\COC2 In 0 ALIAS coc
Use c:\desenv\win\vfp9\sca_new\ASSOCIADO In 0

Select COC
Scan All

   cCod = Alltrim(Chrtran(COC.codigo_ass,'-.',''))
   cCod = Left(cCod,10)
   nIdC = COC.CTR_ID

   ? cCod
   ?? ' '+ Alltrim(COC.Nome)

   Select ASSOCIADO
   Set Order To CODIGO   && CODIGO
   If Seek( cCod, 'ASSOCIADO', 'CODIGO' )
      Scan While Left(CODIGO,10)=cCod
         If ASSOCIADO.situacao='ATIVO'
            Replace ASSOCIADO.idContrato With nIdC
            ?? '.'
         Else
         Endif
      Endscan
   Endif

   Select COC
Endscan
