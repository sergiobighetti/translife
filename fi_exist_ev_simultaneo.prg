FUNCTION fi_exist_ev_simultaneo( idEV, cCodCtr, tIni, tFim )
LOCAL nSel, cTmp, _Rtn, mTmp

cCent = SET("Century")

SET CENTURY OFF

nSel = SELECT()
cTmp = SYS(2015)
_Rtn = ''

SELECT ee.idEvento, ee.eve_nome, ee.prev_inicio, ee.prev_termino ;
FROM  EVENTO ee ;
JOIN  CONTRATO cc ON cc.codigo = ee.fat_codigo ;
WHERE ee.idevento <> idEV          and ;                && nao pode ser o mesmo evento testado
      ee.fat_codigo = cCodCtr      and ;                && do mesmo pagante
      ee.situacao IN ('2','3','6') and ;                && ( PENDENTE, EM ANDAMENTO, FINALIZADO )
    ( ( ee.prev_inicio  BETWEEN tINI and tFim            ) or ; && Inicio ou Termino dentro do perido do evento testado
      ( ee.prev_termino BETWEEN tINI and tFim            ) or ;
      ( tINI between  ee.prev_inicio and ee.prev_termino ) or ; 
      ( tFIM between  ee.prev_inicio and ee.prev_termino )    ; 
      ) ;
INTO CURSOR (cTmp)


IF _tally > 0 AND RECCOUNT(cTmp) > 0 
   nTmpTotal = 0
   SCAN all
   
      nTmp = 0
      IF BETWEEN( &cTmp..prev_inicio, tIni, tFim ) AND BETWEEN( &cTmp..prev_termino, tIni, tFim )
         nTmp = nTmp + ( &cTmp..prev_termino - &cTmp..prev_inicio )
      ELSE
      
         IF &cTmp..prev_inicio < tIni AND &cTmp..prev_termino > tFim 
            nTmp = nTmp + ( tFim - tIni )
         ELSE 
            IF &cTmp..prev_inicio < tIni AND BETWEEN( &cTmp..prev_termino, tIni, tFim )
               nTmp = nTmp + ( &cTmp..prev_termino - tIni )
            ENDIF 
            IF BETWEEN( &cTmp..prev_inicio, tIni, tFim ) AND &cTmp..prev_termino > tFim 
               nTmp = nTmp + ( tFim - &cTmp..prev_inicio )
            ENDIF 
         ENDIF 

         IF BETWEEN( &cTmp..prev_inicio, tIni, tFim )
            nTmp = nTmp + ( tIni - &cTmp..prev_inicio)
         ENDIF          
         IF BETWEEN( &cTmp..prev_termino, tIni, tFim )
            nTmp = nTmp + ( tFim - &cTmp..prev_termino)
         ENDIF     
              
      ENDIF 
       
      _Rtn = _Rtn +'|'+ 'id: '+ TRANSFORM(idEvento)+' ) '
      _Rtn = _Rtn +' Periodo ' + LEFT(TRANSFORM(&cTmp..prev_inicio),14)
      _Rtn = _Rtn +' - '+ LEFT(TRANSFORM(&cTmp..prev_termino),14)
      _Rtn = _Rtn +' Minutos simultaneos '+ TRANSFORM(INT(nTmp/60))
      _Rtn = _Rtn +' (' + ALLTRIM(&cTmp..eve_nome) +')' 
      nTmpTotal = nTmpTotal + nTmp
     
   ENDSCAN 
   _Rtn = _Rtn + '|Total de minutos simultaneos: [ '+ TRANSFORM(INT(nTmpTotal/60)) +' ] '
   _Rtn = SUBSTR(_Rtn,2)
ENDIF 
cCent = 'SET Century '+ cCent
&cCent.
USE IN (SELECT(cTmp))
SELECT (nSel)
IF EMPTY(_rtn)
   _rtn = SPACE(245)
ENDIF 
RETURN _Rtn 