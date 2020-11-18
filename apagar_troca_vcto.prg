FUNCTION apagar_troca_vcto( cAls )

LOCAL lOk
LOCAL cMsg, dVcto, nBuff, nCtrl, nPos, nPosAPA

dVcto = InBox( 'Novo vencimento', 'Troca de vencimento!', DATE()+1,,,'@E' )

IF ! EMPTY(dVcto)

   TEXT TO cMsg TEXTMERGE NOSHOW
   Todos os registro PENDENTES que estão na grade serão repassados
com vencimento <<dVcto>>

   Prosseguir?
   ENDTEXT


   IF MESSAGEBOX( cMsg, 32+4+256, 'Atenção' ) = 6

      IF USED( 'APAGAR' )

         nBuff   = CURSORGETPROP("Buffering")
         nPosAPA = RECNO('APAGAR')

         SELECT (cAls)
         nPos = RECNO()

         BEGIN TRANSACTION
         TRY


            lOk = .F.

            SCAN ALL
               IF EMPTY(&cAls..BAIXA)
                  nCtrl = &cAls..controle
                  IF SEEK( nCtrl, 'APAGAR', 'CONTROLE' )
                     REPLACE APAGAR.data_vencimento WITH dVcto
                     REPLACE apagar.dtprorrog       WITH dVcto
                  ENDIF
               ENDIF
            ENDSCAN

            IF nBuff >=3
               lOk = TABLEUPDATE(2,.T.,'APAGAR' )
            ELSE
               lOK = .t.
            ENDIF


         CATCH
         ENDTRY


         IF lOk
            END TRANSACTION
         ELSE
            ROLLBACK
            MESSAGEBOX( 'Falha no processo', 16, 'Atenção' )
         ENDIF

         SELECT (cAls)

         TRY
            GOTO nPosAPA IN APAGAR
            GOTO nPos
         CATCH
         ENDTRY

      ENDIF

   ENDIF

ENDIF

RETURN .T.
