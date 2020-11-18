Close Databases All
Close Tables All
SET ESCAPE ON


IF OCCURS( 'LIBROTINA', SET("Procedure") ) = 0
   SET PROCEDURE TO C:\DESENV\WIN\VFP9\LIBBASE\LIBROTINA.PRG ADDITIVE 
ENDIF

&& CD "\\dcrpo\bdmdc$"

Use associado In 0 
Use contrato  In 0 
Clear

TEXT TO cCtrATU TEXTMERGE NOSHOW PRETEXT 8
49
ENDTEXT

cCtrAtu = Strtran( cCtrAtu, Chr(13), '' )
cCtrAtu = Strtran( cCtrAtu, Chr(10), '' )
nQtd = Alines( aCtr, cCtrAtu, .T., ',' )

For i = 1 To nQtd

   nIdContr = Int(Val(aCtr[i]))

   SELECT contrato
   Scan For idContrato = nIdContr
   
      cOldCOD = contrato.codigo
      
      replace idfilial WITH '04', fil_cart WITH '04'
      cChv    = '04' + 'CL'
      
      cNewCod = NovaChave( '04', cChv, 'CT' )
      Replace codigo          With cNewCod
      Replace numero          With Int(Val( Substr(cNewCod,5,6) ) )
      ?
      ? cNewCOD
      
      =FI_HIST( cNewCod, cOldCOD )

   Endscan

   SELECT      aa.idAssoc, aa.codigo OLD, SPACE(12) novo ;
   FROM        associado aa ;
   WHERE       !EMPTY(aa.codigo) AND aa.idContrato = nIdContr ;
   ORDER BY    aa.codigo ;
   INTO CURSOR CFAZ READWRITE

   SCAN ALL

      nIdAssoc = CFAZ.idAssoc
      cCodOLD  = CFAZ.OLD
      
      IF SEEK( nIdAssoc, 'ASSOCIADO', 'IDASSOC' )
      
         =SEEK( ASSOCIADO.idContrato, 'CONTRATO', 'I_D' )
         
         replace ASSOCIADO.oldcod    WITH cCodOLD
         replace ASSOCIADO.codigo    WITH ''

         IF SUBSTR(CFAZ.old,11,2) = '00'
            =FI_CODIFICA( 'TITULAR' )
            cCodTIT = ASSOCIADO.codigo
         ELSE
            =FI_CODIFICA( 'DEPENDENTE', LEFT(cCodTIT,10) )
         ENDIF
         cCodNEW = ASSOCIADO.codigo
         ? ASSOCIADO.codigo
         
         =FI_HIST( cCodNEW, cCodOLD )

      ELSE
         ?? [*]
      ENDIF
      
      SELECT CFAZ
      
   ENDSCAN 

Endfor


FUNCTION fi_HIST( cCodNEW, cCodOLD )

         *-- historico de atendimento
         UPDATE hstatend ;
         SET    pacCodigo = cCodNEW ;
         WHERE  pacCodigo = cCodOLD  
         ?? [h]
   
         *-- atendimento
         UPDATE atendimento ;
         SET    pacCodigo = cCodNEW ;
         WHERE  pacCodigo = cCodOLD  
         ?? [a]
   
         *-- database
         UPDATE newdb ;
         SET    associado = cCodNEW ;
         WHERE  associado = cCodOLD  
         ?? [d]

         *-- agenda
         UPDATE agenda ;
         SET    codassoc = cCodNEW ;
         WHERE  codassoc = cCodOLD  
         ?? [g]
         
         *-- evento
         UPDATE Evento ;
         SET    fat_codigo = cCodNEW ;
         WHERE  fat_codigo = cCodOLD  
         ?? [e]
         
         *-- transporte (Solicitante)
         UPDATE Transp;
         SET    solicitante_cod = cCodNEW ;
         WHERE  solicitante_cod = cCodOLD  
         ?? [t]
         
         *-- transporte (CodFaturamento)
         UPDATE Transp;
         SET    fat_codigo = cCodNEW ;
         WHERE  fat_codigo = cCodOLD  
         ?? [t]

   RETURN .t.
         
ENDFUNC 