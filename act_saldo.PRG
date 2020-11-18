Clear
Close Databases All
Close Tables All

SET EXCLUSIVE OFF
SET DELETED ON
SET ESCAPE ON

cDir = 'c:\desenv\win\vfp9\sca_new\'

Use cDir+"banco" In 0
Use cDir+"banco_saldo" In 0 Exclusive
Use cDir+"extrato" In 0

SELECT banco_saldo 
zap

Select banco
Scan All

   nID = banco.idbanco
   ?
   ? nID

   Select      aa.controle, aa.tipo, aa.idbanco, aa.Data, aa.valor, aa.situacao;
   FROM        cDir+"extrato" aa ;
   JOIN        cDir+"banco" bb ON bb.idbanco = aa.idbanco ;
   WHERE       aa.idbanco = nID ;
   ORDER By    Data ;
   INTO Cursor C1

   Select C1

   
   l1aVez = .T.
   Do While !Eof( 'C1' )
      ?? [.]
      If l1aVez
         nSld_r = 0
         nSld_v = 0
         l1aVez = .F.
      Else
         nSld_r = nSld_r
         nSld_v = nSld_v
      Endif

      cAAMM = Left(Dtos(Data),6)

      nQtdRe = 0
      Scan While Left(Dtos(Data),6) == cAAMM
         IF situacao=.t.
            nSld_r = nSld_r + valor
         ENDIF
         nSld_v = nSld_v + valor
         nQtdRe = nQtdRe + 1
      Endscan
      Insert Into banco_saldo ;
         ( idbanco, ano, mes, saldo_r, saldo_v, qtdReg ) ;
         VALUES ;
         ( nID,    Val(Left(cAAMM,4)), Val(Right(cAAMM,2)), nSld_r, nSld_v, nQtdRe )

   Enddo

   SELECT BANCO
   
ENDSCAN    



