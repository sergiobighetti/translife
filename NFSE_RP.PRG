CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON

USE NFISCAL       IN 0
USE IFISCAL       IN 0
USE NFISCAL_RPS   IN 0
USE CONTRATO      IN 0
USE FILIAL        IN 0
USE IBGE          IN 0 

LOCAL cCnpjCPF, cArqRPS, nCtrl, cTmp

cArqRPS = 'c:\testeRPS.TXT'

cNfTmp = SYS(2015) && ,436901,437059   527872
SELECT * FROM NFISCAL WHERE controle IN ( 436901,437059 ) INTO CURSOR (cNfTmp)


Set Textmerge To (cArqRPS) Noshow
Set Textmerge On


CLEAR

SELECT (cNfTmp)
GO TOP 


Do While !Eof(cNfTmp)

   nCtrl = &cNfTmp..controle
   ? nCtrl
   
   
   =SEEK( nCtrl,              'NFISCAL',     'CONTROLE' )
   =SEEK( NFISCAL.idFilial,   'FILIAL',      'IDFILIAL' )
   =SEEK( NFISCAL.idContrato, 'CONTRATO',    'I_D'      )
   =SEEK( nCtrl,              'NFISCAL_RPS', 'CONTROLE' )
   

   *IdentificacaoRps\Numero\N\15
   \\<<PADL(ALLTRIM(NFISCAL_RPS.rps),15,'0')>>

   *IdentificacaoRps\Serie\C\5
   \\<<NFISCAL_RPS.serie>>

   *IdentificacaoRps\Tipo\C\1  (RPS)
   \\<<'1'>>

   *DataEmissao
   \\<<TTOC(NFISCAL_RPS.emissao,3)>>

   *NaturezaOperacao
   \\<<'1'>>

   *RegimeEspecialTributacao
   \\<<' '>>

   *OptanteSimplesNacional
   \\<<'2'>>

   *IncentivoCultural
   \\<<'2'>>

   *Status
   \\<<'1'>>

   *RpsSubstituido
   \\<<SPACE(15)>>
   \\<<SPACE(5)>>
   \\<<SPACE(1)>>

   *Servivo\Valores\ValorServico N15,2
   \\<<fi_Vlr0(NFISCAL.valorbruto)>>

   *Servivo\Valores\ValorDeducoes N15,2
   \\<<fi_Vlr0(0)>>

   *Servivo\Valores\ValorPis N15,2
   \\<<fi_Vlr0(NFISCAL.pis_valor)>>

   *Servivo\Valores\ValorCofins N15,2
   \\<<fi_Vlr0(NFISCAL.cofins_valor)>>

   *Servivo\Valores\ValorInss N15,2
   \\<<fi_Vlr0(NFISCAL.inss_valor)>>

   *Servivo\Valores\ValorIR N15,2
   \\<<fi_Vlr0(NFISCAL.ir_valor)>>

   *Servivo\Valores\ValorCsll N15,2
   \\<<fi_Vlr0(NFISCAL.csoc_valor)>>

   *Servivo\Valores\IssRetido ???
   \\<<IIF(nfiscal.retem_iss,'1','2')>>
   

   *Servivo\Valores\ValorIss N15,2
   \\<<fi_Vlr0(NFISCAL.iss_valor)>>

   *Servivo\Valores\ValorIssRetido N15,2 ???
   \\<<fi_Vlr0(IIF(nfiscal.retem_iss,NFISCAL.iss_valor,0))>>

   *Servivo\Valores\OutrasRetencoes N15,2
   \\<<fi_Vlr0(0)>>

   *Servivo\Valores\BaseCalculo N15,2
   \\<<fi_Vlr0(NFISCAL.valorbruto)>>

   *Servivo\Valores\Aliquota N5
   \\<<fi_Vlr0(2,5)>>

   *Servivo\Valores\ValorLiquidoNfse N15,2
   \\<<fi_Vlr0(NFISCAL.valorliquido)>>

   *Servivo\Valores\DescontoIncondicionado N15,2
   \\<<fi_Vlr0(0)>>

   *Servivo\Valores\DescontoCondicionado N15,2
   \\<<fi_Vlr0(0)>>

   *Servivo\ItemListaServico
   \\<<'4.21 '>>

   *Servivo\CodigoCnae
   \\<<'0000000'>>

   *Servivo\CodigoTributacaoMunicipio
               
   \\<<PADL('04.21.00 / 00042100',20)>>
   * \\<<'042100              '>>

   *Servivo\Discriminacao
   \\<<FI_SERVICO(nCtrl,2000)>>

   *Servivo\CodigoMunicipio
   \\<<'3543402'>>


   *Prestador\Cnpj
   \\<< PADR( CHRTRAN( FILIAL.cgc, ' .-/','' ),14 )>>

   *Prestador\Inscrição Municipal
   \\<<PADR('7411101',15)>>



   cCnpjCPF = Alltrim( Chrtran( NFISCAL.cnpj_cnpf, ' .-/','' ) )

   *Tomador\IdentificacaoTomador\CpfCnpj\CPF
   \\<< PADR( IIF( LEN(cCnpjCPF)=11, cCnpjCPF, '' ), 11 ) >>

   *Tomador\IdentificacaoTomador\CpfCnpj\CNPJ
   \\<< PADR( IIF( LEN(cCnpjCPF)=14, cCnpjCPF, '' ), 14 ) >>

   *Tomador\IdentificacaoTomador\InscriçãoMunicipal
   \\<< SPACE(15) >>

   *Tomador\RazaoSocial
   \\<< PADR( NFISCAL.nomeempresa, 115 ) >>

   *Tomador\Endereco
   \\<< PADR( NFISCAL.endereco, 125 ) >>

   *Tomador\Numero
   \\<< PADR( so_nro(NFISCAL.endereco), 10 ) >>

   *Tomador\complemento
   \\<< PADR( NFISCAL.end_compl, 60 ) >>

   *Tomador\bairro
   \\<< PADR( NFISCAL.bairro, 60 ) >>

   *Tomador\CodigoMunicipio
   \\<< FI_CODMUNIC( NFISCAL.cidade, NFISCAL.uf ) >>

   *Tomador\UF
   \\<< NFISCAL.uf >>

   *Tomador\CEP
   \\<< PADR(CHRTRAN( NFISCAL.cep, '.-* ', '' ),8) >>

   *Tomador\Contrato\Fone
   \\<< PADR(CHRTRAN( CONTRATO.fone, '.-*() ', '' ),11) >>

   *Tomador\Contrato\Email
   \\<< PADR( CHRTRAN( ALLTRIM(CONTRATO.email), ' ', '' ),80) >>

   *ItermediaruiServico
   \\<<SPACE(115)>>
   \\<<SPACE(011)>>
   \\<<SPACE(014)>>
   \\<<SPACE(015)>>
 
   *ContruçãoCivil
   \\<<SPACE(015)>>
   \\<<SPACE(015)>>

   SKIP IN (cNfTmp)
   
   IF EOF(cNfTmp)
      exit
   ENDIF 
   \
   
