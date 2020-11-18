Clear

dRef = {^2008-01-01}
dRefDT = DATETIME()
PUBLIC glExecSP_Extrato
m.glExecSP_Extrato = .f.

Close Databases All
Close Tables All
SET DELETED on
SET ESCAPE ON

Use banco In 0
Use banco_saldo In 0 Exclusive
Use extrato In 0

SELECT banco_saldo 
zap

Select banco
Scan All

   nID = banco.idbanco
   ?
   ? nID

   Select      aa.controle, aa.tipo, aa.idbanco, aa.Data, aa.valor;
   FROM        extrato aa ;
   WHERE       aa.idbanco = nID        ; && lancamentos do banco
           AND !EMPTY(aa.data) AND aa.Data < dRef          ; && anterior a data
           AND aa.situacao=.t.         ; && somente consolidados
   ORDER By    aa.Data ;
   INTO Cursor C1

   Select C1

   nSldFIM = 0
   l1aVez = .T.
   Do While !Eof( 'C1' )
      ?? [.]
      If l1aVez
         nSldINI = 0
         l1aVez = .F.
      Else
         nSldINI = nSldFIM
      Endif

      cAAMM = Left(Dtos(Data),6)
      nQtdLanc  = 0
      Scan While Left(Dtos(Data),6) == cAAMM
         nCtrl = C1.controle
         nQtdLanc = nQtdLanc + 1 
         nSldFIM = nSldFIM + valor
         DELETE FROM extrato WHERE controle=nCtrl
      ENDSCAN
      
      dFimMes = DATE( Val(Left(cAAMM,4)), Val(Right(cAAMM,2)), 15 )
      dFimMes = dFimMes + 20
      dFimMes = dFimMes - DAY(dFimMes)
      
      INSERT INTO EXTRATO ( TIPO, idbanco, data, historico, documento, valor, situacao, arq_origem, auditoria ) ;
      VALUES ( IIF(nSldFIM>0,2,4), nId, dFimMes, 'COMPACTAÇÃO DE '+TRANSFORM(nQtdLanc)+' LANÇAMENTOS ', 'CPCT'+cAAMM, nSldFIM, .t., 'COMPACTA',;
      '<I>SERGIO '+TRANSFORM(dRefDT)+'</I> ' )
      
      Insert Into banco_saldo ;
         ( idbanco, ano, mes, saldo_ini, saldo_fim ) ;
         VALUES ;
         ( nID,    Val(Left(cAAMM,4)), Val(Right(cAAMM,2)), nSldINI, nSldFIM )

   Enddo

   SELECT BANCO
   
ENDSCAN    



