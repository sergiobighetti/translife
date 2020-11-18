FUNCTION fi_InfCNPJ( cCNPJ, cTipoRet )
&& cTipoRet = 'V' ou 'O'
Local cSql, cTmp, nSel,cJSON, oJ, i, _Ret

nSel     = Select()
cTmp     = Sys(2015)
cCnpj    = Chrtran(cCnpj, ' -_:;^~./\|<>,','' )
cTipoRet = UPPER( IIF( TYPE('cTipoRet')='C', cTipoRet, 'O' ) )
_Ret     = ''

If !Empty(cCnpj)

   cJSON = fi_wVerCNPJ( cCnpj )

   If !Empty(cJSON )

      oJ = fi_JsonToObj( cJSON, .T. )

      If Type('oJ') = 'O'

         Create Cursor (cTmp) ( campo C(30), DESCRICAO C(200 ) )
         
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'CNPJ', oJ.cnpj )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'NOME', oJ.Nome )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'TIPO', oJ.tipo )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'FANTASIA', oJ.fantasia )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'NATUREZA_JURIDICA', oJ.natureza_juridica )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'STATUS', oJ.Status )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'E_MAIL', oJ.email )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'DATA_SITUACAO', oJ.data_situacao )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'SITUACAO', oJ.situacao )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'SITUACAO_MOTIVO', oJ.motivo_situacao )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'SITUACAO_ESPECIAL', oJ.situacao_especial )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'PORTE', oJ.porte )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'ABERTURA', oJ.abertura )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'CEP', oJ.cep )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'LOGRADOURO', oJ.logradouro )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'NRO', oJ.numero )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'BAIRRO', oJ.bairro )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'MUNICIPIO', oJ.municipio )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'UF', oJ.uf )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'TELEFONE', oJ.telefone )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'ULTIMA_ATUALIZACAO', oJ.ultima_atualizacao )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'ATV_PRINCIPAL', oJ.atividade_principal[1].Code+') '+oJ.atividade_principal[1].Text )
         Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'ATV_SECUNDARIA', '' )
         For i=1 To 30
            Try
               Insert Into  (cTmp) (campo,DESCRICAO) Values  ( 'ATV_SECUNDARIA', oJ.atividades_secundarias[i].Code+') '+oJ.atividades_secundarias[i].Text )
            Catch
               Exit
            Endtry
         Next

         IF cTipoRet = 'V'
            Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'SOCIO:', '' )
         ENDIF 
         
         For i=1 To 200
            Try
               Insert Into (cTmp) (campo,DESCRICAO) Values  ( 'SOCIO'+Transform(i), oJ.qsa[i].Nome +'  ('+ oJ.qsa[i].qual +')' )
            Catch
               Exit
            Endtry

         Next

         Go Top
         IF cTipoRet = 'O'
            _Ret = CREATEOBJECT('Empty')
            SCAN all
               =ADDPROPERTY( _Ret, ALLTRIM(campo), ALLTRIM(descricao) )
            ENDSCAN 
            Use In (Select('(cTmp)'))
         ELSE
            _Ret = cTmp
         ENDIF 
      Endif
   Endif

   Select (nSel)

Endif

RETURN _ret