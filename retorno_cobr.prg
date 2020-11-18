
eBemX = CreateObject('CobreBemX.ContaCorrente')
eBemX.ArquivoLicenca          = LOCFILE("17527975000175-341-112.conf")
eBemX.CodigoAgencia           = '0125'
eBemX.NumeroContaCorrente     = '44485-1'
eBemX.CodigoCedente           = '0000125444851'
eBemX.OutroDadoConfiguracao1  = '000'
eBemX.InicioNossoNumero       = '00000001'
eBemX.FimNossoNumero          = '99999999'
eBemX.ProximoNossoNumero      = '00000000'


eBemX.ArquivoRetorno.Diretorio = 'C:\DESENV\WIN\VFP9\SCA_NEW\RET\'
eBemX.ArquivoRetorno.Arquivo   = 'CN16123A.RET'
eBemX.ArquivoRetorno.Layout    = 'CNAB400'
eBemX.CarregaArquivosRetorno


clear
For i = 0 To (eBemX.OcorrenciasCobranca.Count-1)

   ?? "ITEM: "+ Tran(i)
oX = eBemX.OcorrenciasCobranca[i]

   ? 'NossoNumero='        + eBemX.OcorrenciasCobranca[i].NossoNumero
   ? 'CodigoOcorrencia='  + eBemX.OcorrenciasCobranca[i].CodigoOcorrencia
   ? 'DataOcorrencia='    + eBemX.OcorrenciasCobranca[i].DataOcorrencia
   ? 'Pagamento='         + TRANSFORM(eBemX.OcorrenciasCobranca[i].Pagamento)
   ? 'DataCredito='       + eBemX.OcorrenciasCobranca[i].DataCredito
   ? 'ValorPago='         + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorPago)
   ? 'ValorMultaPaga='    + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorMultaPaga)
   ? 'ValorJurosPago='    + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorJurosPago)
   ? 'ValorTaxaCobranca=' + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorTaxaCobranca)
   ? 'ValorCredito='      + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorCredito)
   ? 'NumeroDocumento='   + eBemX.OcorrenciasCobranca[i].NumeroDocumento
   ? 'ValorDesconto='     + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorDesconto)
   ? 'Banco='             + eBemX.OcorrenciasCobranca[i].Banco
   ? 'Carteira='          + eBemX.OcorrenciasCobranca[i].Carteira
   ? 'Agencia='           + eBemX.OcorrenciasCobranca[i].Agencia
   ? 'ContaCorrente='     + eBemX.OcorrenciasCobranca[i].ContaCorrEnte
   ? 'CodigoCedente='     + eBemX.OcorrenciasCobranca[i].CodigoCedente
   ? 'NumeroControle='    + eBemX.OcorrenciasCobranca[i].NumeroControle
   ? 'ValorOutrosAcrescimos='   + TRANSFORM(eBemX.OcorrenciasCobranca[i].ValorOutrosAcrescimos)


   For F = 0 TO  eBemX.OcorrenciasCobranca[i].MotivosOcorrencia.Count-1
      ? 'Motivo(' + Tran(F) + ')=' + ;
         eBemX.OcorrenciasCobranca[i].MotivosOcorrencia[f].Codigo + '­' +;
         eBemX.OcorrenciasCobranca[i].MotivosOcorrencia[f].Descricao
      ? ''
   Endfor
NEXT
