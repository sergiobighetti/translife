#Define CR_LF          Chr(13)+Chr(10)
#Define ID_MARGEM      Space(0)

#Define ID_NOMEEMPRESA Padr( oFrm.Lmp.TiraAcentuacao(NFISCAL.NomeEmpresa), 60 )
#Define ID_ENDERECO    ALLT( oFrm.Lmp.TiraAcentuacao(NFISCAL.endereco) )
#Define ID_BAIRRO      ALLT( oFrm.Lmp.TiraAcentuacao(NFISCAL.bairro) )

#Define ID_DATAEMISSAO Dtoc( NFISCAL.dataEmissao)
#Define ID_CGC_CPF     NFISCAL.cnpj_cnpf
#Define ID_CEP         NFISCAL.cep
#Define ID_CIDADE      Padr( oFrm.Lmp.TiraAcentuacao(NFISCAL.cidade), 25 )
#Define ID_FONE        Padr( NFISCAL.fone, 13 )
#Define ID_UF          NFISCAL.uf
#Define ID_IE          NFISCAL.ie

#Define ID_ITEM_DESCR  Padr( Allt( oFrm.Lmp.TiraAcentuacao(IFISCAL.descricao) )+[ ]+IFISCAL.Compl,78)
#Define ID_ITEM_VALOR  Tran(IFISCAL.vlrunit,[999999.99])
#Define ID_ITEM_TOTAL  Tran(IFISCAL.vlrtotal,[999,999.99] )

#Define ID_BS_IR       Tran(Iif(NFISCAL.ir_valor>0,NFISCAL.ir_base,0),      [999,999,999.99] )
#Define ID_AL_IR       Tran(NFISCAL.ir_aliq,              [999.99])
#Define ID_VL_IR       Tran(NFISCAL.ir_valor,     [999,999,999.99] )

#Define ID_BS_INSS     Tran(NFISCAL.inss_Base,    [999,999,999.99] )
#Define ID_VL_INSS     Tran(NFISCAL.inss_Valor,   [999,999,999.99] )
#Define ID_AL_INSS     Tran(NFISCAL.inss_Aliq,    [999.99] )

#Define ID_BS_ISS      Tran(NFISCAL.iss_base,     [999,999,999.99] )
#Define ID_AL_ISS      Tran(NFISCAL.iss_aliq,     [999.99])
#Define ID_VL_ISS      Tran(NFISCAL.iss_valor,    [999,999,999.99] )

#Define ID_BS_PIS      Tran(Iif( NFISCAL.pis_aliq>0,    nBSACNF, 0 ), [999,999,999.99] )
#Define ID_AL_PIS      Tran(NFISCAL.pis_aliq,     [999.99])
#Define ID_VL_PIS      Tran(NFISCAL.pis_valor,    [999,999,999.99] )

#Define ID_BS_COFINS   Tran(Iif( NFISCAL.cofins_aliq>0, nBSACNF, 0 ), [999,999,999.99] )
#Define ID_AL_COFINS   Tran(NFISCAL.cofins_aliq,  [999.99])
#Define ID_VL_COFINS   Tran(NFISCAL.cofins_valor, [999,999,999.99] )

#Define ID_BS_CSOCIAL  Tran(Iif( NFISCAL.csoc_aliq >0,  nBSACNF, 0 ), [999,999,999.99] )
#Define ID_AL_CSOCIAL  Tran(NFISCAL.csoc_aliq,    [999.99])
#Define ID_VL_CSOCIAL  Tran(NFISCAL.csoc_valor,   [999,999,999.99] )

#Define ID_VL_BRUTO    Tran(nVlrCR,               [999,999,999.99] )
#Define ID_VL_NF       Tran(NFISCAL.valorbruto,   [999,999,999.99] )

* Desabilitado em 12/07/2006 por determinação de LUIZ do financeiro
* VALOR BRUTO e VALOR LIQUIDO serao = a VALOR BRUTO
* #DEFINE ID_VL_NF       TRAN(NFISCAL.valorliquido, [999,999,999.99] )
* #DEFINE ID_TOTAL_DESC  TRAN(NFISCAL.ir_valor+NFISCAL.inss_Valor, [999,999,999.99] )

#Define ID_TOTAL_DESC  Tran(NFISCAL.ir_valor +Iif(NFISCAL.retem_iss,NFISCAL.iss_valor,0) +NFISCAL.inss_Valor +NFISCAL.cofins_valor +NFISCAL.csoc_valor +NFISCAL.pis_valor+nVlrDB, [999,999,999.99] )


Lparam oFrm, nCtrl, nNumero, nBSACNF

Local i, nQtdLinha, cInf, nVlrCR, nVlrDB


PTAB( CLV_NF.controle, 'IFISCAL', 'CONTROLE', .T. )

