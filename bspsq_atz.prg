LPARAMETERS oReg, cOrigem, cAcao
LOCAL cKey, lUseBSPSQ, nSele, lAtend, cNome, cFantasia, lUseLV_BSPSQ
PRIVATE cFindCODIGO

cFindCODIGO  = ALLTRIM(oReg.Codigo)
nSele        = SELECT()
cAcao        = IIF( TYPE('cAcao')='C', cAcao, '' )

IF TYPE( 'oReg' ) = 'O' AND TYPE( 'cOrigem' ) = 'C' AND TYPE( 'cAcao' ) = 'C' AND PEMSTATUS(oReg, 'idContrato', 5 )

   lUseLV_BSPSQ = USED( 'BSPSQ' )

   IF NOT lUseLV_BSPSQ
      USE bdmdc!BSPSQ IN 0 SHARED
   ENDIF

   SELECT BSPSQ
   IF CURSORGETPROP("Buffering",'BSPSQ') < 3
      =CURSORSETPROP("Buffering",5)
   ENDIF

   IF TYPE('cAcao')='C' AND cAcao = 'DEL'

      DELETE ALL

   ELSE

      IF cAcao = 'INS' OR !SEEK( cFindCODIGO, 'BSPSQ', 'CODIGO' )
         APPEND BLANK  IN BSPSQ
      ENDIF

      cNome     = IIF( cOrigem = 'ASSOCIADO', oReg.NOME, oReg.nome_responsavel )
      cFantasia = IIF( cOrigem = 'ASSOCIADO', oReg.NOME, oReg.nome_fantasia    )
      lAtend    = IIF( cOrigem = 'ASSOCIADO', oReg.atendimento, ( ALLTRIM(oReg.situacao)=='ATIVO' ) )


      FI_REPLACE( 'BSPSQ', 'chv_filial ', SUBSTR( oReg.Codigo, 1, 2 ))
      FI_REPLACE( 'BSPSQ', 'chv_tipo   ', SUBSTR( oReg.Codigo, 3, 2 ))
      FI_REPLACE( 'BSPSQ', 'chv_numero ', SUBSTR( oReg.Codigo, 5, 6 ))
      FI_REPLACE( 'BSPSQ', 'chv_class  ', SUBSTR( oReg.Codigo,11, 2 ))
      FI_REPLACE( 'BSPSQ', 'situacao   ', oReg.situacao)
      FI_REPLACE( 'BSPSQ', 'dtcanc     ', oReg.dataCancela)
      FI_REPLACE( 'BSPSQ', 'NOME       ', cNome)
      FI_REPLACE( 'BSPSQ', 'FANTASIA   ', cFantasia)
      FI_REPLACE( 'BSPSQ', 'iniciais   ', oReg.iniciais)
      FI_REPLACE( 'BSPSQ', 'endereco   ', oReg.endereco)
      FI_REPLACE( 'BSPSQ', 'complemento', oReg.complemento)
      FI_REPLACE( 'BSPSQ', 'bairro     ', oReg.bairro)
      FI_REPLACE( 'BSPSQ', 'cep        ', oReg.cep)
      FI_REPLACE( 'BSPSQ', 'cidade     ', oReg.cidade)
      FI_REPLACE( 'BSPSQ', 'uf         ', oReg.uf)
      FI_REPLACE( 'BSPSQ', 'cpf        ', oReg.cpf)
      FI_REPLACE( 'BSPSQ', 'rg         ', oReg.rg)
      FI_REPLACE( 'BSPSQ', 'ficha      ', oReg.ficha)
      FI_REPLACE( 'BSPSQ', 'DATABASE   ', oReg.DATABASE)
      FI_REPLACE( 'BSPSQ', 'atendimento', lAtend)
      FI_REPLACE( 'BSPSQ', 'cpd        ', '<upd>'+ DTOS(DATE()) +'</upd>')
      FI_REPLACE( 'BSPSQ', 'codorigem  ', oReg.codorigem)
      FI_REPLACE( 'BSPSQ', 'idContrato ', oReg.idContrato)


      IF cOrigem = 'ASSOCIADO'

         =SEEK( oReg.idContrato, 'CONTRATO', 'I_D' )

         FI_REPLACE( 'BSPSQ', 'perto_de        ', oReg.perto_de)
         FI_REPLACE( 'BSPSQ', 'entre_ruas      ', oReg.entre_ruas)
         FI_REPLACE( 'BSPSQ', 'data_nascimento ', oReg.data_nascimento)
         FI_REPLACE( 'BSPSQ', 'sexo            ', oReg.sexo)
         FI_REPLACE( 'BSPSQ', 'codigo_antigo   ', oReg.oldCod)
         FI_REPLACE( 'BSPSQ', 'idAssoc         ', oReg.idAssoc)
         FI_REPLACE( 'BSPSQ', 'TIPO_CONTRATO   ', CONTRATO.TIPO_CONTRATO)

      ELSE
         FI_REPLACE( 'BSPSQ', 'codigo_antigo   ', oReg.oldKey)
         FI_REPLACE( 'BSPSQ', 'TIPO_CONTRATO   ', oReg.TIPO_CONTRATO)

      ENDIF

   ENDIF

   FLUSH
   =TABLEUPDATE(.T.)

   GO TOP IN BSPSQ

   IF NOT lUseLV_BSPSQ
      USE IN ( SELECT( 'BSPSQ' ) )
   ENDIF

ENDIF

SELECT (nSele)

RETURN
