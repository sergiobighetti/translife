#Define CR_LF Chr(13)+Chr(10)

#If 1=2
   1         2         3         4         5         6
   123456789012345678901234567890123456789012345678901234567890
#Endif


??? Chr(15)      && ativa compressao
DO case
   CASE FSIZE('NOME') >0
      cNome = nome
   CASE FSIZE('NOMEASSOCI') > 0
      cNome = NOMEASSOCI
   OTHERWISE
      cNome = ''
ENDCASE
??? ALLTRIM(cNome)

??? CR_LF
??? ALLT(Endereco)+' '+ALLT(Complement)

??? CR_LF
??? ALLT(Bairro)

??? CR_LF
??? ALLT(Cidade)+" / "+ALLT(Uf)

??? CR_LF
??? "CEP: "+ALLT(CEP)
??? Chr(18)      && DESativa compressao

??? CR_LF
??? CR_LF

SET PRINTER to
