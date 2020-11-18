#DEFINE CR_LF CHR(13)+CHR(10)

* PROCEDURE FI_EXP_ALODR
LOCAL cTmp
LOCAL cNomeArq, cAcao
LOCAL cCep,cSexo, cEstadoCivil, cCep, cCodigoMedicar, cFone1, cFone2, cDDD, cCpf, oErr
LOCAL lTrans, nQtdInc, nQtdCan, cEstadoCivel, cArqLOG

cArqLOG = '\\dcrpo\bdmem\Export\AloDr\LOG.TXT'

cTmp = SYS(2015)

=STRTOFILE( TRANSFORM(DATETIME())+' - Selecionando dados ...'+CR_LF, cArqLOG, 1 )

*!*	*-- seleciona os dados necessarios
*!*	Select          DISTINCT ;
*!*	                aa.nome as NomeAssociado, aa.endereco, aa.complemento, aa.bairro, aa.cidade, ;
*!*	                aa.uf, aa.cep, aa.CODIGO as CodigoAssoc,;
*!*	                IIF(SUBSTR(aa.codigo,11,2)='00','TIT','DEP') as TIPO,;
*!*	                aa.fone_residencia, aa.fone_comercial, aa.idAssoc as I_D,;
*!*	                aa.data_nascimento, aa.sexo, aa.estado_civil, aa.cpf, aa.rg, aa.dataBase,;
*!*	                aa.situacao ;
*!*	                ;
*!*	From            ASSOCIADO aa ;
*!*	LEFT Outer Join ASSOCIADO_PLANO ap On aa.idAssoc == ap.idAssoc ;
*!*	WHERE           aa.situacao='ATIVO'      ;
*!*	            AND LEFT(aa.codigo,2)='01'   ;
*!*	            AND aa.atendimento=.T.       ;
*!*	            AND (   ap.idPlano = 23 OR   ;
*!*	                  ( ap.idPlano = 25 AND SUBSTR(aa.codigo,3,2)='FA' ) ) ;
*!*	INTO Cursor     (cTmp) Readwrite




*--- seleciona produto 23
Select          DISTINCT ;
                aa.nome as NomeAssociado, aa.endereco, aa.complemento, aa.bairro, aa.cidade, ;
                aa.uf, aa.cep, aa.CODIGO as CodigoAssoc,;
                IIF(SUBSTR(aa.codigo,11,2)='00','TIT','DEP') as TIPO,;
                aa.fone_residencia, aa.fone_comercial, aa.idAssoc as I_D,;
                aa.data_nascimento, aa.sexo, aa.estado_civil, aa.cpf, aa.rg, aa.dataBase,;
                aa.situacao ;
                ;
From            ASSOCIADO aa ;
LEFT Outer Join ASSOCIADO_PLANO ap On aa.idAssoc == ap.idAssoc ;
WHERE           aa.situacao='ATIVO'      ;
            AND LEFT(aa.codigo,2)='01'   ;
            AND aa.atendimento=.T.       ;
            AND ap.idPlano = 23          ;
INTO Cursor     (cTmp) Readwrite


*---- GERA O ARQUIVO TEXTO
cNomeArq    = '\\dcrpo\bdmem\Export\AloDr\'+ DTOS(DATE()) +'_23.APH'
nQtdInc     = 0
nQtdCan     = 0

=STRTOFILE( TRANSFORM(DATETIME())+' - Criando '+cNomeArq+CR_LF, cArqLOG, 1 )

SET TEXTMERGE TO (cNomeArq) NOSHOW 
SET TEXTMERGE ON

****************************** Header
\\MEDICAR<<CHR(9)>>
\\<<DTOC(DATE())+CHR(9)>>
\\<<RECCOUNT(cTmp)>><<CHR(9)>>


****************************** DETALHES
SELECT (cTmp)
GO TOP

