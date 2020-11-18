LOCAL nOLD_IdCtr , cOLD_CdCtr ,  cOLD_CdFIL 
LOCAL nNEW_IdCtr , cNEW_CdCtr ,  cNEW_CdFIL 
LOCAL tRef, nID

CLOSE DATABASES all
CLOSE TABLES all
SET EXCLUSIVE OFF
SET ESCAPE ON
CLEAR

tRef       = {^2019-11-01 00:00:00}
nOLD_IdCtr = 329 
cOLD_CdCtr = ''
cOLD_CdFIL = ''

nNEW_IdCtr = 358
cNEW_CdCtr = ''
cNEW_CdFIL = ''

? ' de: '+ TRANSFORM(nOLD_IdCtr) +' para: '+TRANSFORM(nNEW_IdCtr )

SELECT codigo, idFilial FROM CONTRATO WHERE idContrato = nOLD_IdCtr  INTO ARRAY aCtr
cOLD_CdCtr = aCtr[1]
cOLD_CdFil = aCtr[2]

IF EMPTY(cOLD_CdCtr)
   ? 'Nao encontrado contrato DE'
   RETURN
ENDIF 


SELECT codigo, idFilial FROM CONTRATO WHERE idContrato = nNEW_IdCtr  INTO ARRAY aCtr
cNEW_CdCtr = NVL(aCtr[1],'')
cNEW_CdFIL = NVL(aCtr[2],'')

IF EMPTY(cNEW_CdCtr)
   ? 'Nao encontrado contrato PARA'
   RETURN
ENDIF 

SELECT id       FROM ATENDIMENTO WHERE ctrNumero  = nOLD_IdCtr AND tm_chama        >= tRef into CURSOR LV_ATD
nTal1 = _TALLY

SELECT idTransp FROM TRANSP      WHERE fat_codigo = cOLD_CdCtr AND data_transporte >= tRef into CURSOR LV_TRA
SELECT idEvento FROM EVENTO      WHERE fat_codigo = cOLD_CdCtr AND prev_inicio     >= tRef into CURSOR LV_EVE

IF USED('LV_ATD') AND nTal1  > 0
   SELECT LV_ATD
   SCAN all
   		nId = LV_ATD.id
   		SELECT ATENDIMENTO 
   		SET ORDER TO SEQUENCIA   
   		IF SEEK( nID )
   		   replace ctrNumero WITH nNEW_idCtr, idFilial WITH cNEW_CdFIL
   		ENDIF 
   		SELECT LV_ATD
   ENDSCAN 
   
   SELECT LV_ATD
   ? 'Atualizado '+TRANSFORM(nTal1 )+' atendimento(s)'
ENDIF 

IF USED('LV_TRA') AND RECCOUNT('LV_TRA') > 0
   SELECT LV_TRA
   SCAN all
   		nId = LV_TRA.idTransp
   		SELECT TRANSP      
   		SET ORDER TO IDTRANSP   
   		IF SEEK( nID )
   		   replace fat_codigo WITH cNEW_CdCtr, idFilial WITH cNEW_CdFIL
   		ENDIF 
   		SELECT LV_TRA
   ENDSCAN 
   ? 'Atualizado '+TRANSFORM(RECCOUNT('LV_TRA'))+' transporte(s)'
ENDIF 
   
   
IF USED('LV_EVE') AND RECCOUNT('LV_EVE') > 0
   SELECT LV_EVE
   SCAN all
   		nId = LV_EVE.idEvento
   		SELECT EVENTO
   		SET ORDER TO idEvento   
   		IF SEEK( nID )
   		   replace fat_codigo WITH cNEW_CdCtr, idFilial WITH cNEW_CdFIL
   		ENDIF 
   		SELECT LV_EVE
   ENDSCAN 
   ? 'Atualizado '+TRANSFORM(RECCOUNT('LV_EVE'))+' evento(s)'
ENDIF 
