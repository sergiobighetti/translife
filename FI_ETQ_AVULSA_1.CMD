#Define CR_LF Chr(13)+Chr(10)

#If 1=2
   1         2         3         4         5         6
   123456789012345678901234567890123456789012345678901234567890
#Endif

??? Chr(18)      && DESativa compressao
??? ALLTRIM(nome)

??? Chr(15)      && ativa compressao
??? CR_LF
??? ALLT(Endereco)+' '+ALLT(Complement)

??? Chr(18)      && DESativa compressao

??? CR_LF
??? ALLT(Bairro)

??? CR_LF
??? ALLT(Cidade)+" / "+ALLT(Uf)

??? CR_LF
??? "CEP: "+ALLT(CEP)

??? CR_LF
??? CR_LF

*------ ETIQUETA MAIOR
??? CR_LF
??? CR_LF
??? CR_LF


SET PRINTER to
