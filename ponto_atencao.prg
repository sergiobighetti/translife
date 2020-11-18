FUNCTION ponto_atencao( lMostrarResultado )
Local cRet,lTemInf, cTxt, nRef, dRef, cVer, cArqTHML,i, aTopico[13,3]
Local aOpen[1], x, laClosed[1]

=Aused( aOpen )

SET DATE BRITISH
SET EXCLUSIVE OFF

lTemInf  = .F.
Store '' To aTopico
cRet     = ''
nRef     = 1
cVer     = Sys(2015)
cArqTHML = Addbs(Sys(2023))+ cVer +'.html'
nRef     = 0

nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Recebimentos pendentes a mais de 30 dias'
IF verGrupo( "CONTAS A RECEBER","EDT",.f. )

   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   dRef =  (Gomonth(Date(),-1))
   Select aTopico[nRef,1] Ponto, idFilial , Count(1) As qtd ;
      FROM   ARECEBER aa ;
      WHERE  aa.situacao='ABERTO' ;
      AND aa.data_vencimento <= dRef ;
      order By aa.idFilial    ;
      group By aa.idFilial    ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Filial: '+idFilial+' com '+ Alltrim(Str(qtd,12,0)) +' lancamento(s) pendentes a mais de 30 dias</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         
         * cDEST  =  '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/A Receber/R021 - Titulos em Aberto e faca o filtro adequado para analise detalhada</span><br /></li>'
         * aTopico[nRef,3] = aTopico[nRef,3] + '<a href="@@do form REL_R021 with [R024]">'+cDEST+'</a>'


         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/A Receber/R021 - Titulos em Aberto e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #0000ff;">Solucao....:</strong> Faturamento/Contas A Receber</span></li>'

         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif

   Endif

  
Endif

************
nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'CERTIFICADO DIGITAL DESTE COMPUTADOR VENCENDO PROXIMOS 30 dias'
If verGrupo( "NOTA FISCAL","EDT",.F. )

   Wait Window 'Ponto de Atenção: #'+Transform(nRef)+ ' ) Verificando '+ Alltrim(aTopico[nRef,2]) +'... aguarde' Nowait Noclear

   cXML = fi_CertVencendo( Date(), Date()+30 )
   If !Empty(cXML)
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      For i= 1 To 1000
         cInf = Strextract( cXML, '<cert>', '</cert>', i )
         If Empty(cInf)
            Exit
         Endif

         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #ff0000;">'+ Strextract(cInf, '<vcto>', '</vcto>' )  +') '+ Strextract(cInf, '<nome>', '</nome>' ) +;
            '</span><br />'
      Next
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Contate a contabilidade para obteção de novos certificados</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif

   Endif

ENDIF



nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Notas Fiscais pendentes de emissão'
IF verGrupo( "NOTA FISCAL","EDT",.f. )

   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 
   dRef =  (Gomonth(Date(),-1))

   Select aTopico[nRef,1] Ponto, idFilial , Count(1) As qtd ;
   FROM   NFISCAL aa ;
   WHERE    aa.cancelada = 1 ;
        AND EMPTY(aa.dataemissao) ;
   order By aa.idFilial    ;
   group By aa.idFilial    ;
   INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Filial: <b>'+idFilial+'</b> com <b>'+ Alltrim(Str(qtd,12,0)) +'</b> nota(s) pendentes</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/A Receber/R021 - Titulos em Aberto e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #0000ff;">Solucao....:</strong> Faturamento/Contas A Receber</span></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif

   Endif

   USE IN (SELECT('NFISCAL'))

ENDIF

nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Pagamentos pendentes a mais de 30 dias'
IF verGrupo( "CONTAS A PAGAR","EDT",.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 
   dRef =  (Gomonth(Date(),-1))
   Select aTopico[nRef,1]  Ponto, idFilial, Count(1) As qtd ;
      FROM   APAGAR aa ;
      WHERE  aa.situacao='PE' ;
      AND aa.data_vencimento <= dRef ;
      ORDER By aa.idFilial    ;
      group By aa.idFilial    ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Filial: <b>'+idFilial+'</b> com '+ Alltrim(Str(qtd,12,0)) +' pagamento(s) pendente(s) a mais de 30 dias</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/A Pagar/R013 - Contas Apagar e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #0000ff;">Solucao....:</strong> Financeiro/Contas A Apagar</span></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

   USE IN (SELECT('APAGAR'))

Endif

nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'APAGAR conta financeiras com grandes variações < 50% baixa ou >100% aumento'
IF verGrupo( "CONTAS A PAGAR","EDT",.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   SELECT aa.idCta, pc.codigo, pc.descricao ;
        , SUM( IIF( aa.data_vencimento >= GOMONTH(DATE(), -1) , aa.valor_documento, 0.00 )) as u30dias ;
        , AVG( IIF( aa.data_vencimento >= GOMONTH(DATE(),-12) , aa.valor_documento, 0.00 )) as m12meses ;
   FROM APAGAR aa ;
   JOIN PCONTA pc ON pc.idCta = aa.idCta ;
   GROUP BY aa.idCta,pc.codigo, pc.descricao HAVING u30dias > 0  ; && AND u30dias > m12meses
   INTO CURSOR (cVer)

   SELECT *, ( ( (u30dias-m12meses)/m12meses ) * 100 ) as perc_variacao ;
   FROM (cVer)  ;
   WHERE ( ( (u30dias-m12meses)/m12meses ) * 100 )> 100 OR ;
         ( ( (u30dias-m12meses)/m12meses ) * 100 )< -50 ;
   ORDER BY 6 DESC ;
   INTO CURSOR (cVer)
      
   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Cod: <b>'+ALLTRIM(codigo)+' '+ALLTRIM(descricao )+'</b> nos ultimos 30 soma <b><span style="color: #000000;">R$ '+ ;
                         Alltrim(TRANSFORM(u30dias,'999,999,999,999.99')) +'</span></b> sendo que a medias em 12 meses e de <b><span style="color: #000000;">R$ '+Alltrim(tran(m12meses,'999,999,999,999.99'))+;
                         '</span></b> variacao de <b> <span style="color: #ff0000;">'+Alltrim(tran(perc_variacao,'999,999.99'))+'%</span></b></span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/A Pagar/R038 - Analitico de saidas e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

Endif


nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Transportes agendados proximas 72 horas'

If VerGrupo( 'TRANSPORTE', "EDT",.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   dRef = Datetime() + (72 * (60*60) )
   Select      aTopico[nRef,1] Ponto, tr.idFilial, Count(1) As qtd ;
      FROM        transp tr ;
      WHERE       tr.situacao = '2' And tr.data_transporte > Datetime() And tr.data_transporte <= (dRef);
      ORDER By    tr.idFilial ;
      GROUP By    tr.idFilial ;
      INTO Cursor (cVer)

   If _Tally > 0

      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Filial: <b>'+idFilial+'</b> com '+Alltrim(Str(qtd,12,0)) +' agendado(s)</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Atendimento/Transporte/Relatorios/Transporte e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

Endif



nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Transportes pendentes de faturamento'
If VerGrupo( 'TRANSPORTE - FATURAMENTO',"EDT",.f.)
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   Select    aTopico[nRef,1] Ponto, tr.idFilial, Count(1) As qtd ;
      FROM      transp tr ;
      WHERE     tr.situacao="6" And !Empty(tr.v_central) And tr.fat_forma<>"ISENTO" And tr.fat_controle=0 And Empty(tr.fat_portador) ;
      ORDER By  tr.idFilial ;
      GROUP By  tr.idFilial ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Filial: <b>'+idFilial+'</b> com '+Alltrim(Str(qtd,12,0)) +' pendente(s)</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Atendimento/Transporte/Faturamento para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

Endif



nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Evento agendados proximos 7 dias'
If VerGrupo( 'EVENTOS', "EDT",.f. )   
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 
   dRef = Date()+7
   dRef = Datetime( Year(dRef), Month(dRef), Day(dRef), 23,59,59 )
   Select   aTopico[nRef,1] Ponto, ev.idFilial, Count(1) As qtd ;
      FROM     evento ev ;
      WHERE    ev.situacao = '2' And ev.prev_inicio  > Datetime()  And ev.prev_inicio <= dRef ;
      ORDER By ev.idFilial ;
      GROUP By ev.idFilial ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Filial: <b>'+idFilial+'</b> com <b>'+Alltrim(Str(qtd,12,0)) +'</b> agendado(s)</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Atendimento/Eventos/Relatorio e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif

   Endif
   USE IN (SELECT('evento'))

Endif


nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Contratos ATIVOS c/ database vencendo nos proximos 30 dias'

dRef = Gomonth( Date(), 1 )

IF verGrupo( "CONTRATO","EDT",.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   dRef = Gomonth(Date(),1)

   Select aTopico[nRef,1] Ponto, cc.idContrato, cc.Tipo_Contrato, cc.Nome_Responsavel, cc.Database, Date( Year(dRef), Month(cc.Database), Day(cc.Database) ) As dtbREF ;
      FROM   CONTRATO cc ;
      WHERE  cc.situacao='ATIVO' ;
      AND Not cc.Tipo_Contrato='CLIENTE EVENTUA' ;
      and  ( Date() - cc.Database ) >= 335 ;
      AND  Date( Year(dRef), Month(cc.Database), Day(cc.Database) ) Between Date() And dRef ;
      ORDER By 6 ;
      INTO Cursor (cVer)

   If _Tally >0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">'+SEMACENTO(Tipo_Contrato)+') id: '+ Tran(idContrato,'9999999')+' '+Nome_Responsavel+' DtBase em <b><span style="color: #ff0000;">'+Dtoc(Database)+'</span></b></span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/Contratos/R008 - Listagem de contratos e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #0000ff;">Solucao....:</strong> Arquivo/Contrato</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

Endif



nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Contratos ATIVOS com 2 ou mais parcelas em ABERTO'

dRef = Gomonth( Date(), 1 )

IF verGrupo( "CONTAS A RECEBER","EDT",.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   dRef = DATE()

   Select aTopico[nRef,1] Ponto, cc.idContrato, cc.Tipo_Contrato, cc.Nome_Responsavel, cc.Database, qtdParc As qtdParc ;
   FROM   CONTRATO cc ;
   JOIN (SELECT aa.idContrato, COUNT(1) as qtdParc ;
         FROM  ARECEBER aa ;
         WHERE aa.situacao='ABERTO' AND aa.data_vencimento<=dRef AND aa.origem ='FATURAMENT' ;
         GROUP BY  aa.idContrato HAVING qtdParc >= 2 ) pp ON pp.idContrato==cc.idContrato ;
   WHERE  cc.situacao='ATIVO' ;
      ORDER By 6 ;
      INTO Cursor (cVer)

   If _Tally >0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">'+SEMACENTO(Tipo_Contrato)+') id: '+ Tran(idContrato,'9999999')+' '+Nome_Responsavel+' com <b><span style="color: #ff0000;">'+tran(qtdParc)+'</span></b></span> em aberto<br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Relatorios/A Receber/R021 - Titulos em Aberto e faca o filtro adequado para analise detalhada</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #0000ff;">Solucao....:</strong> Arquivo/Contrato</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

ENDIF


nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Contratos ATIVOS c/ quantidade de usuarios abaixo da media ultimos 12 meses'
IF verGrupo( "CONTRATO","EDT",.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   dRef = Gomonth(Date(),-12)
   dRef = Datetime( Year(dRef), Month(dRef), Day(dRef), 00,00,00 )
   Select aTopico[nRef,1]  Ponto, cc.idContrato, cc.Tipo_Contrato, cc.Nome_Fantasia, cc.Database, Md.media As media12m,  qa.qtdAtual ;
      FROM   CONTRATO cc ;
      JOIN   ( Select aa.ctr_id, Int(Avg(aa.qtd_apurad)) As  media ;
      FROM contrato_apura aa ;
      WHERE aa.bnf_sit='ATIVO' And aa.ctr_sit='ATIVO' And origem='MENSAL' And aa.qtd_apurad>=10 And aa.aammddhhmm >= Ttoc(dRef,1);
      GROUP By 1 ) Md On Val(Md.ctr_id) = cc.idContrato ;
      JOIN   ( Select aa.idContrato, Count(1) As qtdAtual ;
      FROM  associado aa ;
      JOIN  CONTRATO ct On ct.idContrato=aa.idContrato And ct.situacao='ATIVO' ;
      WHERE aa.atendimento=.T. And aa.situacao='ATIVO' And ct.situacao='ATIVO';
      GROUP By 1 ) qa On qa.idContrato = cc.idContrato ;
      WHERE  cc.situacao='ATIVO' ;
      AND Not cc.Tipo_Contrato='CLIENTE EVENTUA'  ;
      AND qa.qtdAtual < Md.media ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">Id: '+ Alltrim(Tran(idContrato,'9999999')) +' '+Alltrim(Nome_Fantasia)+' atualmente c/ '+ Alltrim(Str(qtdAtual,12,0))+' sendo que nos ultimos 12 meses a media de '+Alltrim(Str(media12m,12,0))+ ' queda de <b><span style="color: #ff0000;">' +Alltrim(Tran( ((media12m-qtdAtual)/media12m )*100,'999.99'))+'%</span></b></span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Arquivo/Contratos e faca a analise detalhada de cada contrato</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif

   Endif

Endif




nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Contratos MENSAL Ativos com ultimo faturamento SUPERIOR a 30 dias'
IF verGrupo( "CONTRATO",,.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   Select ;
      'Wrn=MENSAL' As msg, xx.*, (Date() - Nvl(xx.ult_VCTO,Ctod(''))) As Dif ;
      FROM ( ;
      SELECT    ;
      cc.idFilial ;
      , cc.idContrato ;
      , cc.Nome_Responsavel ;
      , cc.Tipo_Contrato ;
      , cc.dia_vencimento ;
      , cc.tipo_parcela ;
      , Nvl(ue.ult_VCTO,Ctod('')) As ult_VCTO ;
      FROM       CONTRATO cc ;
      LEFT Join ( Select       aa.idContrato, Max(NN.dataemissao) As ult_VCTO;
      FROM         ARECEBER aa ;
      JOIN         nfiscal NN On NN.controle = aa.idnf ;
      GROUP By     aa.idContrato ;
      ) As ue On ue.idContrato = cc.idContrato ;
      WHERE      cc.tipo_parcela = 'MENSAL'  ;
      and cc.situacao = 'ATIVO' ;
      and Subs(cc.codigo,3,2) In ('FA','CO', 'AS', 'AR', 'PU' )  ;
      ) xx ;
      WHERE  (Date() - Nvl(xx.ult_VCTO,Ctod('') )) > 30 ;
      ORDER By xx.idFilial, xx.Nome_Responsavel  ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">'+ SEMACENTO(Tipo_Contrato,.T.)+') id: '+ Alltrim(Tran(idContrato,'9999999'))+' '+Alltrim(Nome_Responsavel)+;
            ' Ult.Faturamento em <b>'+Dtoc(ult_VCTO )+'</b>.  (Ja fazem <b>'+Transform(Dif)+'</b> dias)</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Arquivo/Contratos e faca a analise detalhada de cada contrato</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

Endif



nRef = nRef + 1
aTopico[nRef,1] = Chr(64+nRef)
aTopico[nRef,2] = 'Contratos BI/TRI/QUADRI/SEMESTRAL e ANUAL Ativos com ultimo faturamento SUPERIOR ao tipo de parcela'
IF verGrupo( "CONTRATO",,.f. )
   WAIT WINDOW 'Ponto de Atenção: #'+TRANSFORM(nRef)+ ' ) Verificando '+ ALLTRIM(aTopico[nRef,2]) +'... aguarde' NOWAIT NOCLEAR 

   Select ;
      'Wrn#MENSAL' As msg ;
      ,xx.idFilial, xx.idContrato, xx.Nome_Responsavel,xx.Tipo_Contrato,xx.dia_vencimento, xx.tipo_parcela, xx.ult_VCTO      ;
      ,(Date() - Nvl(xx.ult_VCTO,Ctod(''))) As Dif ;
      FROM ( ;
      SELECT ;
      cc.idFilial ;
      , cc.idContrato;
      , cc.Nome_Responsavel;
      , cc.Tipo_Contrato;
      , cc.dia_vencimento;
      , cc.tipo_parcela;
      , ue.ult_VCTO ;
      , (Iif(cc.tipo_parcela='BIMEST',2, Iif(cc.tipo_parcela='TRIMES',3,Iif(cc.tipo_parcela='QUADRI',4,Iif(cc.tipo_parcela='PENTAM',5,6))))*30) As nDiasRef;
      FROM   CONTRATO cc;
      LEFT Join ( Select       aa.idContrato, Max(aa.data_vencimento) As ult_VCTO;
      FROM         ARECEBER aa ;
      GROUP By     aa.idContrato ;
      ) As ue On ue.idContrato = cc.idContrato ;
      WHERE  cc.tipo_parcela <> 'MENSAL' ;
      and cc.tipo_parcela <> 'ANUAL';
      and cc.situacao = 'ATIVO';
      and Subs(cc.codigo,3,2) In ('FA','CO', 'AS', 'AR', 'RE', 'PU' );
      ) xx ;
      WHERE (Date() - Nvl(xx.ult_VCTO,Ctod(''))) >= xx.nDiasRef ;
      ORDER By xx.idFilial, xx.Nome_Responsavel  ;
      INTO Cursor (cVer)

   If _Tally > 0
      lTemInf  = .T.
      aTopico[nRef,3] = aTopico[nRef,3] +'<p>'
      Scan All
         aTopico[nRef,3] = aTopico[nRef,3] +'|<span style="color: #808080;">'+ SEMACENTO(Tipo_Contrato,.T.)+') id: '+ Alltrim(Tran(idContrato,'9999999'))+' '+Alltrim(Nome_Responsavel)+;
            ' Ult.Faturamento em <b>'+Dtoc(ult_VCTO )+'</b>.  (Ja fazem <b>'+Transform(Dif)+'</b> dias)</span><br />'
      Endscan
      aTopico[nRef,3] = aTopico[nRef,3] +'</p>'

      If !Empty(aTopico[nRef,3])
         aTopico[nRef,3] = aTopico[nRef,3] +'<ul>'
         aTopico[nRef,3] = aTopico[nRef,3] + '<li><span style="color: #339966;"><strong>Verificacao:</strong> Em Arquivo/Contratos e faca a analise detalhada de cada contrato</span><br /></li>'
         aTopico[nRef,3] = aTopico[nRef,3] +'</ul>'
      Endif
   Endif

ENDIF 




WAIT CLEAR 

If lTemInf

   cTxt = ''
   For i=1 To Alen(aTopico,1)
      If !Empty(aTopico[i,3])

         TEXT TO cTXT TEXTMERGE NOSHOW ADDITIVE
<p>
   <strong>===========: <<aTopico[i,2]>>:</strong>
</p>
<p>
   <<aTopico[i,3]>>
</p>

         ENDTEXT
         *|===========:  <<aTopico[i,2]>>:
         *|<<SUBSTR(aTopico[i,3],2)>>

      Endif
   Next

   TEXT TO  cCab TEXTMERGE NOSHOW
<h3>
   <span
      <strong><p><span style="color: #ff9900;"><em>Pontos de aten&ccedil;&atilde;o &eacute;&nbsp;algo&nbsp;que possa a vir requerer a interven&ccedil;&atilde;o do usu&aacute;rio</em></span></p></strong>
   </span>
</h3>
   ENDTEXT

   cTxt =cCab+cTxt

   cTxt = Chrtran(cTxt,'|', Chr(13) )

   Set Safety Off
   =Strtofile(cTxt, cArqTHML )

   Use In ( Select(cVer))
   For x=1 To Aused( laClosed )
      If Ascan( aOpen, laClosed[x,1]) = 0
         Use In (laClosed[x,1])
      Endif
   Next
   cRet = cArqTHML

   IF lMostrarResultado
      Do Form Ponto_atencao With cArqTHML
   ENDIF 
ENDIF

RETURN cRet