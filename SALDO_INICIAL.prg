LPARAMETERS nKey, dPartida, cTpSaldo

LOCAL nKey, nCr, nDb, dPartida, nSld, cWhe

*-- data de referencia para verificacao do saldo é o final do mes anterior a data de partida
dRefSaldo = dPartida - DAY(dPartida)
*-- verifica as inforcoes de saldo anterior
SELECT saldo_r, saldo_v, encerrado FROM BANCO_SALDO WHERE idBanco=nKey AND ano=YEAR(dRefSaldo) AND mes=MONTH(dRefSaldo) INTO CURSOR (cTSld)

*-- cria um obj para usar como referencia na apuracao de saldo
oRefSaldo = CREATEOBJECT('EMPTY')
=ADDPROPERTY( oRefsaldo, 'saldo_R', NVL( &cTSld..saldo_R,0 ) )  &&... saldo real encerrado no mes anterior a data de partida
=ADDPROPERTY( oRefsaldo, 'saldo_V', NVL( &cTSld..saldo_V,0 ) )  &&... saldo contabil encerrado no mes anterior a data de partida
=ADDPROPERTY( oRefsaldo, 'dtRef',   dRefSaldo+1  )              &&... data a partir da qual deve se fazer apuração de saldo


nSld = 0
nCr  = 0
nDb  = 0

PTAB( nKey, "BANCO", "IDBANCO" )

*-- lancamentos do portador maior ou igual a data de partida
cWhe = 'BANCO.agrupa_portador='+TRAN(nKey)+' AND EXTRATO.DATA >= {^'+TRAN(DTOS(dPartida),[@R 9999-99-99]) +'}'
*-- quando saldo = REAL so processa registros com situacao=.t.
cWhe = cWhe +       IIF( cTpSaldo='R', ' AND EXTRATO.situacao=.T.', '' )


WAIT WINDOW "#1 Selecionando informacoes ... aguarde" NOWAIT NOCLEAR 
SELECT          EXTRATO.DATA, ;
                EXTRATO.historico, ;
                IIF( EXTRATO.Valor >= 0, EXTRATO.Valor, 000000000.00 ) AS Credito,;
                IIF( EXTRATO.Valor <  0, EXTRATO.Valor, 000000000.00 ) AS Debito,;
                VAL( STR( 0, 11, 2 ) ) AS Saldo, ;
                IIF(EXTRATO.situacao=.t.,"C", " ") as C,;
                EXTRATO.DOCUMENTO, ;
                EXTRATO.controle, ;
                EXTRATO.arq_origem, ;
                EXTRATO.cod_origem ;
FROM            EXTRATO ;
left OUTER JOIN BANCO ON EXTRATO.idBanco == BANCO.idBanco ;
WHERE           &cWhe ;
ORDER BY        1 ;
INTO CURSOR     CTMP2 READWRITE 




cWhe = 'BANCO.agrupa_portador=='+TRAN(nKey)+' AND EXTRATO.DATA < {^'+TRAN(DTOS(dPartida),[@R 9999-99-99]) +'}'
cWhe = cWhe +       IIF( ThisForm.opgSaldo.Value = 1, ' AND EXTRATO.situacao=.T.', '' )

WAIT WINDOW "#2 Selecionando informacoes ... aguarde" NOWAIT NOCLEAR 
SELECT          SUM(EXTRATO.Valor) ;
FROM            EXTRATO ;
left OUTER JOIN BANCO ON EXTRATO.idBanco == BANCO.idBanco ;
WHERE           &cWhe ;
INTO ARRAY      aTmp

nSld = 0
IF _TALLY > 0
   nSld = aTmp[1]
ENDIF

IF RECCOUNT("CTMP2") > 0
   INSERT INTO CTMP2 ;
   VALUES    ( dPartida - 1, PADR("SALDO ANTERIOR", 60, [.]), 0, 0, nSld, "", "", 0, '', 0 )
ENDIF   

GO TOP IN CTMP2

WAIT WINDOW "#3 Selecionando informacoes ... aguarde" NOWAIT NOCLEAR 
SELECT * FROM CTMP2 ORDER BY 1 INTO CURSOR CTMP

USE DBF("CTMP") IN 0 ALIAS CEXTR AGAIN
USE IN ( SELECT( "CTMP2" ) )

WAIT WINDOW "#4 Selecionando informacoes ... aguarde" NOWAIT NOCLEAR 
SELE CEXTR
GO TOP IN CEXTR
nSld = 0
SCAN
   IF RECNO("CEXTR") = 1
      nSld = CEXTR.Saldo
   ELSE
      nSld = nSld + CEXTR.Credito + CEXTR.Debito 
   ENDIF
   REPLACE CEXTR.Saldo WITH nSld IN CEXTR
ENDSCAN
GO TOP IN CEXTR

THISFORM.grd.RECORDSOURCE = "CEXTR"
THISFORM.grd.SetFocus
THISFORM.grd.Columns(2).Width = 335
THISFORM.grd.Columns(7).Width = 0
THISFORM.grd.Columns(8).Width = 0
THISFORM.grd.Columns(9).Width = 0
THISFORM.grd.Columns(10).Width = 0

ThisForm.Refresh

WAIT CLEAR

IF RECCOUNT( 'CEXTR' ) > 0 
  ThisForm.cbmImprime.SetFocus
ENDIF


