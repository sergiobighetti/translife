Lparameters cTipo
Local aAbrev[1], aDescr[1], cAbrev, cDescr, nPos, cRtn
cTipo  = Left(Alltrim(cTipo),15)
cAbrev = 'FA,CL,AS,AP,AB,AE,BE,EV,FN,CO,LP,RE,PU,AM,LC'
cDescr = 'FAMILIAR,COLETIVO,ASSOCIAÇÃO,AREA PROTEGIDA,AREA PRO.BENEM.,AREA PRO.EMPR.,BENEMÉRITO,CLIENTE EVENTUA,FUNCIONÁRIO,CUSTO OPER.,LAR PROTEGIDO,REMOÇÃO,PUBLICO,AMBULATORIO,LOCACAO'
cDescr = semacento( cDescr )
=Alines( aAbrev, cAbrev, .T., ',' )
=Alines( aDescr, cDescr, .T., ',' )
cTipo = SEMACENTO( Alltrim(cTipo) )
cRtn  = ''
If Len(cTipo) > 0
   If Len(cTipo) = 2
      nPos = Ascan( aAbrev, cTipo)
      If nPos > 0
         cRtn = aDescr( nPos )
      Endif
   Else
      nPos = Ascan( aDescr, cTipo)
      If nPos > 0
         cRtn = aAbrev( nPos )
      Endif
   Endif
Endif
Return cRtn