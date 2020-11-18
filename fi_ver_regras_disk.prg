LPARAMETERS cCodAsso, nIdProc, dDataAt, cHoraAt, nTpAgen, nTpPaci, cAlsProc
* cCodAsso - Codigo de associado
* nIdProc  - Codigo do procedimento
* dDataAt  - data do atendimento
* cHoraAt  - hora de atendimento
* nTpAgen  - tipo de agenda
* nTpPaci  - tipo de paciente (associado/particular)
* [cAlsProc]

Local nIdContr, nIdProc, cCodAsso, lRtn, cVer, cRDI, dDataAt, cHoraAt, cMsg
LOCAL dIni, nSeq, dProxAgenda, nQtdAgenda, nDiskBNF, nIdProc, nIdAssoc, cDiskCTR 
LOCAL nSeqG, dDataNoDia, nTpAgen, nTpPaci, dBaseAssc

cMsg     = ''
cVer     = Sys(2015)
cRDI     = Sys(2015)

=SEEK(cCodAsso, 'ASSOCIADO', 'CODIGO' )
dBaseAssc = ASSOCIADO.database
nIdAssoc = ASSOCIADO.idAssoc
nIdContr = ASSOCIADO.idContrato
nDiskBNF = 0  &&-- codigo do DISK do associado

*-- seleciona as regras do contrato
Select      Rd.idproduto,   Rd.car_inicial, ;
            Rd.uso_maximo,  Rd.pos_uso,     ;
            Rd.acumula      ;
            ;
FROM        CONTRATO_REGRAS_DISK Rd         ;
WHERE       Rd.idContrato = nIdContr        ;
INTO Cursor (cRDI)

If _Tally > 0  && se tiver regras no contrato 

   cDiskCTR = ''
   SCAN ALL
      cDiskCTR = cDiskCTR +','+TRANSFORM(idproduto,'@L 999')
   ENDSCAN 
   cDiskCTR = SUBSTR(cDiskCTR,2)
   
   *-- acha qual o disk do associado
   IF PTAB( nIdAssoc, 'ASSOCIADO_PLANO', 'IDASSOC', .t. )
      SELECT ASSOCIADO_PLANO
      SCAN WHILE ASSOCIADO_PLANO.idAssoc == nIdAssoc
         IF TRANSFORM(ASSOCIADO_PLANO.idplano,'@L 999') $ cDiskCTR 
            nDiskBNF = ASSOCIADO_PLANO.idplano
         ENDIF
      ENDSCAN
      SELECT (cRDI)
      LOCATE FOR idproduto = nDiskBNF 
   ENDIF 

   *-- seleciona os ultimos atendimentos do procedimento informado
   Select      Top (&cRDI..uso_maximo+1) ;
               ag.dataAG dtAge, ag.horaAG, ap.idprocedimento, ag.i_d ;
   FROM        AGENDA ag ;
   JOIN        AGENDA_PROC  ap On ag.i_d == ap.idagenda ;
   JOIN        PROCEDIMENTO pc ON ap.idProcedimento == pc.I_D ;
   WHERE       pc.idAgrup  = nIdProc       And ;
               ag.codassoc = cCodAsso      And ;
               ag.tipo_AGENDA   = nTpAgen  And ;
               ag.tipo_paciente = nTpPaci  AND ;
               ag.situacao IN ( 'Pendente','Realizado' )   And ;
               ; && ( ag.Data <= dDataAt And ag.hora < cHoraAt ) 
               !( ag.dataAG = dDataAt And ag.horaAG = cHoraAt ) ;
   ORDER By    1 Desc , 2 Desc ;
   INTO Cursor (cVer) ReadWrite
   
   IF TYPE( 'cAlsProc' ) = 'C'
      SELECT (cAlsProc)
      Scan all
         INSERT INTO (cVer) ;
                ( dtAge, horaAG, idprocedimento, i_d ) ;
         VALUES ( &cAlsProc..Data, &cAlsProc..Hora, nIdProc, 0 )
      Endscan
      SELECT (cVer)
   ENDIF

   nQtdAgenda = RECCOUNT(cVer)  &&--- quantidade de atedimentos encontrados

   If nQtdAgenda = 0 && se nao teve nenhum agendamento

      If &cRDI..car_inicial = 0 &&-- carencia inicial zerada

         *-- << libera >>

      Else &&-- verifica carenca inicial

         *-- se data da agenda - data base do associado menor igual a carencia inicial
         If ( dDataAt - dBaseAssc ) >= &cRDI..car_inicial

            *-- << libera >>

         Else

            cMsg = '1a agendamento'+Chr(13)+;
                   'Associado ainda esta dentro do perido de carencia inicial'+Chr(13)+;
                   'Agenda: '+Transform(dDataAt)+' - Data Base: '+Transform(dBaseAssc)+Chr(13)+;
                   'qtd.dias: '+ Transform( dDataAt - dBaseAssc)+;
                   ' Carencia: '+ Transform( &cRDI..car_inicial )

         Endif

      Endif

   Else &&-- analisa os atendimentos

      If &cRDI..acumula = 'S'  &&-- se o uso é acumulativo

         If nQtdAgenda >= &cRDI..uso_maximo &&-- e ja atingio o uso maximo

            dProxAgenda = ( &cVer..dtAge + &cRDI..pos_uso )

            If dDataAt < dProxAgenda
               cMsg = 'Foi atingido o uso maximo de procedimentos '+Chr(13)+;
                      'Agendamento normal em: '+ Transform(dProxAgenda)
            Endif

         Endif

      Else &&-- se o uso NAO é acumulativo e sim CONSECUTIVO

         *-- se a quantidade de agendas for menor ou igual ao uso maximo
         If nQtdAgenda <= &cRDI..uso_maximo

            *-- << libera >>

         ELSE

            Go Top In (cVer)
            dIni    = &cVer..dtAge
            nSeq    = 0
            nSeqG   = 0

            *-- verifica o uso consecutivo
            Do While nSeqG <= &cRDI..uso_maximo

               If dIni <> &cVer..dtAge &&-- se teve quebra de data
                  Exit  &&-- sai fora do laco
               Endif

               dDataNoDia = &cVer..dtAge
               SCAN WHILE &cVer..dtAge == dDataNoDia
                  nSeqG = nSeqG + 1       &&-- incrementa o contador
               ENDSCAN
               
               nSeq = nSeq + 1       &&-- incrementa o contador
               dIni = (dIni - nSeq ) &&-- decrementa a data

            Enddo

            *** Go Top In (cRDI)

            If nSeq > &cRDI..uso_maximo &&-- usou consecutivamente

               dProxAgenda = ( &cVer..dtAge + &cRDI..pos_uso )

               If dDataAt < dProxAgenda

                  cMsg = 'Foi feito uso consecutivo deste procedimento por '+Transform(nSeq)+' dias '+Chr(13)+;
                         'no periodo de:'+ Transform(&cVer..dtAge) +' ate '+ Transform(dIni)+Chr(13)+;
                         'Agendamento normal em: '+ Transform(dProxAgenda)

               Endif

            Endif

         Endif

      Endif

   Endif

ENDIF 
   
USE IN ( SELECT( cVer ) )
USE IN ( SELECT( cRDI ) )

Return cMsg
