* Este exemplo foi gentilmente construído por Marcos Santello da Estilo Informática - São Paulo - SP
* Ao Marcos os nossos agradecimentos

LPARAMETERS oFrm

Local oCB, cMsg, i, oBol, cBco, nSel, cArqTXT
LOCAL aInstr[20],aXinstr[1]

nSel = Select()


STORE SPACE(100) TO aInstr
nQtd = ALINES(aXinstr, oFrm.edtInstr.Value ,1,'|')
FOR i= 1 TO nQtd
   aInstr[i] = PADR( aXinstr[i], 100 )
NEXT    


=Seek( oFrm.nID_rec,        'ARECEBER', 'CONTROLE' )
=Seek( ARECEBER.idnf,       'NFISCAL',  'CONTROLE' )
=Seek( ARECEBER.idContrato, 'CONTRATO', 'I_D'      )

cBco = Left( oFrm.txtBanco.Value, 3 )


cArqTXT = 'c:\temp\2aVia_ctrl_'+ TRANSFORM(ARECEBER.controle) +'.TXT' 

SET TEXTMERGE TO (cArqTXT) NOSHOW
SET TEXTMERGE ON

\\0004
\\<<PADL(ARECEBER.controle,16,'0')>>
\\<<PADL(Alltrim(ARECEBER.numero_documento),13,'0' ) >>
\\<<DTOC(DATE())>>
\\<<Dtoc(oFrm.txtVencto.Value)>>
\\<<PADL(CHRTRAN(STR(ARECEBER.valor_documento,13,2),',. ',''),13,'0')>>

*-- codigo desconto
\\<<SPACE(4)>>
*-- data cocessao de desconto
\\<<SPACE(10)>>
*-- valor para desconto
\\0000000000000
\\0001
\\0500
\\0002
\\0000
\\0000
\\0000
\\0000000000000
\\2
\\<<SPACE(10)>>
\\0000000000000

\\<<PADR('Referente a 2a via de boleto',40)>>
\\<<SPACE(40)>>
\\<<SPACE(40)>>

*-- recibo linha sacado
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>
\\<<SPACE(100)>>

*-- sacado avalista
\\<<SPACE(40)>>
\\00000000000000


*--sacado
\\<< PADL( chrtran(Iif( !Eof('NFISCAL'), NFISCAL.cnpj_cnpf, Iif(!Empty(Left(CONTRATO.cpf,2)),CONTRATO.cpf,CONTRATO.cnpj)), ' .-/', '' ),14,'0') >>
\\<< PADR(ARECEBER.numero_documento,25)  >>
\\<< PADR( Alltrim(Iif( !Eof('NFISCAL'), NFISCAL.nomeempresa, CONTRATO.nome_resPonsavel )),40) >>
\\<< PADR( Iif( !Eof('NFISCAL'),NFISCAL.endereco, CONTRATO.cob_end), 40 ) >>
\\<< PADR( Iif( !Eof('NFISCAL'),NFISCAL.bairro,   CONTRATO.cob_bairro),15 ) >>
\\<< PADR( Iif( !Eof('NFISCAL'),NFISCAL.cidade,   CONTRATO.cob_cid),15 ) >>
\\<< PADR( Iif( !Eof('NFISCAL'),NFISCAL.uf,       CONTRATO.cob_uf),2 ) >>
\\<< PADR( CHRTRAN( Iif( !Eof('NFISCAL'),NFISCAL.cep,      CONTRATO.cob_cep),'- /.',''),8,'0' ) >>

\\1
\\<<SPACE(8)>>

SET TEXTMERGE OFF
SET TEXTMERGE TO


MESSAGEBOX( 'Gerado o arquivo '+cArqTXT , 64, 'Atenção' )