* Geração de estatistica de fechamento mensal

Local cAAMM, cVer

Close Databases All
Close Tables All

cVer = Sys(2015)
cAAMM = Left(Dtos(Date()),6)

Use EST_ASSOC In 0
Use EST_CONTR In 0

*-- verifica a existencia do ANO MES no arquivo de estatistica de associados
Select aa.anoMes From EST_ASSOC aa Where aa.anoMes == cAAMM Into Cursor (cVer)

*-- se nao tem estatistica para associado
If _Tally = 0

   *-- quantificacao de ASSOCIADOS (VIDAS)
   Select      ;
               cAAMM             anoMes,    ;
               cc.idFilial       FILIAL,    ;
               cc.tipo_contrato  tpcontrato,;
               ;
               ; &&-- total GERAL de associados ATIVOS
               Sum( Iif( aa.situacao='ATIVO' And atendimento=.T., 1, 0     ) ) GQ_ATV_C_ATD,;
               SUM( Iif( aa.situacao='ATIVO' And atendimento=.F., 1, 0     ) ) GQ_ATV_S_ATD,;
               ;
               ; &&-- total GERAL de associados CANCELADOS
               Sum( Iif( aa.situacao='CANCELADO' And atendimento=.T., 1, 0 ) ) GQ_CAN_C_ATD,;
               SUM( Iif( aa.situacao='CANCELADO' And atendimento=.F., 1, 0 ) ) GQ_CAN_S_ATD,;
               ;
               ; &&-- total somente de TITULAR ATIVO
               Sum( Iif( Substr(aa.codigo,11,2)='00' And aa.situacao='ATIVO' And atendimento=.T., 1, 0     ) ) TQ_ATV_C_ATD,;
               SUM( Iif( Substr(aa.codigo,11,2)='00' And aa.situacao='ATIVO' And atendimento=.F., 1, 0     ) ) TQ_ATV_S_ATD,;
               ;
               ; &&-- total somente de TITULAR CANCELADO
               Sum( Iif( Substr(aa.codigo,11,2)='00' And aa.situacao='CANCELADO' And atendimento=.T., 1, 0 ) ) TQ_CAN_C_ATD,;
               SUM( Iif( Substr(aa.codigo,11,2)='00' And aa.situacao='CANCELADO' And atendimento=.F., 1, 0 ) ) TQ_CAN_S_ATD ;
               ;
   FROM        ASSOCIADO aa ;
   JOIN        CONTRATO cc On aa.idContrato=cc.idContrato ;
   GROUP By    1,2,3;
   ORDER By    1,2,3;
   INTO Cursor (cVer)

   *-- inclui no arquivo de estatisticas
   Select EST_ASSOC
   Append From Dbf(cVer)

Endif


*-- verifica a existencia do ANO MES no arquivo de estatistica de contratos
Select aa.anoMes From EST_CONTR aa Where aa.anoMes == cAAMM Into Cursor (cVer)

*-- se nao tem estatistica para contratos
If _Tally = 0

   *-- quantificacao de CONTRATOS
   Select      cAAMM                  anoMes,;
               idFilial               FILIAL,;
               LEFT(tipo_contrato,14) tpcontrato,;
               situacao,;
               ;
               COUNT(idContrato)      quant,;
               SUM(valor)             valor ;
               ;
   FROM        CONTRATO ;
   group By    1,2,3,4;
   order By    1,2,3,4;
   INTO Cursor (cVer)

   *-- inclui no arquivo de estatisticas
   Select EST_CONTR
   Append From Dbf(cVer)

Endif


Close Databases All
Close Tables All

