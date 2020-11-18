CLEAR 
&& Function FI_SQLSINCR()
* SINCRONIZA DADOS NO SQL SERVER
Local aOpen[1], x, laClosed[1]
Local aStruc[1], cConteudo, cDDS, cFld, cMsg, cSql, cUpd, cVlr, nConn, nOK, nQtdC, oReg
Local cTmp, i, nSel, tAgora, cNomeFLD, lAbriuSQLSINCR


nSel   = Select()
cTmp   = Sys(2015)
tAgora = DATETIME()

=Aused( aOpen )


lAbriuSQLSINCR = .F.
If ! Used('SQLSINCR')
   Use SQLSINCR In 0 Shared
   lAbriuSQLSINCR = .T.
Endif

*--- mantem limpo 
SELECT SQLSINCR
DELETE FOR !EMPTY(dtenvio) AND DTOS(dtEnvio) <= ( DATE()-3 )


Select      Id, dtcad, ori, ori_fldchv, ori_id, acao, auditoria, dtenvio  ;
FROM        SQLSINCR     ;
WHERE       Empty(dtenvio) And acao In ( 'I','U','D' ) ;
ORDER By    dtcad ;
INTO Cursor (cTmp)

If _Tally > 0

   Select (cTmp)
   Scan All

      cVlr = ''
      cFld = ''
      cUpd = ''

      Scatter Name oReg  && captura informações basicas da sicronização

      *--- cria o SQL que sera executado
      Do Case
         Case oReg.acao = 'I'
            TEXT TO cSql TEXTMERGE NOSHOW
INSERT INTO <<ALLTRIM(oReg.ori)>> ( [_F_L_D_] ) 
     VALUES( 
             [_V_L_R_] 
           )
            ENDTEXT
         Case oReg.acao = 'U'
            TEXT TO cSql TEXTMERGE NOSHOW
UPDATE <<ALLTRIM(oReg.ori)>> 
   SET [_U_P_D_] 
 WHERE <<ALLTRIM(oReg.ori_fldchv)>>=<<oReg.ori_id>>
            ENDTEXT
         Case oReg.acao = 'D'
            TEXT TO cSql TEXTMERGE NOSHOW
