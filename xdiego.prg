CLEAR

SET ESCAPE ON
SET DELETED ON
CLOSE DATABASES all
CLOSE TABLES all
 

USE ('C:\PROV\BKP 24-05 Full Manutenção\APAGAR')  IN 0 ALIAS ORIGEM
USE ('C:\PROV\BKP 24-05 Full Manutenção\APAGAR_PC') IN 0 ALIAS ORIGEM_PC

nConn = conexao()

SELECT ORIGEM
SCAN ALL
  
  nCtrl = ORIGEM.controle

   IF    ( !EMPTY(Data_vencimento) AND YEAR(Data_vencimento) <= 1900 );
      or ( !EMPTY(Data_cadastro)   AND YEAR(Data_cadastro)   <= 1900 );
      or ( !EMPTY(Data_emissao)    AND YEAR(Data_emissao)    <= 1900 );
      or ( !EMPTY(Data_baixa)      AND YEAR(Data_baixa)      <= 1900 );
      or ( !EMPTY(Dtprorrog)       AND YEAR(Dtprorrog)       <= 1900 )
      LOOP
   ENDIF 
  
  TEXT TO cSql TEXTMERGE NOSHOW
  
    IF ( SELECT COUNT(*) FROM APAGAR WHERE controle=<<nCtrl>> ) = 0 

       BEGIN
       SET IDENTITY_INSERT dbo.APAGAR ON  



      INSERT INTO [APAGAR] ( 
           [Controle], [Idfilial], [Codigo_fornecedor], [Numero_documento], [Data_vencimento]
         , [Data_cadastro], [Data_emissao], [Historico], [Valor_documento], [Valor_acrescimo]
         , [Valor_desconto], [Data_baixa], [Codigo_banco], [Formapag], [Cheque]
         , [Observacao], [Idbaixa], [Idcta], [Auditoria], [Dtprorrog], [Situacao]
           ) VALUES
         (
           <<Controle>>
         , '<<Idfilial>>'  
         , <<Codigo_fornecedor>>
         , '<<SemAcento(Numero_documento,.t.) >>'
         , '<<TTOC_SQL(Data_vencimento)>>' 
         , '<<TTOC_SQL(Data_cadastro)>>'
         , '<<TTOC_SQL(Data_emissao)>>'
         , '<<semAcento(Historico,.t.)>>'  
         , <<NTOC_SQL(Valor_documento,12,2)>>
         , <<NTOC_SQL(Valor_acrescimo,12,2)>> 
         , <<NTOC_SQL(Valor_desconto,12,2)>> 
         , '<<TTOC_SQL(Data_baixa)>>'
         , <<Codigo_banco>>
         , '' 
         , <<Cheque>>
         , '<<semAcento(Observacao,.t.)>>'
         , <<Idbaixa>>
         , <<Idcta>> 
         , '<<ALLTRIM(Auditoria)>>'
         , '<<TTOC_SQL(Dtprorrog)>>'
         , '<<Situacao>>' )


          
    ENDTEXT 
    
    
    IF SEEK( nCtrl, 'ORIGEM_PC', 'CONTROLE' )
       SELECT ORIGEM_PC
       SET ORDER TO CONTROLE IN ORIGEM_PC
       SCAN WHILE controle=nCtrl
          TEXT TO cSql TEXTMERGE NOSHOW ADDITIVE 
            -- APAGAR_PC
            INSERT INTO APAGAR_PC ( [Controle], [Idcta], [Valor] ) VALUES ( <<nCtrl>>,<<Idcta>>,<<NTOC_SQL(Valor,12,2)>> )
            
          ENDTEXT 
       ENDSCAN 
    ENDIF
    
    TEXT TO cSql TEXTMERGE NOSHOW ADDITIVE 
    
        SET IDENTITY_INSERT dbo.APAGAR OFF
       END 
    ENDTEXT 
    
    
    SELECT ORIGEM
    
     
    
    IF SQLEXEC( nConn, cSql ) < 0
       _ClipText = cSql
       ? 'erro'
       SET STEP ON
    ELSE
       @ 10,10 say TRANSFORM(RECNO()) +' / '+TRANSFORM(RECCOUNT())
    ENDIF 
      
ENDSCAN 
    


    