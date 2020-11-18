#DEFINE GENERIC_READ    2147483648   && &H80000000 
#DEFINE GENERIC_WRITE   1073741824   && &H40000000 

PUBLIC hOpen, hFtpSession  
DECLARE INTEGER InternetOpen IN wininet.dll;   
    STRING  sAgent,;   
    INTEGER lAccessType,;   
    STRING  sProxyName,;   
    STRING  sProxyBypass,;   
    STRING  lFlags    

DECLARE INTEGER InternetCloseHandle IN wininet.dll; 
    INTEGER hInet   

DECLARE INTEGER InternetConnect IN wininet.dll;   
    INTEGER hInternetSession,;   
    STRING  sServerName,;   
    INTEGER nServerPort,;   
    STRING  sUsername,;   
    STRING  sPassword,;   
    INTEGER lService,;   
    INTEGER lFlags,;   
    INTEGER lContext   

DECLARE INTEGER FtpOpenFile IN wininet.dll; 
    INTEGER hFtpSession,; 
    STRING  sFileName,; 
    INTEGER lAccess,; 
    INTEGER lFlags,; 
    INTEGER lContext 

DECLARE INTEGER InternetWriteFile IN wininet.dll; 
    INTEGER   hFile,; 
    STRING  @ sBuffer,; 
    INTEGER   lNumBytesToWrite,; 
    INTEGER @ dwNumberOfBytesWritten 
SET STEP ON   
** Seleccionamos el servidor FTP, con un nivel de acceso apropiado. 
** No usar un acceso anónimo. 
IF connect2ftp ("201.62.123.106", "medilar", "unimedilar") 
    lcSourcePath = ".\"       && Directorio local 
    lcTargetPath = "c:\tmp\"      && directorio de ftp destino 
    lnFiles = ADIR (arr, lcSourcePath + "*.htm") 

    FOR lnCnt=1 TO lnFiles 
        lcSource = lcSourcePath + LOWER (arr [lnCnt, 1]) 
        lcTarget = lcTargetPath + LOWER (arr [lnCnt, 1]) 
        ? lcSource + " -> " + lcTarget 
        * ?? local2ftp(hFtpSession, lcSource, lcTarget) 
    ENDFOR 

    = InternetCloseHandle (hFtpSession)   
    = InternetCloseHandle (hOpen)  
ENDIF  

**-------------------------------------------- 
** Establecemos la conexión 
**-------------------------------------------- 
FUNCTION  connect2ftp (strHost, strUser, strPwd)  

   ** Abrimos el acceso.   
    hOpen = InternetOpen("vfp", 1, 0, 0, 0)   

    IF hOpen = 0   
        ? "No tiene acceso a WinInet.Dll"  
        RETURN .F.  
   ENDIF  

    ** Conectando al FTP. 
    hFtpSession = InternetConnect (hOpen, strHost, 0, strUser, strPwd, 1, 0, 0)   
 
    IF hFtpSession = 0   
        ** Cerrando acceso y saliendo.   
        = InternetCloseHandle (hOpen)   
        ? "FTP " + strHost + " no está disponible"  
        RETURN .F.  
     ELSE   
         ? "Conectado a " + strHost + " como: [" + strUser + ", *****]"   
   ENDIF   
RETURN .T.  


**-------------------------------------------- 
** Copia del/los archivos 
**-------------------------------------------- 
FUNCTION local2ftp (hConnect, lcSource, lcTarget) 
    ** Copiando el archivo local al directorio remoto ftp. 
    hSource = FOPEN (lcSource) 
    IF (hSource = -1)  
        RETURN -1 
    ENDIF 

    ** Creamos el nuevo archivo 
    hTarget = FtpOpenFile(hConnect, lcTarget, GENERIC_WRITE, 2, 0) 
    IF hTarget = 0 
       = FCLOSE (hSource) 
       RETURN -2 
    ENDIF 
    lnBytesWritten = 0 
    lnChunkSize = 256    && 128, 512 
    DO WHILE Not FEOF(hSource) 
        lcBuffer = FREAD (hSource, lnChunkSize) 
        lnLength = Len(lcBuffer) 
        IF lnLength > 0 
           IF InternetWriteFile (hTarget, @lcBuffer, lnLength, @lnLength) = 1 
                lnBytesWritten = lnBytesWritten + lnLength 
                ** Podemos mostrar aquí el progreso de la operación 
           ELSE 
                EXIT 
           ENDIF 
        ELSE 
            EXIT 
        ENDIF 
   ENDDO 

   = InternetCloseHandle (hTarget) 
   = FCLOSE (hSource) 

RETURN  lnBytesWritten