cVcto = Space(10)
If PTAB( CLV_NF.controle, 'ARECEBER', 'IDNF' )
   cVcto   = Transform(ARECEBER.data_vencimento)
Endif

??? Chr(15)

??? ID_MARGEM + Space(84)

??? Chr(18)
??? Padl(Int(nNumero),8)
??? Chr(15)

??? CR_LF
??? CR_LF     +Space(132)+ Tran(Int(nNumero))
??? CR_LF
??? CR_LF
??? CR_LF
??? ID_MARGEM +Space(090)+ 'PREST. SERVICO'
??? CR_LF
??? ID_MARGEM +Space(090)+ ID_DATAEMISSAO


??? CR_LF
??? CR_LF
??? ID_MARGEM +Space(15)+ ID_NOMEEMPRESA
??? CR_LF
??? ID_MARGEM +Space(15)+ ID_ENDERECO   +Space(11)+ ID_BAIRRO +' - CEP: '+ ID_CEP
??? CR_LF
??? ID_MARGEM +Space(15)+ ID_CIDADE     +Space(48)+ ID_UF     +Space(18)+  cVcto
??? CR_LF
??? ID_MARGEM +Space(15)+ ID_CGC_CPF    +Space(10)+ ID_IE     +Space(10)+  ID_FONE

??? CR_LF
??? CR_LF

Local aImp[4]
Store [] To aImp
If NFISCAL.inss_Aliq > 0
   aImp[1] = Padr( 'Valor INSS ('+ Alltrim(ID_AL_INSS)+'%)', 30, '.' ) + ID_VL_INSS
Endif
If NFISCAL.ir_aliq > 0
   aImp[2] = Padr( 'Valor I.R. ('+ Alltrim(ID_AL_IR)+'%)',   30, '.' ) + ID_VL_IR
Endif
If NFISCAL.pis_aliq+NFISCAL.cofins_aliq+NFISCAL.csoc_aliq > 0
   aImp[3] = Padr( 'PIS/COFINS/C.SOCIAL ('+ Allt(Tran(NFISCAL.pis_aliq+NFISCAL.cofins_aliq+NFISCAL.csoc_aliq,'999.99'))+'%)',   30, '.' ) + Transform(NFISCAL.pis_valor+NFISCAL.cofins_valor+NFISCAL.csoc_valor,'999,999,999.99')
Endif

=Alines( aObs, NFISCAL.complemento, .T., "|" )
Dimension aObs[3]

cInf  = Padr( Alltrim(NFISCAL.informacao), 150 )

If Occurs('|', cInf ) > 0
   =Alines( aInf, cInf,  .T., "|" )
   Dimension aInf[3]
Else
   Dimension aInf[3]
   Store Space(50) To aInf
   aInf[1] = Substr( cInf,  1,  50 )
   aInf[2] = Substr( cInf,  51, 50 )
   aInf[3] = Substr( cInf, 101     )
Endif

For i = 1 To 3
   If Empty( aInf[i] )
      aInf[i] = Space(50)
   Endif
   aInf[i] = Padr( aInf[i], 50 )
   If Empty( aObs[i] )
      aObs[i] = Space(50)
   Endif
   aObs[i] = Padr( aObs[i], 50 )
Next

PTAB( CLV_NF.controle, 'IFISCAL', 'CONTROLE', .T. )

nQtdLinha = 1
nVlrCR    = 0
nVlrDB    = 0
nImp      = 1

For i = 1 To 20

   ??? CR_LF
   If IFISCAL.controle == nCtrl And !Eof('IFISCAL')
      ??? ID_MARGEM +' '+ ID_ITEM_DESCR +Space(13)+ Space(9) +Space(7)+ ID_ITEM_TOTAL

      If IFISCAL.vlrunit > 0
         nVlrCR = nVlrCR + IFISCAL.vlrunit
      Endif
      If IFISCAL.vlrunit < 0
         nVlrDB = nVlrDB + Abs(IFISCAL.vlrunit)
      Endif

      Skip In IFISCAL
   Else

      If nQtdLinha > 1 And nQtdLinha <= 4
         ??? ID_MARGEM
         ??? ' '+ aObs[nQtdLinha-1] + Space(20) + aInf[nQtdLinha-1]
      Else
         If !Empty(aImp[nImp])
            ??? ' '+ aImp[nImp]
            nImp = nImp + 1
         Endif
      Endif
      nQtdLinha = nQtdLinha + 1

   Endif

Next

??? CR_LF

??? ID_MARGEM + Space(15)+ID_BS_ISS     +"           "+ ID_AL_ISS     +Space(51) +"    "+ ID_VL_NF

For i = 1 To 6
   ??? CR_LF
Next

??? Chr(18)
Set Printer To
