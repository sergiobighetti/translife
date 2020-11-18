Close Databases All
Close Tables All
Set Escape On
Set Exclusive Off

cDir = '\\DCRPO\MEDILAR\TAB\'
Use (cDir+'ASSOCIADO')       In 0
Use (cDir+'ASSOCIADO_PLANO') In 0

Use PLAN2 In 0 Alias xpr



Select xpr


Scan All

   cCod = Alltrim(codigo)

   @ 10,10 Say Transform(Recno())+' de '+Transform(Reccount())

   cOri = 'Cuidador: '+  ALLTRIM(cuidador)+CHR(13)+;
          'Medico: '+    ALLTRIM(medico)+" "+ALLTRIM(fonemed)+'/'+ALLTRIM(celmed)+CHR(13)+;
          'Hosp: '+      ALLTRIM(hospital)+CHR(13)+;
          'Patologia: '+ ALLTRIM(patologia)+CHR(13)+;
          'Perfil: '+    ALLTRIM(perfil)+CHR(13)+;
          'Sintese: '+   ALLTRIM(sintese)+CHR(13)+;
          'Alta: '+      ALLTRIM(alta)+CHR(13)+;

   Select ASSOCIADO
   Locate For codOrigem=cCod
   If Found()
       
      cOriASSOC = ALLTRIM(orientacao)
      IF !EMPTY(cOriASSOC)
         cOri = cOriASSOC +CHR(13)+cOri
      ENDIF
      replace orientacao WITH cOri
   Endif

   Select xpr
Endscan

