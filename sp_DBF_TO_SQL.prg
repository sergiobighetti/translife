CLOSE DATABASES all
USE atendimento
? sp_DBF_TO_SQL( 1, 'ATENDIMENTO', 'chwere')

FUNCTION sp_DBF_TO_SQL( nAcao, cTabela, cWhe )
LOCAL aFld[1], c, cFldINSERT, cSql, cUsar, i, nQtdCampos, xNomDoCampo, xVlr, xVlrDoCampo, nTamMax

cSql = ''
IF INLIST(nAcao,1,2)

   nQtdCampos = AFIELDS(aFld)

   IF nAcao = 1
      TEXT TO cSql TEXTMERGE NOSHOW
      SET dateformat ymd
      INSERT INTO <<cTabela>> 
                  (xCampos) 
           VALUES (xValores)
      ENDTEXT 
   ELSE
      TEXT TO cSql TEXTMERGE NOSHOW
      SET dateformat ymd
      UPDATE <<cTabela>> 
         SET xValores
       WHERE <<cWhe>>
      ENDTEXT 
   ENDIF 

   xVlrDoCampo = ''
   xNomDoCampo = ''
   cFldINSERT  = ''
   cUsar =       ''
   xVlr  = ''
   
   nTamMax = 10
   FOR i = 1 TO nQtdCampos
      nTamMax = MAX( nTamMax, LEN(aFld[i,1]) )
   NEXT 
   nTamMax = nTamMax + 7
   
   FOR i = 1 TO nQtdCampos
   
      xVlrDoCampo = EVALUATE(aFld[i,1])
      xNomDoCampo = aFld[i,1]
      
      IF xNomDoCampo  ='DATABASE'
         xNomDoCampo = 'DTBASE'
      ENDIF 
      
      
      cFldINSERT = cFldINSERT +','+CHR(13)+xNomDoCampo
      
      DO case
         CASe ISNULL(xVlrDoCampo)
            cUsar = "null"
         CASE  aFld[i,2] = 'L'
            cUsar = "'"+ IIF( xVlrDoCampo, 'S', 'N' ) + "'"
         CASE INLIST(aFld[i,2], 'D', 'T')
            cUsar = "'"+ TTOC_SQL( xVlrDoCampo  ) +"'"
         CASE  aFld[i,2] = 'I'
            cUsar = LTRIM(str( xVlrDoCampo,14,0))
         CASE  aFld[i,2] = 'N'
            IF aFld[i,4] = 0
               cUsar = LTRIM(str( xVlrDoCampo,14,0))
            else
              cUsar = NTOC_SQL( xVlrDoCampo,aFld[i,3],aFld[i,4] )
            ENDIF 
         CASE  aFld[i,2] = 'Y'
            cUsar = ALLTRIM(NTOC_SQL( xVlrDoCampo,14,4))
         CASE  INLIST(aFld[i,2], 'C', 'M' )
         
            cUsar = CHRTRAN( xVlrDoCampo,CHR(39), "")
            cUsar = semAcento(cUsar,.t.)
            
            FOR c=1 TO 30 
               cUsar = CHRTRAN( cUsar,CHR(c), "")
            NEXT 
            cUsar = "'"+ LEFT(cUsar,aFld[i,3]) +"'"
      endcase
      
      
      cCampoTipo = aFld[i,2] +'('+ TRANSFORM(aFld[i,3])
      IF aFld[i,4] > 0
         cCampoTipo = cCampoTipo +','+ TRANSFORM(aFld[i,4])
      ENDIF 
      cCampoTipo = xNomDoCampo + ' '+cCampoTipo +')' 
      
      IF nAcao = 1
         xVlr = xVlr +','+ CHR(13) + '/* '+ PADL(cCampoTipo,nTamMax) +'*/ ' + cUsar 
      ELSE
         xVlr = xVlr +','+CHR(13)+ '/* '+ PADL(cCampoTipo,nTamMax) +'*/ '+ PADL( xNomDoCampo, nTamMax) +'='+ cUsar 
      ENDIF 
      
   NEXT 
   
   
   IF nAcao = 1
      cSql = STRTRAN( cSql, 'xCampos',  SUBSTR(cFldINSERT,2), 1 , 1 )
   ENDIF 
   
   cSql = STRTRAN( cSql, 'xValores', SUBSTR(xVlr,2), 1 , 1 )

ELSE
   IF nAcao = 3
      TEXT TO cSql TEXTMERGE NOSHOW
      SET dateformat ymd
      DELETE FROM <<cTabela>> WHERE <<cWhe>>
      ENDTEXT 
   ENDIF 
ENDIF 

IF !EMPTY(cSql)
   _ClipText = cSql
ENDIF 

RETURN .t. 