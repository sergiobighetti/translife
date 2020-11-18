*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
****************************************************************************************
procedure FI_EXTRATO( nAcao )
****************************************************************************************
* CONTROLA OS SALDOS EM BANCO
local nRecno, nChv, lOldSituacao, nOldIdBco, nOldValor, lBcoAberto, nBuff, lOk
local lNewSituacao, nNewSituacao, nNewValor, oRpl, lRpl, lBcoRlp

nSele = SELECT()


IF TYPE( 'glExecSP_Extrato' ) = 'L' && se existe a variavel que diz para executar a SP
   IF NOT glExecSP_Extrato          && e a chave esta desligada
      RETURN .t.                    && nao executa a SP
   ENDIF
ENDIF 

lBcoAberto = used( 'BANCO' )

if not lBcoAberto
   use BANCO in 0 shared
endif


***********************
lBcoRlp= used( 'EXTRATO_RPL' )
if not lRpl
   use EXTRATO_RPL in 0 shared
endif
SCATTER NAME oRpl
***********************

begin transaction

try

   nBuff = cursorgetprop( "Buffering", "BANCO" )

   if nBuff < 3
      =cursorsetprop( "Buffering", 5, "BANCO" )
   endif

   nChv         = EXTRATO.idBanco
   lNewSituacao = EXTRATO.situacao
   nNewValor    = EXTRATO.valor

   do case

      case nAcao = 1 && Inclusao

         if nNewValor <> $0

            if lNewSituacao
               update BANCO ;
               set    BANCO.saldo_banco = ( BANCO.saldo_banco + nNewValor ) ;
               where  BANCO.idBanco == nChv
            endif

            update BANCO ;
            set    BANCO.saldo_contabil = ( BANCO.saldo_contabil + nNewValor ) ;
            where  BANCO.idBanco == nChv
            
***********************
            INSERT INTO EXTRATO_RPL FROM NAME oRpl
***********************

         endif

      case nAcao = 2 && Manutencao

         
***********************
         SELECT EXTRATO_RPL
         LOCATE FOR controle=oRpl.controle
         IF FOUND()
            GATHER NAME oRpl
         ELSE
            INSERT INTO EXTRATO_RPL FROM NAME oRpl
         ENDIF
         SELECT (nSele)
***********************

         lOldSituacao  = oldval( "situacao", "EXTRATO")
         nOldIdBco     = oldval( "idBanco",  "EXTRATO")
         nOldValor     = oldval( "valor",    "EXTRATO")

         if nOldValor <> $0
            if lOldSituacao
               update BANCO ;
               set    BANCO.saldo_banco = ( BANCO.saldo_banco - nOldValor ) ;
               where  BANCO.idBanco == nOldIdBco
            endif
            update BANCO ;
            set    BANCO.saldo_contabil = ( BANCO.saldo_contabil - nOldValor ) ;
            where  BANCO.idBanco == nOldIdBco
         endif

         if nNewValor <> $0
            if lNewSituacao
               update BANCO ;
               set    BANCO.saldo_banco = ( BANCO.saldo_banco + nNewValor ) ;
               where  BANCO.idBanco == nChv
            endif
            update BANCO ;
            set    BANCO.saldo_contabil = ( BANCO.saldo_contabil + nNewValor ) ;
            where  BANCO.idBanco == nChv
         endif

      case nAcao = 3 && Exclusao

         if nNewValor <> $0
            if lNewSituacao
               update BANCO ;
               set    BANCO.saldo_banco = ( BANCO.saldo_banco - nNewValor ) ;
               where  BANCO.idBanco == nChv
            endif
            update BANCO ;
            set    BANCO.saldo_contabil = ( BANCO.saldo_contabil - nNewValor ) ;
            where  BANCO.idBanco == nChv
***********************
            DELETE FROM EXTRATO_RPL WHERE controle=oRpl.controle
***********************
         endif

   endcase
   go top in BANCO

   lOk = tableupdate( 2, .t., 'BANCO' )

catch

   lOk = .f.

endtry

if lOk
   end transaction
else
   rollback
endif

***********************
if not lBcoRlp
   GO TOP IN 'EXTRATO_RPL'
   use in ( select( "EXTRATO_RPL" ) )
ENDIF   
***********************

if not lBcoAberto
   use in ( select( "BANCO" ) )
else
   =seek( nChv, 'BANCO', 'IDBANCO' )
endif

SELECT (nSele)

return .t.
