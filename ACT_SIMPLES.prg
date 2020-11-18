CLOSE DATABASES ALL
CLOSE TABLES ALL
CLEAR

USE contrato    IN 0
USE ver_simples IN 0 ALIAS als

LOCAL cPass, cRet, cUrl, cUsr, cXML, cAls

cAls = 'als'

SELECT (cAls)
GO TOP

SET STEP ON

DO WHILE !EOF()

   IF EMPTY(ver_ws)
      SKIP
      LOOP
   ENDIF

   nIdContr = &cAls..idContrato
   cRet     = &cAls..ver_ws

   *   Optante pelo Simples Nacional des
   * <OpcaoSimplesNacional>NÃO optante pelo Simples Nacional</OpcaoSimplesNacional>
   IF STREXTRACT( cRet, '<CodErro>', '</CodErro>' ) == '0'

      IF SEEK( nIdContr, 'CONTRATO', 'I_D' )

         IF RLOCK( 'CONTRATO' )

            SELECT contrato
            cSimples = STREXTRACT( cRet, '<OpcaoSimplesNacional>', '</OpcaoSimplesNacional>',1 )
            IF cSimples = 'N'
               ?? [n]
               REPLACE  contrato.optante   WITH .T.
               REPLACE  contrato.ir        WITH 1.5
               REPLACE  contrato.ir_limite WITH 667
               REPLACE  contrato.iss       WITH 2
               REPLACE  contrato.inss      WITH 0
               REPLACE  contrato.pis       WITH 0.65
               REPLACE  contrato.cofins    WITH 3
               REPLACE  contrato.csocial   WITH 1
               REPLACE  contrato.inss_base WITH 0
               REPLACE  contrato.retem_iss WITH .F.
            ELSE
               ?? [Y]
               REPLACE  contrato.optante   WITH .F.
               REPLACE  contrato.ir        WITH 1.5
               REPLACE  contrato.ir_limite WITH 667
               REPLACE  contrato.iss       WITH 2
               REPLACE  contrato.inss      WITH 0
               REPLACE  contrato.pis       WITH 0
               REPLACE  contrato.cofins    WITH 0
               REPLACE  contrato.csocial   WITH 0
               REPLACE  contrato.inss_base WITH 0
               REPLACE  contrato.retem_iss WITH .F.
            ENDIF
            UNLOCK IN contrato

         ENDIF
      ENDIF

   ENDIF
   SELECT (cAls)
   SKIP

ENDDO