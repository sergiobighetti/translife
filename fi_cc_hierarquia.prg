FUNCTION FI_CC_HIERARQUIA( nPidCCU, cHierarq )
LOCAL nPidGrupo 
IF EMPTY(cHierarq )
   cHierarq  = tran(nPidCCU)
else
   cHierarq  =  TRANSFORM(nPidCCU)+'/'+ ALLTRIM(cHierarq) 
ENDIF 

nPidGrupo = PTAB( nPidCCU, 'CCUSTO', 'CCU_ID',,,'ccu_ID_PAI' )
IF nPidGrupo > 0
   FI_CC_HIERARQUIA( nPidGrupo , @cHierarq )
ENDIF 
RETURN 