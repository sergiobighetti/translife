SELECT * FROM pasta1 WHERE 1=2 INTO CURSOR CLV READWRITE

SELECT pasta1
GO TOP
SCAN 

   SELECT pasta1

   SCATTER NAME oReg

  
   DIMENSION aX[15]
   STORE '' TO aX
   aX[1] = TRANSFORM(a, '@L 99' )
   aX[2] = TRANSFORM(b, '@L 99' )
   aX[3] = TRANSFORM(c, '@L 99' )
   aX[4] = TRANSFORM(d, '@L 99' )
   aX[5] = TRANSFORM(e, '@L 99' )
   aX[6] = TRANSFORM(f, '@L 99' )
   aX[7] = TRANSFORM(g, '@L 99' )
   aX[8] = TRANSFORM(h, '@L 99' )
   aX[9] = TRANSFORM(i, '@L 99' )
   aX[10] = TRANSFORM(j, '@L 99' )
   ax[11] = TRANSFORM(k, '@L 99' )
   aX[12] = TRANSFORM(l, '@L 99' )
   aX[13] = TRANSFORM(m, '@L 99' )
   aX[14] = TRANSFORM(n, '@L 99' )
   aX[15] = TRANSFORM(o, '@L 99' )
   
    = ASORT(aX)


   oReg.a =INT(VAL(aX[1]))
   oReg.b =INT(VAL(aX[2]))
   oReg.c =INT(VAL(aX[3]))
   oReg.d =INT(VAL(aX[4]))
   oReg.e =INT(VAL(aX[5]))
   oReg.f =INT(VAL(aX[6]))
   oReg.g =INT(VAL(aX[7]))
   oReg.h =INT(VAL(aX[8]))
   oReg.i =INT(VAL(aX[9]))
   oReg.j =INT(VAL(aX[10]))
   oReg.k =INT(VAL(aX[11]))
   oReg.l =INT(VAL(aX[12]))
   oReg.m =INT(VAL(aX[13]))
   oReg.n =INT(VAL(aX[14]))
   oReg.o =INT(VAL(aX[15]))
   
   SELECT CLV
   APPEND BLANK 
   GATHER NAME oReg
   
   
   SELECT pasta1

ENDSCAN