Enddo


Set Textmerge Off
Set Textmerge To





FUNCTION so_nro( cEnd )
LOCAL nTam
nTam = LEN(cEnd)
cRet = ''
FOR i=1 TO nTam
   cPos = SUBSTR(cEnd,i,1)
   IF !EMPTY(cPos)
      IF ISDIGIT(cPos)
         cRet = cRet + cPos
      ENDIF 
   ENDIF 
NEXT
RETURN cRet




*//////////////////////// Ajusta o valor para nao ter casas decimais
Function fi_Vlr0( nVlr, nTam )
Local cVlr

IF TYPE('nVlr')='Y'
   nVlr = CAST( nVlr as N(14,2) )
ENDIF
nTam = Iif( Type('nTam')='N', nTam, 15 )
cVlr = Transform( INT(nVlr*100) )
cVlr = CHRTRAN( cVlr, 'R$., ', '' )
cVlr = PADL( cVlr, nTam, '0' )
Return cVlr


*//////////////////////// RETORNA O CODIGO DO MUNICIPIO
Function FI_CODMUNIC( cNome, cUF )
Local cVer, nSel, cRet
nSel  = Select()
cVer  = Sys(2015)
cNome = Upper(Alltrim(semAcento( cNome )))
*-- procura pelo municipio no estado
Select codigo FROM IBGE Where uf=cUF And municipio=cNome Into Cursor (cVer)
*-- se NAO encontra
If _Tally = 0
   *-- padrão RIBEIRAO PRETO
   cRet = '3543402'
Else
   cRet = Alltrim(codigo)
Endif
Use In (Select(cVer))
Select (nSel)
Return cRet


*//////////////////////// RETORNA O CODIGO DA DISCRIMINACAO DO SERVICO
FUNCTION FI_SERVICO( nCtrl, nTam )
Local cServ, nSel
nSel  = SELECT()
cServ = ''
Select IFISCAL
Set Order To CONTROLE   && CONTROLE
If Seek( nCtrl, 'IFISCAL', 'CONTROLE' )
   Do While !Eof('IFISCAL') And IFISCAL.CONTROLE=nCtrl
      cServ = cServ +'||'
      cServ = cServ +Alltrim(IFISCAL.descricao)
      If !Empty(IFISCAL.Compl)
         cServ = cServ + ' '+Alltrim(IFISCAL.Compl)
      Endif
      cServ = cServ + ' R$ '+Alltrim(Tran(IFISCAL.vlrtotal,'999,999,999.99'))
      Skip In IFISCAL
   Enddo
   cServ = Substr(cServ,3)
ENDIF
SELECT (nSel)
Return Padr(cServ,nTam)
