#DEFINE CR_LF CHR(13)+CHR(10)

* PROCEDURE FI_EXP_CEMED
LOCAL cTmp
LOCAL cNomeArq, cAcao
LOCAL cCep,cSexo, cEstadoCivil, cCep, cCodigoMedicar, cFone1, cFone2, cDDD, cCpf, oErr
LOCAL lTrans, nQtdInc, nQtdCan, cEstadoCivel, cArqLOG, cNomeARJ

cArqLOG = '\\dcrpo\bdmem\Export\CEMED\LOG.TXT'

cTmp = SYS(2015)

=STRTOFILE( TRANSFORM(DATETIME())+' - Selecionando dados ...'+CR_LF, cArqLOG, 1 )

*-- seleciona ALODR
Select          DISTINCT  ;
                uu.IdAssoc ;
                ;
From            ASSOCIADO uu ;
LEFT Outer Join ASSOCIADO_PLANO ap On uu.idAssoc == ap.idAssoc ;
WHERE           uu.situacao='ATIVO'          ;
                AND LEFT(uu.codigo,2)='01'   ;
                AND uu.atendimento=.T.       ;
                AND (   ap.idPlano = 23 OR   ;
                      ( ap.idPlano = 25 AND SUBSTR(uu.codigo,3,2)='FA' ) ) ;
INTO CURSOR     CL_ALODR                

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
WHERE           LEFT(aa.codigo,2)  = '01'   ;
            AND aa.situacao        = 'ATIVO';
            AND aa.atendimento     = .T.    ;
            AND aa.idAssoc NOT IN (SELECT idAssoc FROM CL_ALODR ) ;
INTO Cursor     (cTmp) Readwrite




*---- GERA O ARQUIVO TEXTO
cNomeARJ    = '\\dcrpo\bdmem\Export\CEMED\'+ DTOS(DATE()) +'.ARJ'
cNomeArq    = '\\dcrpo\bdmem\Export\CEMED\MEDICAR_CEMED.TXT'

IF FILE(cNomeArq)
   DELETE FILE (cNomeArq)
ENDIF   

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

   cCep           = STRTRAN( NVL(cep,''), '.', '' )
   cSexo          = LEFT(NVL(sexo,''),1)
   cCep           = ALLTRIM(STRTRAN(STRTRAN(NVL(cep,''),'.',''),'-',''))
   cCodigoMedicar = ALLTRIM(NVL(CodigoAssoc,''))
   cFone2         = ALLTRIM(SUBSTR(NVL(fone_residencia,''),4))
   cDDD           = ALLTRIM( LEFT( NVL(fone_residencia,''), 3 ))
   cCpf           = PADR(STRTRAN(STRTRAN(NVL(cpf,''),'.',''),'-'),11)
   
   TRY 
      IF EMPTY(data_nascimento)
         cDtNasc = ""
      ELSE
         cDtNasc = DTOC(data_nascimento)
      ENDIF
   CATCH
      cDtNasc = ""
   ENDTRY

   \<<cCodigoMedicar>><<CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<ALLTRIM(NVL(NomeAssociado,''))+CHR(9)>> 
   \\<<cSexo+CHR(9)>>
   \\<<cDtNasc+CHR(9)>>
   \\<<ALLTRIM(rg)+CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<CHR(9)>>
   \\<<ALLTRIM(cCpf)+CHR(9)>>
   \\<<ALLTRIM(NVL(Endereco,''))+CHR(9)>>
   \\<<ALLTRIM(NVL(complemento,''))+CHR(9)>>
   \\<<ALLTRIM(NVL(Bairro,''))+CHR(9)>>
   \\<<ALLTRIM(NVL(Cidade,''))+CHR(9)>>
   \\<<ALLTRIM(NVL(UF,''))+CHR(9)>>
   \\<<ALLTRIM(cCep)+CHR(9)>>
   \\<<cDDD+CHR(9)>>
   \\<<PADR(cFone2,12)+CHR(9)>>

ENDSCAN

SET TEXTMERGE OFF
SET TEXTMERGE TO

CLOSE DATABASES all
CLOSE TABLES all


cCmdARJ = '\\dcrpo\bdmem\Export\ARJ32 a '+cNomeARJ+' '+cNomeArq+' -e -y'

Shell = Createobject("WScript.Shell") 
Shell.Run(cCmdARJ) 
RELEASE Shell

*-- da um tempo 
=INKEY(15)

=STRTOFILE( TRANSFORM(DATETIME())+' - Enviando email '+CR_LF, cArqLOG, 1 )

TRY 

   iMsg          = Createobject("CDO.Message")
   iMsg.From     = 'informatica@medicar.com.br'
   iMsg.Subject  = 'Atualização de associados da Medicar (CEMED)'
   iMsg.To       = "informatica@alodrsp.com.br"
   iMsg.BCC      = 'informatica@medicar.com.br'
   iMsg.TextBody = "Atualização de associados da Medicar (CEMED) " +;
                   "Atualizado em "+TRANSFORM(DATETIME())
   iMsg.AddAttachment(cNomeARJ)
   iMsg.Send
   Release iMsg
   
   =STRTOFILE( TRANSFORM(DATETIME())+' - Email enviado com sucesso '+CR_LF, cArqLOG, 1 )
   
CATCH TO loError
   
    SET TEXTMERGE TO ('\\dcrpo\bdmem\Export\CEMED\SM'+TTOC(DATETIME(),1)+'.ERR' )
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
