CLEAR
? TR_SQL( 'CONTRATO', 'idContrato', 100, 'D' )

FUNCTION TR_SQL( cTabela, cFldChv, _Chave, cAcao )
* Replicar ENVIA informações para SQLSINCR (sincronizador SQL)
LOCAL nSel, x,laClosed[1], aOpen[1], tAgora, lAbriuSQLSINCR , cChv   

nSel = SELECT()

IF FILE('SQLSINCR.DBF')

   lAbriuSQLSINCR = .f.
   IF ! USED('SQLSINCR')
      USE SQLSINCR IN 0 SHARED NODATA
      lAbriuSQLSINCR = .t.
   ENDIF 
  
   tAgora = DATETIME()
   cChv   = LEFT( SYS(2015)+':'+TTOC(tAgora,1)+'_'+ALLTRIM(cTabela)+'.'+ALLTRIM(cFldChv)+'='+ALLTRIM(TRANSFORM(_Chave)), 50 )
  
   INSERT INTO SQLSINCR ( ID, Dtcad, ori, ori_fldchv, ori_id, Acao, auditoria ) ;
     VALUES ;
     (  ;
        cChv              ;   && ID
      , tAgora            ;   && Dtcadastro 
      , cTabela           ;   && ori (Origem)
      , cFldChv           ;   && ori_fldchv (Nome do campo chave)
      , TRANSFORM(_Chave) ;   && ori_id (valor do campo chave)
      , cAcao             ;   && Acao       
      , m.drvNomeUsuario  ;   && auditoria 
     )

   IF lAbriuSQLSINCR
      USE IN ( SELECT('SQLSINCR') )
   ENDIF 

ENDIF 

Select (nSel)

RETURN .t.