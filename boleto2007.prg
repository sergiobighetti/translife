LOCAL cDir

SET ENGINEBEHAVIOR 90

*!*   COLETIVO
*!*   perido canc DATAEXC 01/10/2007 ate 29/11/2007
*!*   vcto  10/12

*!*   TITULARES
*!*   9.90

*!*   SO ENDERECO <> CONTRATO

*!*   RETIRAR AGRUPAMENTO 21
*!*   MOTIVOCANC <> FALECIMENTO

CLOSE DATABASES all
CLOSE TABLES all
SET EXCLUSIVE off



cDir = '\\dcrpo\bdmdc$\'
SELECT      ;
            aa.endereco                                      as endereco,;
            aa.complemento                                   as complmto,;
            aa.cidade                                        as cidade,;
            aa.bairro                                        as bairro,;
            aa.uf                                            as uf,;
            aa.cep                                           as cep,;
            aa.idContrato                                    as Contrato,;
            aa.nome                                          as NomeAssoc,;
            bb.nome_responsavel                              as NomeResp,;
            padr(aa.cpf ,18)                                 as CGC_CPF,;
            DATE( 2007, 12, 10 )                             as vencto,;
            $9.90                                            as valor,;
            space(40)                                        as historico,;
            bb.tipo_contrato                                 as TipoContr,;
            CAST( 0 as Integer)                              as controle,;
            CAST( '' as memo)                                as obs,;
            CAST( 0 as Integer)                              as NroNF,;
            '  '                                             as f_l_a_g, ;
            ( SELECT SUM(ap.valor) FROM ASSOCIADO_PLANO ap WHERE ap.idAssoc == aa.idAssoc ) as VALOR_IND,;
            aa.codigo          COD_COMPL,;
            LEFT(aa.codigo,10) COD_BASE ;
            ;
            ;
FROM        (cDir+"ASSOCIADO") aa ;
JOIN        (cDir+"CONTRATO")  bb  ON aa.idcontrato == bb.idcontrato ;
WHERE       aa.dataExc BETWEEN {^2007-10-01} AND {^2007-11-30} ;
        and aa.situacao            = 'CANCELADO' ;
        and bb.idFilial            = '01' ;
        and bb.tipo_contrato       = 'COL' ;
        and aa.endereco            # bb.endereco ;
        and bb.agrupamento         # '21' ;
        and ! aa.motivocancel      = 'FALECIMENT' ;
        AND aa.atendimento         = .t. ;
        AND ! INLIST( aa.idcontrato, 11118, 66299 ) ;
ORDER BY aa.idContrato ;
INTO CURSOR CBASE

        



SELECT      ;
            aa.*, ;
            ;
            ( SELECT COUNT(*) FROM CBASE bb WHERE bb.cod_base = aa.cod_base ) qtd_DEP ;
            ;
FROM        CBASE aa ;
WHERE       SUBSTR(aa.COD_COMPL,11,2) = '00' ;
INTO CURSOR CVER READWRITE 

REPLACE VALOR WITH qtd_DEP * 9.90 ALL
BROW
