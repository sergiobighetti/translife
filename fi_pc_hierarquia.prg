FUNCTION FI_PC_HIERARQUIA( nPidCta, cHierarq )
LOCAL nPidGrupo 
IF EMPTY(cHierarq )
   cHierarq  = tran(nPidCta)
else
   cHierarq  =  TRANSFORM(nPidCta)+'/'+ ALLTRIM(cHierarq) 
ENDIF 

nPidGrupo = PTAB( nPidCta, 'PCONTA', 'IDCTA',,,'idGrupo' )
IF nPidGrupo > 0
   FI_PC_HIERARQUIA( nPidGrupo , @cHierarq )
ENDIF 
RETURN 