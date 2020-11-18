Local loCrypt
Local lnSuccess
Local loCert
Local lnBHasPrivateKey
Local lcStrData
Local lcStrSignature

loCrypt = Createobject('Chilkat.Crypt2')

*  Any string argument automatically begins the 30-day trial.

lnSuccess = loCrypt.UnlockComponent("30-day trial")
If (lnSuccess <> 1) Then
   =Messagebox("Crypt component unlock failed")
   Quit
Endif

loCert = Createobject('Chilkat.Cert')
lnSuccess = loCert.LoadByCommonName("Chilkat Software")
If (lnSuccess <> 1) Then
   =Messagebox(loCert.LastErrorText)
   Quit
Endif

*  Make sure this certificate has a private key available:

lnBHasPrivateKey = loCert.HasPrivateKey()
If (lnBHasPrivateKey <> 1) Then
   =Messagebox("No private key available for signing.")
   Quit
Endif

*  Tell the encryption component to use this cert.
loCrypt.SetSigningCert(loCert)

lcStrData = "This is the data to be signed."

*  Indicate that the PKCS7 signature should be returned
*  as a base64 encoded string:
loCrypt.EncodingMode = "base64"

*  The EncodingMode may be set to other values such as
*  "hex", "url", "quoted-printable", etc.

lcStrSignature = loCrypt.SignStringENC(lcStrData)

? lcStrSignature

*  Now verify the signature against the original data.

*  Tell the component what certificate to use for verification.
loCrypt.SetVerifyCert(loCert)

lnSuccess = loCrypt.VerifyStringENC(lcStrData,lcStrSignature)
If (lnSuccess = 1) Then
   =Messagebox("digital signature verified")
Else
   =Messagebox("digital signature invalid")
Endif

*  Try it with incorrect data:
lnSuccess = loCrypt.VerifyStringENC("This is not the signed data",lcStrSignature)
If (lnSuccess = 1) Then
   =Messagebox("digital signature verified")
Else
   =Messagebox("digital signature invalid")
Endif