SCAN

   cCep           = STRTRAN( cep, '.', '' )
   cSexo          = LEFT(sexo,1)
   cCep           = ALLTRIM(STRTRAN(STRTRAN(cep,'.',''),'-',''))
   cCodigoMedicar = ALLTRIM(CodigoAssoc)
   cFone2         = ALLTRIM(SUBSTR(fone_residencia,4))
   cDDD           = ALLTRIM( LEFT( fone_residencia, 3 ))
   cCpf           = PADR(STRTRAN(STRTRAN(cpf,'.',''),'-'),11)

   \<<cCodigoMedicar>><<CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<ALLTRIM(NomeAssociado)+CHR(9)>>
   \\<<cSexo+CHR(9)>>
   \\<<DTOC(data_nascimento)+CHR(9)>>
   \\<<ALLTRIM(rg)+CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<ALLTRIM(cCpf)+CHR(9)>>
   \\<<ALLTRIM(Endereco)+CHR(9)>>
   \\<<ALLTRIM(complemento)+CHR(9)>>
   \\<<ALLTRIM(Bairro)+CHR(9)>>
   \\<<ALLTRIM(Cidade)+CHR(9)>>
   \\<<ALLTRIM(UF)+CHR(9)>>
   \\<<ALLTRIM(cCep)+CHR(9)>>
   \\<<cDDD+CHR(9)>>
   \\<<PADR(cFone2,12)+CHR(9)>>
   \\23<<CHR(9)>>
   
ENDSCAN

SET TEXTMERGE OFF
SET TEXTMERGE TO

CLOSE DATABASES all
CLOSE TABLES all

=STRTOFILE( TRANSFORM(DATETIME())+' - Enviando email '+CR_LF, cArqLOG, 1 )

TRY 

   iMsg          = Createobject("CDO.Message")
   iMsg.From     = 'informatica@medicar.com.br'
   iMsg.Subject  = 'Atualização de associados da Medicar (Produto 23)'
   iMsg.To       = "informatica@alodrsp.com.br"
   iMsg.BCC      = 'informatica@medicar.com.br'
   iMsg.TextBody = "Atualização de associados da Medicar com produto ALODR " +;
                   "Atualizado em "+TRANSFORM(DATETIME())
   iMsg.AddAttachment(cNomeArq)
   iMsg.Send
   Release iMsg
   
   =STRTOFILE( TRANSFORM(DATETIME())+' - Email enviado com sucesso '+CR_LF, cArqLOG, 1 )
   
CATCH TO loError
   
    SET TEXTMERGE TO ('\\dcrpo\bdmem\Export\AloDr\SM'+TTOC(DATETIME(),1)+'.ERR' )
    SET TEXTMERGE ON
    \      Erro: <<loError.ERRORNO>>
    \     Linha: <<loError.LINENO>>
    \   Mensage: <<loError.MESSAGE>>
    \ Procedure: <<loError.PROCEDURE>>
    \  Detalhes: <<loError.DETAILS>>
    \StackLevel: <<loError.STACKLEVEL>>
    \Comentario: <<loError.LINECONTENTS>>
    SET TEXTMERGE OFF
    SET TEXTMERGE TO

   =STRTOFILE( TRANSFORM(DATETIME())+' - Falha no envio de email '+CR_LF, cArqLOG, 1 )

ENDTRY

=STRTOFILE( TRANSFORM(DATETIME())+' - Final do processo '+CR_LF, cArqLOG, 1 )




*--- produto 25
=STRTOFILE( TRANSFORM(DATETIME())+' - Selecionando dados ...'+CR_LF, cArqLOG, 1 )
*-- seleciona os dados necessarios
Select          DISTINCT ;
                aa.nome as NomeAssociado, aa.endereco, aa.complemento, aa.bairro, aa.cidade, ;
                aa.uf, aa.cep, aa.CODIGO as CodigoAssoc,;
                IIF(SUBSTR(aa.codigo,11,2)='00','TIT','DEP') as TIPO,;
                aa.fone_residencia, aa.fone_comercial, aa.idAssoc as I_D,;
                aa.data_nascimento, aa.sexo, aa.estado_civil, aa.cpf, aa.rg, aa.dataBase,;
                aa.situacao ;
                ;
From            ASSOCIADO aa ;
LEFT Outer Join ASSOCIADO_PLANO ap On aa.idAssoc == ap.idAssoc ;
WHERE           aa.situacao='ATIVO'               ;
            AND aa.data_cadastro <= {^2008-01-22} ;
            AND LEFT(aa.codigo,2)='01'            ;
            AND aa.atendimento=.T.                ;
            AND ap.idPlano = 25                   ;
            AND SUBSTR(aa.codigo,3,2)='FA'        ;
