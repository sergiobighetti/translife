FUNCTION fi_Clas_Cor( cClassificacao  )
LOCAL nRtn

      nRtn = RGB(   0,  0,  0 )

      DO CASE

         CASE cClassificacao = 'EME'
            nRtn = RGB(255,  0,  0)  && VERMELHO

         CASE cClassificacao = 'URG'
            nRtn = RGB(255,255,  0)  && AMARELO

         CASE LEFT(cClassificacao,6) = 'CONSUL'
            nRtn = RGB(  0,255,  0)  && VERDER

         CASE LEFT(cClassificacao,6)= 'CONS.P'
            nRtn = RGB(201,201,146)  && VERDER ...

         CASE cClassificacao = 'TRA'
            nRtn = RGB(  0,255,255)  && AZUL

         CASE cClassificacao = 'INF'
            nRtn = 33023             && MARROM

         CASE cClassificacao = 'ORI'
            nRtn = RGB(128,128,192)  && ROXO

         CASE cClassificacao = 'AGE'
            nRtn = RGB(125,128,128)  && SALMAO
            
         OTHERWISE
            nRtn = RGB( 255,255,255 )

      ENDCASE
      
RETURN nRtn 