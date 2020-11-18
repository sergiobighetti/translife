LPARAM cArq, cTipo
LOCAL nRtn AS INTEGER, cClassificacao AS STRING,cTm_Saida AS STRING
LOCAL cTm_NLOCA AS STRING, cTm_SLOCA AS STRING, cTm_Alarm, nRt

nRtn = RGB(255,255,255) && BRANCO

IF USED( cArq ) AND !EOF( cArq ) AND !BOF( cArq )

   IF cTipo = 'FUNDO'

      cTm_Alarm = STRTRAN( &cArq..Alarm, ':', '' )
      cTm_Saida = STRTRAN( &cArq..Saida, [:], [] )
      cTm_NLOCA = STRTRAN( &cArq..N_Loc, [:], [] )
      cTm_SLOCA = STRTRAN( &cArq..S_Loc, [:], [] )

      DO CASE

         CASE NOT EMPTY( cTm_SLOCA )
            nRtn = RGB(87,200,132) && VERDE

         CASE NOT EMPTY( cTm_NLOCA )
            nRtn = RGB(255,128,0)   && LARANJA

         CASE NOT EMPTY( cTm_Alarm )
            nRtn = RGB(113,184,255) && AZUL

         OTHERWISE
            nRtn = RGB(255,255,255) && BRANCO

      ENDCASE


   ELSE

      nRtn = RGB(   0,  0,  0 )

      cClassificacao  = &cArq..Classificacao

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
            nRt = RGB( 255,255,255 )

      ENDCASE

   ENDIF

ENDIF

RETURN nRtn
