Procedure sp_APURA_CONTRATO( cWhe, cOrigem , tAgora )
&& Executa fechamento de contrato
Local cSit, nCTR, oReg, tAgora,  nSel, lv_ctr, lv_afere
Local x, lv_INC, lv_pln, aOpen[1,2], laClosed[1,2]

=AUSED( aOpen ) && captura as areas abertas antes do processo


lv_pln   = 'P_'+ Sys(2015)
lv_ctr   = 'X_'+ Sys(2015)
lv_afere = 'Y_'+ Sys(2015)
lv_INC   = 'Z_'+ Sys(2015)

cWhe    = Iif( Type('cWhe')='C', cWhe, '1=1' )
cOrigem = Iif( Type('cOrigem')='C', cOrigem, Space(20) )
tAgora  = Iif( Type('tAgora')='T', tAgora, DATETIME()  )


&& seleciona os contrato que irao fazer parte da apuração
Select    ;
            Left(cOrigem,20) As Origem       ;
          , tAgora           As dataHora     ;
          , idFilial         As FILIAL_ID    ;
          , idContrato       As CONTRATO_ID  ;
          , situacao         As CONTRATO_SIT ;
From        contrato                         ;
WHERE       &cWhe. ;
INTO Cursor (lv_ctr)

&& cria um temporario para recepção da informação apurada
Select     * ;
           , Space(10)          As BENEF_SIT      ;
           , Space(10)          As PROD_ID        ;
           , Space(100)         As DESCRICAO      ;
           , Space(20)          As VLR_UNIT       ;
           , Cast(0 As N(12,2)) As APURADO_QUANT  ;
           , Cast(0 As N(14,2)) As APURADO_VALOR  ;
FROM        (lv_ctr) Where (1=2) ;
INTO Cursor (lv_INC) Readwrite

&&--informações que que serao constantes
Scatter Name oReg
oReg.dataHora = tAgora
oReg.Origem   = cOrigem

Select (lv_ctr)
Scan For CONTRATO_SIT ='ATIVO'  &&-- apura somente contratos ativos

   nCTR = &lv_ctr..CONTRATO_ID

   && apura o NUMERO DE VIDAS COM E SEM PRODUTO
   Select situacao, Count(1) As qtd From associado Where idContrato = nCTR Group By situacao Into Cursor (lv_afere)

   Scan ALL  && percorre o que foi aferido para colocar o valor atual
   
      cSit = &lv_afere..situacao

      && apura os valores
      Select Sum(pp.valor) xValor ;
      FROM   ASSOCIADO_PLANO pp ;
      JOIN   associado aa On aa.idassoc=pp.idassoc ;
      WHERE  aa.idContrato=nCTR And ;
             aa.situacao=cSit ;
      INTO Cursor (lv_pln)

      && ajusta os dados para inclusao
      oReg.FILIAL_ID       = &lv_ctr..FILIAL_ID
      oReg.CONTRATO_ID     = nCTR
      oReg.CONTRATO_SIT    = &lv_ctr..CONTRATO_SIT
      oReg.BENEF_SIT       = cSit
      oReg.DESCRICAO       = 'VIDAS COM E SEM PRODUTO'
      oReg.PROD_ID         = 'GERAL'
      oReg.VLR_UNIT        = ''
      oReg.APURADO_QUANT   = &lv_afere..qtd
      oReg.APURADO_VALOR   = Nvl(&lv_pln..xValor,0)

      && incluir
      Insert Into (lv_INC) From Name oReg
      
      
      Select (lv_afere)
      
   Endscan


   && apura o NUMERO DE VIDAS COM PRODUTO
   Select      pp.idPlano, nn.DESCRICAO, aa.situacao, pp.valor,    Count(1) APURADO_QUANT, Sum(pp.valor) As xValor ;
   FROM        ASSOCIADO_PLANO pp ;
   JOIN        PLANOS    nn On nn.plano = pp.idPlano ;
   JOIN        associado aa On aa.idassoc=pp.idassoc ;
   WHERE       aa.idContrato=nCTR ;
   GROUP BY    pp.idPlano, nn.DESCRICAO, aa.situacao, pp.valor ;
   INTO Cursor (lv_afere)

   Scan All
    
      && ajusta os dados para inclusao
      oReg.FILIAL_ID    = &lv_ctr..FILIAL_ID
      oReg.CONTRATO_ID  = nCTR
      oReg.CONTRATO_SIT = &lv_ctr..CONTRATO_SIT
      oReg.BENEF_SIT     = situacao
      oReg.DESCRICAO     = Alltrim(DESCRICAO)
      oReg.PROD_ID       = Transform(idPlano)
      oReg.VLR_UNIT      = Alltrim(Transform(valor,'999999999.99'))
      oReg.APURADO_QUANT = &lv_afere..APURADO_QUANT
      oReg.APURADO_VALOR = &lv_afere..xValor
      
      Insert Into (lv_INC) From Name oReg
      
      Select (lv_afere)
   Endscan

   Select (lv_ctr)

Endscan

IF NOT USED( 'CONTRATO_APURA' )
   USE CONTRATO_APURA  IN 0
ENDIF 

&&-- perpetua as informações
SELECT (lv_INC)
SCAN ALL

   SELECT CONTRATO_APURA 
   APPEND BLANK
   
   replace Origem     WITH Cast(Nvl(&lv_INC..origem , '') as C(20))
   replace Aammddhhmm WITH TTOC(&lv_INC..datahora,1)
   replace Filial_id  WITH Cast(Nvl(&lv_INC..Filial_id  , '') as C(2)) 
   replace Ctr_id     WITH Cast(Nvl(&lv_INC..Contrato_id     , '') as C(10))
   replace Ctr_sit    WITH Cast(Nvl(&lv_INC..Contrato_sit    , '') as C(9))
   replace Bnf_sit    WITH Cast(Nvl(&lv_INC..BENEF_sit    , '') as C(10))
   replace Prod_id    WITH Cast(Nvl(&lv_INC..Prod_id    , '') as C(10))
   replace Descricao  WITH Cast(Nvl(&lv_INC..Descricao  , '') as C(100))
   replace Vlr_unit   WITH Cast(Nvl(&lv_INC..Vlr_unit   , '') as C(20))
   replace Qtd_apurad WITH Cast(Nvl(&lv_INC..APURADO_QUANT , 0) as N(14,2))
   replace Vlr_apurad WITH Cast(Nvl(&lv_INC..APURADO_VALOR , 0) as N(14,2))
   

   SELECT (lv_INC)
   
ENDSCAN 


For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

RETURN 

ENDPROC 


