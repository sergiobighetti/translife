CLOSE DATABASES all
CLOSE TABLES all
CLEAR

USE c:\xxx IN 0
USE \\dcrpo\bdmdc$\banco.dbf  IN  0
USE \\dcrpo\bdmdc$\extrato.dbf IN 0

SELECT extrato 
SET ORDER TO COD_ORIGEM   

SELECT xxx
SCAN all

  nCod = Xxx.cod_origem
    
  IF SEEK( nCod, 'EXTRATO', 'COD_ORIGEM' )
     
     SELECT EXTRATO
     SCAN WHILE cod_origem=nCod
         IF '<I>MATEUS7/11/2006' = LEFT(auditoria,18)
            ?? [*]
            DELETE IN EXTRATO
         ENDIF
     ENDSCAN
     
  ELSE 
     ?? [N]
  ENDIF
  
SELECT xxx
ENDSCAN 