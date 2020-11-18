FUNCTION fi_xCodFNC( cCod, nTam )
* Retorna o espaço para facilitar visualizacao hierarquica de conta
nTam = IIF( TYPE('nTam') = 'N', nTam, 3 )
cCod = IIF( TYPE('cCod') = 'C', cCod, '' )

IF EMPTY(cCod)
   cRet = ''
ELSE 
   cRet = IIF(SUBSTR(cCod, 3,1)<>'0',      SPACE(nTam), '' ) +;
          IIF(SUBSTR(cCod, 5,1)<>'0',      SPACE(nTam), '' ) +;
          IIF(SUBSTR(cCod, 7,2)<>'00',     SPACE(nTam), '' ) +;
          IIF(SUBSTR(cCod,10,6)<>'000000', SPACE(nTam), '' )
ENDIF 

RETURN cRet          