CLEAR
SET ESCAPE ON 

nConn = SQLSTRINGCONNECT('Driver=SQL Server;Server=192.168.5.6;UID=sa;PWD=mdl@2019.;Database=NEWMEDDB')

TEXT TO csql TEXTMERGE NOSHOW
   select codigo, max(idAssoc) as idAssoc
   FROM associado 
   where Idcontrato= 2449 and
          codigo in ( select   codigo
               from     ASSOCIADO 
               where Idcontrato = 2449
               group by Codigo having count(1) >1  )
   group by codigo

ENDTEXT 
=SQLEXEC( nConn, cSql, 'OLDPARC' )

SELECT OLDPARC
      ?
      ? RECNO()
      ?? RECCOUNT()
      ? 

SCAN ALL

   TEXT TO cSql TEXTMERGE NOSHOW
                  DECLARE @cRet varchar(15)
                  DECLARE @RC int

                  SET @cRet = ''
                  EXECUTE @RC = [dbo].[sp_NOVO_COD]  '52' ,'52CL' ,'' ,@cRet OUTPUT
                  
                  if @cRet is null 
                     EXECUTE @RC = [dbo].[sp_NOVO_COD]  '52' ,'52CL' ,'' ,@cRet OUTPUT

                  UPDATE associado SET codigo = @cRet+'00' WHERE idAssoc = <<idAssoc>>
      
   ENDTEXT 
   nOk = SQLEXEC( nConn, cSql )
   
      ?? TRANSFORM(nOK)
   IF nOK <> 1
      _ClipText = cSql
      SET STEP ON 
   ENDIF 
   
   IF RECNO()%10000 = 0
      ?
      ? RECNO()
      ?? RECCOUNT()
      ? 
   ENDIF 
   
ENDSCAN 


=SQLDISCONNECT(nConn)
