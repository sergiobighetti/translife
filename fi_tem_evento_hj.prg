FUNCTION fi_tem_Evento_hj( nAcao )
* nAcao = 1 && verifica (default)
* nAcao = 2 && mostra
* nAcao = 3 && retorna o cursor gerado mas nao mostra
LOCAL x,cWhe, dHoje, cVer, dIni, dFim, _rtn, aOpen[1,2], laClosed[1,2], cMsgEVE, cPathAviso, nSumID

_rtn  = ''


cVer  = SYS(2015)

dHoj  = DTOS(DATE())
dIni  = EVALUATE( '{^'+ TRANSFORM(DTOS(DATE()   ),'@R 9999-99-99')+' 00:00:00}' )
dFim  = EVALUATE( '{^'+ TRANSFORM(DTOS(DATE()+3 ),  '@R 9999-99-99')+' 23:59:59}' )

cWhe = 'EVENTO.situacao="2"'
cWhe = cWhe + ' AND EVENTO.prev_inicio BETWEEN '
cWhe = cWhe + '{^'+ TRANSFORM(TTOC(dIni,1),'@R 9999-99-99 99:99:99') +'} AND '
cWhe = cWhe + '{^'+ TRANSFORM(TTOC(dFim,1),'@R 9999-99-99 99:99:99') +'}'

=AUSED( aOpen )


SELECT          DISTINCT ;
                ;
                EVENTO.idEvento   I_D,;
                EVENTO.idfilial   FIL,;
                EVENTO.solicitado_em,;
                EVENTO.prev_inicio DataEvento,;
                Evento.eve_nome  NomeEvento,;
                Evento.eve_local LocalEvento,;
                EVENTO.solicitante_nome SOLICITANTE,; 
                EVENTO.fat_codigo ,;
                EVENTO.fat_nome ;
                ;
FROM            EVENTO ;
WHERE           &cWhe ;
ORDER BY        EVENTO.prev_inicio ;
INTO CURSOR     (cVer)


DO case
   CASE nAcao = 1
      _rtn = (_TALLY>0)
      USE IN ( SELECT( cVer ) )
   CASE nAcao = 2

      DO FORM pesquisa WITH 'SELECT * FROM '+cVer,,"fi_Chama_EVENTO(I_D)",'Agenda de Eventos',,.t.

      USE IN ( SELECT( cVer ) )
   CASE nAcao = 3
     _rtn = cVer   
     
   CASE nAcao = 4 AND ( _TALLY > 0 )
   
      cPathAviso = ADDBS( SYS(2023) )
      cMsgEVE = ''
      nSumID  = 0
      SCAN all
      
         IF INLIST( (  TTOD(&cVer..DataEvento) - DATE() ), 1, 2, 3 )
            IF INLIST( LEFT(TIME(),5), '09:00', '14:00', '17:00', '19:00' )
               nSumID  = nSumID  + &cVer..I_D + INT(VAL( LEFT(TIME(),2) ))
               cMsgEVE = cMsgEVE +CHR(13)+ 'Fil: '+ FIL +', '+ TRANSFORM( DataEvento ) +', '+ALLTRIM(NomeEvento) && +' Local: '+ ALLTRIM(LocalEvento)
            ENDIF
         ENDIF  
      
      ENDSCAN 

      USE IN ( SELECT( cVer ) )
      cMsgEVE = SUBSTR(cMsgEVE,2)
      IF !EMPTY(cMsgEVE)
         IF !file( cPathAviso+'ALS_EV_'+TRANSFORM(nSumID)+'.tmp' )
           =STRTOFILE( cMsgEVE, cPathAviso+'ALS_EV_'+TRANSFORM(nSumID)+'.tmp', 1 )      
            DO c:\desenv\win\vfp9\translife\fi_notifica WITH 'Atenção! EVENTO(s)',cMsgEVE, 10 
         ENDIF 
      ENDIF 
       
ENDCASE 

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

RETURN _Rtn



FUNCTION fi_Chama_EVENTO( nIdX )
If Wvisible('frmEVENTO')
   Zoom Window frmEVENTO Max
   Activate Window frmEVENTO
Else
   Do Form EVENTO WITH nIdX 
Endif
