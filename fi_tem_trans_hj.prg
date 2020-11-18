FUNCTION fi_tem_trans_hj( nAcao )
* nAcao = 1 && verifica (default)
* nAcao = 2 && mostra
* nAcao = 3 && retorna o cursor gerado mas nao mostra
LOCAL cHora ,x,cWhe, dHoje, cVer, dIni, dFim, _rtn, aOpen[1,2], laClosed[1,2], nSumID, cPathAviso

_rtn  = ''
cVer  = SYS(2015)

dHoj  = DATE()
dIni  = EVALUATE( '{^'+ TRANSFORM(DTOS(dHoj    ),'@R 9999-99-99')+' 00:00:00}' )

dFim  = DATETIME() + ( 4 * (60*60 ) )  + 3 &&-- 4horas a frente


cWhe = 'TRANSP.situacao="2"'
cWhe = cWhe + ' AND data_transporte BETWEEN '
cWhe = cWhe + '{^'+ TRANSFORM(TTOC(dIni,1),'@R 9999-99-99 99:99:99') +'} AND '
cWhe = cWhe + '{^'+ TRANSFORM(TTOC(dFim,1),'@R 9999-99-99 99:99:99') +'}'

=AUSED( aOpen )


SELECT          ;
                TRANSP.idtransp   I_D,;
                TRANSP.idfilial   FIL,;
                TRANSP.solicitado_em,;
                TRANSP.data_transporte,;
                IIF(TRANSP.orides=1,'NaOrig.', 'NoDest.' ) Orig_Dest,;
                TRANSP.solicitante_nome SOLICITANTE,; 
                TRANSP.km_quant QTD_KM,;
                ;
                TRANSP_PACIENTE.nomepacien PACIENTE,;
                TRANSP_PACIENTE.idade      IDADE,;
                TRANSP_PACIENTE.int_local  INTERNADO_EM,;
                ;
                TRANSP.fat_codigo ,;
                TRANSP.fat_nome ;
                ;
FROM            TRANSP ;
LEFT OUTER JOIN TRANSP_PACIENTE ON TRANSP.idTransp == TRANSP_PACIENTE.idTransp  ;
WHERE           &cWhe ;
INTO CURSOR     (cVer)

DO case

   CASE nAcao = 1
      _rtn = (_TALLY>0)
      USE IN ( SELECT( cVer ) )

   CASE nAcao = 2

      DO FORM pesquisa WITH 'SELECT * FROM '+cVer,,"fi_Chama_TRANSP(I_D,data_transporte)",'Agenda de Transportes',,.t.

      USE IN ( SELECT( cVer ) )

   CASE nAcao = 3
     _rtn = cVer   
     
     
   CASE nAcao = 4 AND ( _TALLY > 0 )
   
      cPathAviso = ADDBS( SYS(2023) )
      cMsgEVE = ''
      nSumID  = 0
      SCAN all
      
      
         cHora = LEFT( ELAPTIME( DATETIME(), &cVer..data_transporte), 5 )
         
         IF INLIST( cHora, '04:00', '02:00' )
         
            nSumID = nSumID + &cVer..I_D + INT(VAL( LEFT(cHora,2) ))
             
            cRef = TTOC(&cVer..data_transporte,1)
            
            cRef = TTOHHMM( &cVer..data_transporte)
            
            **cRef = SUBSTR(cRef,7,2)+'/'+SUBSTR(cRef,4,2)+' '+ TTOHHMM( &cVer..data_transporte)
            
            cMsgEVE = cMsgEVE +CHR(13)+ 'F: '+ FIL +' as '+ cRef +' '+ Orig_Dest +' pac '+ALLTRIM(PACIENTE)
         
         ENDIF  
      
      ENDSCAN 

      USE IN ( SELECT( cVer ) )
      cMsgEVE = SUBSTR(cMsgEVE,2)
      IF !EMPTY(cMsgEVE)
      
          IF !file( cPathAviso+'ALS_TR_'+TRANSFORM(nSumID)+'.tmp' )
             =STRTOFILE( cMsgEVE, cPathAviso+'ALS_TR_'+TRANSFORM(nSumID)+'.tmp', 1 )
             DO c:\desenv\win\vfp9\mmed\fi_notifica WITH 'Atenção! TRANSPORTE(s)!',cMsgEVE, 10 
          ENDIF 
      ENDIF 
       
            
ENDCASE 

For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next

RETURN _Rtn



FUNCTION fi_Chama_TRANSP( nIdX, dRef )
If Wvisible('frmTRANSP')
   Zoom Window frmTRANSP Max
   Activate Window frmTRANSP
Else
   Do Form TRANSP WITH nIdX, dRef
Endif
