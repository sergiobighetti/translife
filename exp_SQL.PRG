CLOSE DATABASES all
CLOSE TABLES all
CLEAR
?
dIni = DATETIME()
? dIni

SET ESCAPE ON 
cString = 'Driver=SQL Server;Server=SERGIO-PC\SQLEXPRESS;UID=sa;PWD=q1w2e3r4;Database=SIGAPH'
** hConn   = Sqlstringconnect(cString)
SELECT ;
       aa.idassoc ;
      ,aa.idcontrato ;
      ,aa.codigo ;
      ,CHRTRAN(aa.nome,";'", '' ) AS NOME ;
      ,aa.situacao ;
      ,TDATA(aa.data_nascimento) as dtnasc;
      ,CHRTRAN(aa.cpf,'.-/', '') as CPF ;
      ,CHRTRAN(aa.rg,'.-/', '') as RG ;
      ,aa.codorigem ;
      ,TDATA(aa.datacancela ) as dtcancel ;
      ,aa.motivocancel ;
      ,aa.ficha ;
      ,bb.tipo_contrato;
      ,CHRTRAN(bb.nome_responsavel,";'", '' ) AS nome_responsavel;
      ,CHRTRAN(bb.nome_fantasia,";'", '' ) AS nome_fantasia;
      ,TDATA(aa.database) as dtbase ;
FROM   ASSOCIADO aa ;
JOIN   CONTRATO bb ON aa.idContrato=bb.IdContrato ;
WHERE  aa.situacao='ATIVO'  ;
OR (aa.situacao='CANCEL' AND aa.datacancela between DATE()-30 and DATE() ) ;
into cursor XVER


? DATETIME()

LOCAL lnFields

lnFieldCount = AFIELDS(laFields)

SCAN ALL

@ 12,10 say RECNO()
    lcRow = ""
    FOR lnFields = 1 TO lnFieldCount
    
        IF INLIST(laFields[lnFields,2], 'C', 'M')
            lcRow = lcRow + IIF(EMPTY(lcRow), "", ";") +;
                                ALLTRIM(CHRTRAN(EVALUATE(laFields[lnFields,1]),"';", ' '))
                            
        ELSE
            lcRow = lcRow + IIF(EMPTY(lcRow), "", ";") + ;
                            TRANSFORM(EVALUATE(laFields[lnFields,1]))
        ENDIF
        
    ENDFOR

    STRTOFILE( lcRow+CHR(13)+CHR(10), 'c:\tst.csv', .t. )
ENDSCAN
dFim = DATETIME()
?
? dFim 
? ( dFim - dIni ) /60

* =SQLDISCONNECT(hConn   )


FUNCTION TDATA( d )
IF EMPTY(d)
   cRet = SPACE(19)
ELSE
   IF YEAR(d) <= 1800
      cRet = SPACE(19)
   else
      cRet = TRANSFORM( DTOS(d), '@R 9999-99-99' )+'T19:02:00'
   endif
ENDIF 
RETURN cRet   