DELETE FROM <<ALLTRIM(oReg.ori)>> WHERE <<ALLTRIM(oReg.ori_fldchv)>>=<<oReg.ori_id>>
            ENDTEXT
      Endcase

      cDDS = 'SELECT * FROM '+ ALLTRIM(oReg.ori) +' WHERE '+ALLTRIM(oReg.ori_fldchv) +'='+ ALLTRIM(TRANSFORM(oreg.ori_id))
      cDDS = cDDS + ' INTO CURSOR lv_DDS'

      &cDDS.

      If _Tally > 0

         nQtdC = Afields( aStruc, 'lv_DDS' )


         If oReg.acao $ 'IU'

            For i=1 To nQtdC

               cNomeFLD = aStruc[i,1]
               IF ALLTRIM(UPPER(cNomeFLD)) == 'DATABASE'
                  cNomeFLD = 'DTBASE'
               ENDIF 

               cFld = cFld +','+ cNomeFLD

               Do Case

                  Case aStruc[i,2] $ 'CMQV'
                     xInfFLD   = +"/* "+ PADL( LOWER(cNomeFLD) +' '+ ALLTRIM(aStruc[i,2]) +'('+ TRANSFORM(aStruc[i,3]), 30) +') */' 

                     cConteudo = Chrtran( Alltrim( Evaluate(aStruc[i,1]) ), "'", " " )
                     cUpd = cUpd + CHR(13) +","+ cNomeFLD +"='"+ cConteudo  +"'"
                     cVlr = cVlr + CHR(13) +xInfFLD+ ","+ "'"+ cConteudo  +"'"
                     
                  Case aStruc[i,2] = 'I'
                     xInfFLD   = +"/* "+ PADL( LOWER(cNomeFLD) +' '+ ALLTRIM(aStruc[i,2]) +'('+ TRANSFORM(aStruc[i,3]), 30) +') */' 
                     cConteudo = Evaluate(aStruc[i,1]) 
                     cUpd = cUpd + CHR(13)+","+ cNomeFLD +"="+ Transform(cConteudo)
                     cVlr = cVlr + CHR(13)+ xInfFLD+ ","+ Transform(cConteudo)  

                  Case aStruc[i,2] $ 'DT'
                     xInfFLD   = +"/* "+ PADL( LOWER(cNomeFLD) +' '+ ALLTRIM(aStruc[i,2]) +'('+ TRANSFORM(aStruc[i,3]), 30) +') */' 

                     cConteudo = Evaluate(aStruc[i,1])
                     If Empty(cConteudo)
                        cUpd = cUpd +","+CHR(13)+ cNomeFLD +"=NULL"  
                        cVlr = cVlr + CHR(13)+xInfFLD+ "," +"NULL"              
                     Else
                        cUpd = cUpd +","+CHR(13)+ cNomeFLD +"='"+ TTOC_SQL( cConteudo ) +"'"
                        cVlr = cVlr + CHR(13)+xInfFLD+ ","+ "'"+ TTOC_SQL( cConteudo ) +"'"
                     Endif

                  Case aStruc[i,2] = 'L'
                     xInfFLD   = +" /* "+ PADL( LOWER(cNomeFLD) +' '+ ALLTRIM(aStruc[i,2]),50)  +" */"
                     cConteudo = Evaluate(aStruc[i,1])
                     If cConteudo
                        cUpd = cUpd +","+CHR(13)+ cNomeFLD +"='S'" 
                        cVlr = cVlr +CHR(13)+xInfFLD   + ","+ "'S'"                      +" /* "+ LOWER(cNomeFLD) +' '+ ALLTRIM(aStruc[i,2])  +" */"
                     Else
                        cUpd = cUpd +","+CHR(13)+ cNomeFLD +"='N'"
                        cVlr = cVlr +CHR(13)+xInfFLD   + ","+ "'N'"                      
                     Endif

                  Case aStruc[i,2] = 'N' 
                     cConteudo = Evaluate(aStruc[i,1])
                     cUpd = cUpd +","+CHR(13)+ cNomeFLD +"="+ NTOC_SQL(cConteudo, aStruc[i,3], aStruc[i,4] )
                     cVlr = cVlr +CHR(13)+","+ NTOC_SQL(cConteudo, aStruc[i,3], aStruc[i,4] ) +" /* "+ LOWER(cNomeFLD) +' '+ ALLTRIM(aStruc[i,2]) +'('+ TRANSFORM(aStruc[i,3]) +') */' 

                  Case aStruc[i,2] = 'YFB'
                     cConteudo = Evaluate(aStruc[i,1])
                     cUpd = cUpd +","+CHR(13)+ cNomeFLD +"="+ NTOC_SQL(cConteudo, 12, 2 )
                     cVlr = cVlr +CHR(13)+","+ NTOC_SQL(cConteudo, 12, 2 )

               Endcase

            Next
               
            cUpd = Substr(cUpd,3)
            cVlr = Substr(cVlr,3)
            cFld = Substr(cFld,2)

            If oReg.acao = 'I'

               cSql = Strtran( cSql, '[_F_L_D_]', cFld,1,1 )
               cSql = Strtran( cSql, '[_V_L_R_]', cVlr,1,1 )

            Else

               cSql = Strtran( cSql, '[_U_P_D_]', cUpd,1,1 )

            Endif


         Endif
         USE IN ( SELECT('lv_DDS') )
? '---'
_ClipText = cSql
? cSql 
? INKEY(0) 
? '---'
*!*            nConn = cnxBD()
*!*            If nConn > 0
*!*               nOK = SQLExec(nConn, cSql,,aInfSQL )
*!*               If nOK > 0
*!*                  Select SQLSINCR
*!*                  If Seek( oReg.Id, 'ID' )
*!*                     Replace dtenvio With tEnvio
*!*                  Endif
*!*               Else
*!*                  cMsg = cMsg + Chr(13)+ cSql
*!*               Endif

*!*               =SQLDisconnect(nConn)
*!*            Else
*!*               cMsg = cMsg + Chr(13)+ 'Banco de dados nao conectou'
*!*               Exit
*!*            Endif

      Endif

      Select (cTmp)
   Endscan

Endif

Use In (Select(cTmp))

If lAbriuSQLSINCR
   Use In ( Select('SQLSINCR') )
Endif

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

Select (nSel)

 