INTO Cursor     (cTmp) Readwrite

*---- GERA O ARQUIVO TEXTO
cNomeArq    = '\\dcrpo\bdmem\Export\AloDr\'+ DTOS(DATE()) +'_25.APH'
nQtdInc     = 0
nQtdCan     = 0

=STRTOFILE( TRANSFORM(DATETIME())+' - Criando '+cNomeArq+CR_LF, cArqLOG, 1 )
SET TEXTMERGE TO (cNomeArq) NOSHOW 
SET TEXTMERGE ON
****************************** Header
\\MEDICAR<<CHR(9)>>
\\<<DTOC(DATE())+CHR(9)>>
\\<<RECCOUNT(cTmp)>><<CHR(9)>>
****************************** DETALHES
SELECT (cTmp)
GO TOP
SCAN
   cCep           = STRTRAN( cep, '.', '' )
   cSexo          = LEFT(sexo,1)
   cCep           = ALLTRIM(STRTRAN(STRTRAN(cep,'.',''),'-',''))
   cCodigoMedicar = ALLTRIM(CodigoAssoc)
   cFone2         = ALLTRIM(SUBSTR(fone_residencia,4))
   cDDD           = ALLTRIM( LEFT( fone_residencia, 3 ))
   cCpf           = PADR(STRTRAN(STRTRAN(cpf,'.',''),'-'),11)
   \<<cCodigoMedicar>><<CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<ALLTRIM(NomeAssociado)+CHR(9)>>
   \\<<cSexo+CHR(9)>>
   \\<<DTOC(data_nascimento)+CHR(9)>>
   \\<<ALLTRIM(rg)+CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<ALLTRIM(cCpf)+CHR(9)>>
   \\<<ALLTRIM(Endereco)+CHR(9)>>
   \\<<ALLTRIM(complemento)+CHR(9)>>
   \\<<ALLTRIM(Bairro)+CHR(9)>>
   \\<<ALLTRIM(Cidade)+CHR(9)>>
   \\<<ALLTRIM(UF)+CHR(9)>>
   \\<<ALLTRIM(cCep)+CHR(9)>>
   \\<<cDDD+CHR(9)>>
   \\<<PADR(cFone2,12)+CHR(9)>>
   \\25<<CHR(9)>>
ENDSCAN
SET TEXTMERGE OFF
SET TEXTMERGE TO
CLOSE DATABASES all
CLOSE TABLES all

=STRTOFILE( TRANSFORM(DATETIME())+' - Enviando email '+CR_LF, cArqLOG, 1 )

TRY 
   iMsg          = Createobject("CDO.Message")
   iMsg.From     = 'informatica@medicar.com.br'
   iMsg.Subject  = 'Atualização de associados da Medicar (Produto 25)'
   iMsg.To       = "informatica@alodrsp.com.br"
   iMsg.BCC      = 'informatica@medicar.com.br'
   iMsg.TextBody = "Atualização de associados da Medicar com produto ALODR " +;
                   "Atualizado em "+TRANSFORM(DATETIME())
   iMsg.AddAttachment(cNomeArq)
   iMsg.Send
   Release iMsg
   =STRTOFILE( TRANSFORM(DATETIME())+' - Email enviado com sucesso '+CR_LF, cArqLOG, 1 )
CATCH TO loError
    SET TEXTMERGE TO ('\\dcrpo\bdmem\Export\AloDr\SM'+TTOC(DATETIME(),1)+'.ERR' )
    SET TEXTMERGE ON
    \      Erro: <<loError.ERRORNO>>
    \     Linha: <<loError.LINENO>>
    \   Mensage: <<loError.MESSAGE>>
    \ Procedure: <<loError.PROCEDURE>>
    \  Detalhes: <<loError.DETAILS>>
    \StackLevel: <<loError.STACKLEVEL>>
    \Comentario: <<loError.LINECONTENTS>>
    SET TEXTMERGE OFF
    SET TEXTMERGE TO
   =STRTOFILE( TRANSFORM(DATETIME())+' - Falha no envio de email '+CR_LF, cArqLOG, 1 )
ENDTRY

=STRTOFILE( TRANSFORM(DATETIME())+' - Final do processo '+CR_LF, cArqLOG, 1 )
