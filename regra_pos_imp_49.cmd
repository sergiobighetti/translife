***************************************************************************************************************
* Regra de valorização de produtos para o contrato da 49 PROTESTE
* O ponto de equilibro é 25.000 vidas ao custo de 1,76 = R$ 44.000,00
* apos 25.000 vidas até 29.000 - cobrar as vidas excedente a R$ 1,56
* apos 29.001 vidas até 33.000 - cobrar as vidas excedentes a R$ 1,36
***************************************************************************************************************
Lparameters nCtr, dRef
LOCAL nIdA, nIdP, nVlr, cTmp, nSel, oTerm, nTotal, nPerc, nRec, lAlerta, nQtdVidas , nAplicar 

nSel = SELECT()
cTmp = SYS(2015)

nCtr = 49
dRef = DATE()

WAIT WINDOW tran(nCtr) + ') ACERTO DE VALORES. Selecionando... aguarde' NOWAIT NOCLEAR

set dele ON
lAlerta = .f.


Select      COUNT(1) as qtdAssoc ;
FROM        ASSOCIADO aa ;
WHERE       aa.idContrato=nCtr And aa.situacao='ATIVO' AND aa.atendimento=.t. ;
INTO Cursor (cTmp)

nQtdVidas = &cTmp..qtdAssoc
nPiso     = MAX( ( 44000/nQtdVidas ), 1.76 )


Do Case

   Case ( nQtdVidas >= 00000 AND nQtdVidas <= 25000 )   && 25.000 vidas ao custo de 1,76
      nVlr = nPiso                                       && R$ 44.000,00 é o piso

   Case ( nQtdVidas >= 25001 AND nQtdVidas <= 29000 )   && 25.001 vidas até 29.000 - cobrar as vidas excedente a R$ 1,56
      nVlr = 1.56

   Case ( nQtdVidas >= 29001 AND nQtdVidas <= 33000 )   && 29.001 vidas até 33.000 - cobrar as vidas excedentes a R$ 1,36
      nVlr = 1.36

   Case nQtdVidas >= 33001  && R$ 0,14 POR BENEFICIÁRIO/TITULAR PARA ACIMA DE 100.001 BENEFICIÁRIOS
      nVlr = 1.36
	  lAlerta = .t.

Endcase 


Select      ;
              aa.idAssoc 				               ;
            , MIN(aa.idPlano) as idPlano               ;
FROM        ASSOCIADO_PLANO aa 			               ;
JOIN        ASSOCIADO bb On aa.idAssoc=bb.idAssoc      ;
WHERE       bb.idContrato=nCtr And bb.situacao='ATIVO' ;
GROUP By    aa.idAssoc ;
ORDER By    aa.idAssoc ;
INTO Cursor (cTmp)

WAIT CLEAR 

oTerm = Newobject("_thermometer","_therm","","Procedendo acerto de valores")
oTerm.Show()


nTotal = Reccount( cTmp )

Scan All

   nPerc = ( ( recno(cTmp) / nTotal ) * 100 )
   oTerm.Update( nPerc, "Registro "+TRAN(recno(cTmp))+"/"+TRAN(nTotal))

   nIdA = &cTmp..idAssoc
   nidP = &cTmp..idPlano
   nRec = RECNO(cTmp)

   IF nRec <= 25000
   	  nAplicar = nPiso
   ELSE
      Do Case
		   Case ( nRec >= 25001 AND nRec <= 29000 )   && 25.001 vidas até 29.000 - cobrar as vidas excedente a R$ 1,56
		      nAplicar = 1.56
		   Case ( nRec >= 29001 AND nRec <= 33000 )   && 29.001 vidas até 33.000 - cobrar as vidas excedentes a R$ 1,36
		      nAplicar = 1.36
		   Case nRec   >= 33001  && R$ 0,14 POR BENEFICIÁRIO/TITULAR PARA ACIMA DE 100.001 BENEFICIÁRIOS
		      nAplicar = 1.36
	  endcase
   ENDIF 

   Select ASSOCIADO_PLANO
   SET ORDER TO IDASSOC
   If Seek( nIdA, 'ASSOCIADO_PLANO', 'IDASSOC' )
      Scan While idAssoc=nIdA And !Eof()
         If ASSOCIADO_PLANO.idPlano = nidP
            Replace ASSOCIADO_PLANO.valor_ant With valor
            Replace ASSOCIADO_PLANO.valor     With nAplicar
         Endif
      Endscan
   Endif

   Select (cTmp)
Endscan

oTerm.Complete()


USE IN (SELECT(cTmp))

IF lAlerta
	MESSAGEBOX( 'O contrato excedeu a 33.000 vidas e deve ser renegociado', 64, 'Atenção' )
ENDIF 

SELECT (nSel)

Return Tableupdate( 2, .T., 'ASSOCIADO_PLANO' )