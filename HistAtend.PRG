LPARAM cCodMed, dRef, cDeOndeVem
LOCAL nPos, nSel, cWhe, cRunFORM, lUsaATD, lUsaHST, lUsaCTR, cCabec, cHst
LOCAL aOpen[1], x, laClosed[1]

CHST    = SYS(2015)
nSel    = SELECT()
cCabec  = [Histórico de Atendimento(s)]

IF !EMPTY( cCodMed )

   =Aused( aOpen )
   
   lUsaATD = USED( 'ATENDIMENTO' )
   lUsaHST = USED( 'HSTATEND' )
   lUsaCTR = USED( 'CONTRATO' )

   cDeOndeVem = IIF( TYPE( 'cDeOndeVem' )='C', cDeOndeVem, 'CADASTRO' )
   
   IF TYPE( 'dRef' ) = 'D'
      dRef = DATETIME( YEAR(dRef), MONTH(dRef), DAY(dRef), 23, 23, 59 )
   ENDIF

   IF TYPE( 'cCodMed')= 'N'
      cWhe = 'att.ctrNumero ='+TRANSFORM(cCodMed)
   ELSE
      cCodMed = ALLTRIM( cCodMed )
      cWhe = 'att.paccodigo LIKE "'+cCodMed+'%"'
   ENDIF
   
   IF cDeOndeVem # 'CADASTRO'
      cRunFORM = NULL
   ELSE
      cRunFORM = 'FI_TELA_ATEND( arquivo, Sequencia )'
   endif

   IF TYPE( 'dRef' ) $ 'DT'
      cWhe = cWhe + ' AND att.tm_chama < {^'+;
             TRAN(YEAR(dRef)) +'-'+TRAN( MONTH(dRef)) +'-'+ TRAN(DAY(dRef)) +' '+;
             TRAN(HOUR(dRef)) +':'+TRAN(MINUTE(dRef)) +':'+ TRAN(SEC(dRef)) +'}'
      cCabec = cCabec + [ anterior(es) a ]+ TTOC(dRef)
   ENDIF


   SELECT          att.tm_chama          AS DataEvento,;
                   LEFT(att.pacNome,35)  AS Paciente,;
                   IIF(att.liberacao=3,  'Regulado  ', IIF(att.liberacao=2 AND att.situacao=1, 'Pendente  ', IIF( EMPTY(att.medclassificacao), att.REGclassificacao, att.medclassificacao ) )) AS Clas_Med,;
                   IIF(att.liberacao=1,  'Aguarg', IIF(att.liberacao=2,  'Liber.','N/Lib.')) AS situacao,;
                   NVL(LEFT(hd.descricao,30),SPACE(30)) as HD_DESCRICAO,;
                   att.resumoatendimento AS Resumo, ;
                   att.pacidade          AS Idade,;
                   att.CodAtendimento    As CodAtend,;
                   ta.descricao          aS TpAtend,;
                   att.pacbairro         AS Bairro,;
                   att.pacendereco       AS Endereco,;
                   att.paccomplemento    AS Complemto,;
                   att.solnome           AS Solic_Nome,;
                   att.solfone           AS Solic_fone,;
                   NVL(s1.descricao,SPACE(30)) AS Sint1,;
                   NVL(s2.descricao,SPACE(30)) AS Sint2,;
                   NVL(s3.descricao,SPACE(30)) AS Sint3,;
                   att.outrossintomas as Sint_outros,;
                   NVL(atd.NOME,SPACE(35))     AS Atendente,;
                   NVL(reg.NOME,SPACE(35))     AS Regulador,;
                   NVL(rop.NOME,SPACE(35))     AS R_Operador,;
                   NVL(med.nome,SPACE(35))   AS MEDICO,;
                   PADR(att.idEnfermeiro,35)   AS ENFERMEIRO,;
                   att.idunidademovel    AS Unidade,;
                   IIF( att.idunidademovel > 0 AND att.idmedico>0, 'USA', IIF( att.idunidademovel > 0 AND att.idmedico=0, 'USB', '   ' )) as TPUND,;
                   att.pacNome  AS NomeCompleto,;
                   'ATENDIMENTO' AS arquivo,;
                   att.ID                AS Sequencia,;
                   att.medicacao,;
                   att.pacCodigo as Codigo, ;
                   att.idcancelamento ;
   FROM            Atendimento att ;
   LEFT OUTER JOIN TIPOATEND ta ON att.CodAtendimento == ta.ID    ;
   LEFT OUTER JOIN EQUIPE atd   ON att.idatendente    == atd.ID       ;
   LEFT OUTER JOIN EQUIPE reg   ON att.idRegulador    == reg.ID       ;
   LEFT OUTER JOIN EQUIPE rop   ON att.idRO           == rop.ID       ;
   LEFT OUTER JOIN EQUIPE med   ON att.idMedico       == med.ID       ;
   LEFT OUTER JOIN SINTOMA s1   ON att.idSintomas1    == s1.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s2   ON att.idSintomas2    == s2.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s3  ON att.idSintomas3     == s3.SINTOMA   ;
   LEFT OUTER JOIN HIPODIAG hd ON att.idHipoteseDiag == hd.id ;
   WHERE           &cWhe ;
   ORDER BY        1 DESC ;
   GROUP BY        att.ID ;
   INTO CURSOR     CHST1

   SELECT          att.tm_chama          AS DataEvento,;
                   LEFT(att.pacNome,35)  AS Paciente,;
                   IIF(att.liberacao=3,  'Regulado  ', IIF(att.liberacao=2 AND att.situacao=1, 'Pendente  ', IIF( EMPTY(att.medclassificacao), att.REGclassificacao, att.medclassificacao ) )) AS Clas_Med,;
                   IIF(att.liberacao=1,  'Aguarg', IIF(att.liberacao=2,  'Liber.','N/Lib.')) AS situacao,;
                   NVL(LEFT(hd.descricao,30),SPACE(30)) as HD_DESCRICAO,;
                   att.resumoatendimento AS Resumo, ;
                   att.pacidade          AS Idade,;
                   att.CodAtendimento    As CodAtend,;
                   ta.descricao          aS TpAtend,;
                   att.pacbairro         AS Bairro,;
                   att.pacendereco       AS Endereco,;
                   att.paccomplemento    AS Complemto,;
                   att.solnome           AS Solic_Nome,;
                   att.solfone           AS Solic_fone,;
                   NVL(s1.descricao,SPACE(30)) AS Sint1,;
                   NVL(s2.descricao,SPACE(30)) AS Sint2,;
                   NVL(s3.descricao,SPACE(30)) AS Sint3,;
                   att.outrossintomas as Sint_outros,;
                   NVL(atd.NOME,SPACE(35))     AS Atendente,;
                   NVL(reg.NOME,SPACE(35))     AS Regulador,;
                   NVL(rop.NOME,SPACE(35))     AS R_Operador,;
                   NVL(med.nome,SPACE(35))   AS MEDICO,;
                   PADR(att.idEnfermeiro,35)   AS ENFERMEIRO,;
                   att.idunidademovel    AS Unidade,;
                   IIF( att.idunidademovel > 0 AND att.idmedico>0, 'USA', IIF( att.idunidademovel > 0 AND att.idmedico=0, 'USB', '   ' )) as TPUND,;
                   att.pacNome  AS NomeCompleto,;
                   'HISTORICO  ' AS arquivo,;
                   att.ID                AS Sequencia,;
                   att.medicacao,;
                   att.pacCodigo as Codigo, ;
                   att.idcancelamento ;
   FROM            HstAtend att ;
   LEFT OUTER JOIN TIPOATEND ta ON att.CodAtendimento == ta.ID    ;
   LEFT OUTER JOIN EQUIPE atd   ON att.idatendente    == atd.ID       ;
   LEFT OUTER JOIN EQUIPE reg   ON att.idRegulador    == reg.ID       ;
   LEFT OUTER JOIN EQUIPE rop   ON att.idRO           == rop.ID       ;
   LEFT OUTER JOIN EQUIPE med   ON att.idMedico       == med.ID       ;
   LEFT OUTER JOIN SINTOMA s1   ON att.idSintomas1    == s1.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s2   ON att.idSintomas2    == s2.SINTOMA   ;
   LEFT OUTER JOIN SINTOMA s3  ON att.idSintomas3     == s3.SINTOMA   ;
   LEFT OUTER JOIN HIPODIAG hd ON att.idHipoteseDiag == hd.id ;
   WHERE           &cWhe ;
   ORDER BY        1 DESC ;
   GROUP BY        att.ID ;
   INTO CURSOR     CHST2

   SELECT * FROM CHST1 UNION ALL SELECT * FROM CHST2 INTO CURSOR (cHST) READWRITE
   
   SCAN 
      nPos = INT(VAL(ENFERMEIRO))
      IF nPos > 0
         IF PTAB( nPos, 'EQUIPE', 'ID' )
            replace ENFERMEIRO WITH EQUIPE.nome IN (cHST)
         ENDIF
      ENDIF
   ENDSCAN

   USE IN ( SELECT( 'CHST1' ) )
   USE IN ( SELECT( 'CHST2' ) )

   IF cDeOndeVem # 'WZREG'

      IF _TALLY > 0
      
         DO FORM PESQUISA WITH 'SELECT * FROM '+cHst,,cRunFORM,cCabec

      ELSE

         MESSAGEBOX( 'ASSOCIADO NÃO POSSUI ATENDIMENTO ANTERIOR ', 16, 'Atenção' )

      ENDIF

      USE IN ( SELECT( CHST  ) )
      
   ENDIF

   For x=1 To Aused( laClosed )
      If Ascan( aOpen, laClosed[x,1]) = 0
         IF cDeOndeVem = 'WZREG' AND laClosed[x,1] = cHST
         else
            Use In (laClosed[x,1])
         ENDIF 
      Endif
   Next

ENDIF

SELE (nSel)

IF cDeOndeVem = 'WZREG'
   RETURN cHst
ELSE
   RETURN ''
ENDIF   


FUNCTION FI_TELA_ATEND( cArq, nID )
DO FORM ATEND_CAD WITH nID, 4
RETURN
ENDFUNC 