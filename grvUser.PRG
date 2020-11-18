*****************************************************************************
function GrvUser
lparameter cAls, cCod, nAcao
* Funcao para identificar o usuario que modificou o arquivo pela ultima vez
* OBS: Esta funcao depende de uma variavel PUBLICA "cUsuario" que deve
* ser declara na iniciliazacao do do sistema
*****************************************************************************
local cMacro, cAlsAtual, nRecAtual, i, cCampo, cXXXXX, cIp, cArq

if type( 'drvGravaLog' ) = 'L'  && SE EXISTE A VARIAVEL GRAVA LOG
   if not drvGravaLog           && E ELA INDICA PARA NÃO GRAVAR
      return .t.                && RETORNA
   endif
endif

cAlsAtual = alias()

if pCount() = 0
   cAls = alias()
endif

nAcao = iif( type("nAcao")$"INY", nAcao, 0 )

sele ( cAls )

if type( "drvNomeUsuario" ) = [C]
   cArq = alltrim(m.drvNomeUsuario)+[.LOG]
else
   cArq = "USRFREE"+[.LOG]
endif

if type( 'drvDiretorio' ) = 'C'
   cArq = drvDiretorio+'\'+cArq
endif

cMacro = ''
if !empty(cAls)

   do case

      case nAcao = 1
         cMacro = cMacro +[Inc. ]+ ltrim( str( recno() ) )

      case nAcao = 2
         cMacro = cMacro +'Alt: '
         for i = 1 to fcount( cAls )
            cCampo = field(i,cAls)
            cXXXXX = cAls+[.]+cCampo
            if oldval(cCampo,cAls) # &cXXXXX
               cMacro = cMacro +  cCampo + [,]
            endif
         next

      case nAcao = 3
         cMacro = cMacro +[Del. ]+ ltrim(str(recno()) )

   endcase

endif

cIp  = iif( type( 'drvIpLocal' ) = 'C', drvIpLocal, '' )

cStr = padr( tran(cAls), 15  )   + ;
   dtos(date()) + ;
   time() + ;
   padr( cMacro, 90 ) + ;
   padr( tran(cCod), 12 )+;
   tran( nAcao ) + ;
   padr( iif(type("drvNomeUsuario" )=[C],drvNomeUsuario, '' ), 18 )+;
   padr( cIp, 15 )+;
   padr( iif(type("drvWinUserName" )=[C],drvWinUserName, '' ), 18 )+chr(13)+chr(10)

=strtofile( cStr, cArq, .t. )

return .t.
