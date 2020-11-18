Local cArq
Local cNFSe_N, cNFSe_V, cRPS_N, cRPS_S, cRPS_T, cXML, i, xmlNFSe, xmlRPS
Clear

CLOSE DATABASES all
CLOSE TABLES all
SET ESCAPE ON

cArq = Getfile('XML' )

If Empty(cArq)
   Return
Endif

cXML = Filetostr( cArq )

CREATE CURSOR LV_UPD ( linha i, NFSe C(10), NF_Data T, RPS C(10), RPS_SERIE C(1), RPS_TIPO C(1), RPS_Data T, NOME C(60) )

For i =1 To 10000

   xmlNFSe = Strextract( cXML, '<ns3:IdentificacaoNfse>', '</ns3:IdentificacaoNfse>',i )

   If Empty(xmlNFSe)
      Exit
   Endif

   xmlRPS  = Strextract( cXML, '<ns3:IdentificacaoRps>',  '</ns3:IdentificacaoRps>', i )
   xmlTOM  = Strextract( cXML, '<ns3:TomadorServico>',    '</ns3:TomadorServico>', i )


   cNFSe_N = Strextract( xmlNFSe, '<ns3:Numero>', '</ns3:Numero>' )
   cNFSe_V = Strextract( xmlNFSe, '<ns3:CodigoVerificacao>', '</ns3:CodigoVerificacao>' )
   cEmiss  = Strextract( cXML, '<ns3:DataEmissao>', '</ns3:DataEmissao>', i )
   dNSe_D  = DATETIME( VAL(SUBSTR(cEmiss,01,4)), VAL(SUBSTR(cEmiss,06,2)), VAL(SUBSTR(cEmiss,09,2)),;
                       VAL(SUBSTR(cEmiss,12,2)), VAL(SUBSTR(cEmiss,15,2)), VAL(SUBSTR(cEmiss,18,2)))



   cRPS_N = Strextract( xmlRPS  , '<ns3:Numero>', '</ns3:Numero>' )
   cRPS_S = Strextract( xmlRPS  , '<ns3:Serie>', '</ns3:Serie>' )
   cRPS_T = Strextract( xmlRPS  , '<ns3:Tipo>', '</ns3:Tipo>' )
   cEmiss  = Strextract( cXML, '<ns3:DataEmissaoRps>', '</ns3:DataEmissaoRps>', i )
   dRPS_D  = DATETIME( VAL(SUBSTR(cEmiss,01,4)), VAL(SUBSTR(cEmiss,06,2)), VAL(SUBSTR(cEmiss,09,2)),;
                       VAL(SUBSTR(cEmiss,12,2)), VAL(SUBSTR(cEmiss,15,2)), VAL(SUBSTR(cEmiss,18,2)))

   cTOM_N = Strextract( xmlTOM  , '<ns3:RazaoSocial>', '</ns3:RazaoSocial>' )

   INSERT INTO LV_UPD VALUES ( i, cNFSe_N, dNSe_D, cRPS_N,cRPS_S , cRPS_T , dRPS_D , cTOM_N ) 

   * ? 'Linha '+ Transform(i,'999') + ': NFSe: '+ cNFSe_N +'   emitida em: '+ Chrtran( cEmiss, 'T', ' ' )    +'    ref RPS: '+ cRPS_N +' ('+ cTOM_N  +')'


NEXT


IF RECCOUNT('LV_UPD') > 0
   
   nUPD = RECCOUNT('LV_UPD') 
   
   SELECT uu.*, rr.emissao as M_RPS_EMISSAO,    nn.nomeempresa as NFE_RAZAO, nn.dataemissao, nn.numeronf, rr.controle ;
   FROM  LV_UPD uu ;
   JOIN  \\medicarfs\bdmdc$\NFISCAL_RPS rr ON rr.RPS=uu.RPS and rr.SERIE=uu.RPS_SERIE and TTOD(rr.EMISSAO)=TTOD(uu.RPS_Data)  ;
   JOIN  \\medicarfs\bdmdc$\NFISCAL     nn ON nn.controle = rr.controle  AND nn.nomeempresa=uu.NOME  ;
   WHERE  rr.emissao >= {^2015-04-01 00:00:00} and nn.idFilial='01' ;
   INTO CURSOR LV_PROC

   nPROC =  RECCOUNT('LV_PROC') 
   IF nUPD <> nPROC
      MESSAGEBOX( 'UPD: '+TRANSFORM(nUPD)+' <> PROC: '+TRANSFORM(nPROC), 64, 'Atenção' )
   ELSE
      SELECT LV_PROC
      SCAN ALL
         nCtrl = LV_PROC.controle
         SELECT NFISCAL
         LOCATE FOR controle=nCtrl
         IF FOUND() 
            ? '.'
            replace dataemissao WITH TTOD(LV_PROC.NF_Data)
            replace numeronf    WITH VAL(LV_PROC.NFSe )
            replace horaemissao WITH SUBSTR(TTOC( LV_PROC.NF_Data ), 12 )
         ELSE 
            ? '*'
         ENDIF 
      ENDSCAN 
      
   ENDIF 

ENDIF 
