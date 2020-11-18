Local nSel, cTmp, cSql, cCod, nCtd
Local aOpen[1], x, laClosed[1]

=Aused( aOpen )

nSel = Select()
cTmp = Sys(2015)

Select    'A' As CODIGO                                                                                                                    ;
   , aa.EVOLUCAO                                                                                                                     ;
   , aa.bop_id                                                                                                                       ;
   , aa.bop_nome                                                                                                                     ;
   , tt.TOTATEND                                                                                                                     ;
   , aa.CORONA_TOTAL                                                                                                                 ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.CORONA_TOTAL/tt.TOTATEND )*100),0) As N(6,2) )                  As PERC_CORONA_SOBRE_TotAtend     ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.CORONA_TOTAL/tt.TOTATEND )*80,0) ), 100 )        As GRAF_CORONA_SOBRE_TotAtend     ;
   ;
   , aa.CV19_ASSINT                                                                                                                  ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_ASSINT/tt.CORONA_TOTAL )*100),0) As N(6,2) )           As PERC_ASSINT_SOBRE_CORONA_TOTAL ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_ASSINT/tt.CORONA_TOTAL )*80 ,0)), 100 ) As GRAF_ASSINT_SOBRE_CORONA_TOTAL ;
   ;
   , aa.CV19_LEVE                                                                                                                    ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_LEVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )             As PERC_LEVE_SOBRE_CORONA_TOTAL   ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_LEVE/tt.CORONA_TOTAL )*80 ,0)), 100  )  As GRAF_LEVE_SOBRE_CORONA_TOTAL   ;
   ;
   , aa.CV19_GRAVE                                                                                                                   ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_GRAVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )            As PERC_GRAVE_SOBRE_CORONA_TOTAL  ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_GRAVE/tt.CORONA_TOTAL )*80 ,0)), 100 )  As GRAF_GRAVE_SOBRE_CORONA_TOTAL  ;
   ;
   , aa.OMT                                                                                                                          ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.OMT/tt.TOTATEND )*100) ,0) As N(6,2) )                          As PERC_OMT_SOBRE_TotAtend        ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.OMT/tt.TOTATEND )*80,0)), 100  )                 As GRAF_OMT_SOBRE_TotAtend        ;
   FROM     bdmdc!V_BASE_COVIDl9_U3D aa                                                                                                       ;
   JOIN (   Select                                                                                                                            ;
   aa.bop_id                                                                                                                ;
   , Sum(aa.CORONA_TOTAL)  As CORONA_TOTAL                                                                                   ;
   , Sum(aa.CV19_ASSINT)   As CV19_ASSINT                                                                                    ;
   , Sum(aa.CV19_LEVE)   As CV19_LEVE                                                                                        ;
   , Sum(aa.CV19_GRAVE)  As CV19_GRAVE                                                                                       ;
   , Sum(aa.OMT)  As OMT                                                                                                     ;
   , Sum(aa.CORONA_TOTAL+aa.OMT)  As TOTATEND                                                                                ;
   FROM      bdmdc!V_BASE_COVIDl9_U3D  aa                                                                                            ;
   GROUP By  aa.bop_id ) tt On tt.bop_id= aa.bop_id ;
   INTO Cursor (cTmp) Readwrite

Insert Into (cTmp) ( CODIGO, EVOLUCAO, bop_id, bop_nome, TOTATEND, CORONA_TOTAL, PERC_CORONA_SOBRE_TotAtend, GRAF_CORONA_SOBRE_TotAtend, CV19_ASSINT, PERC_ASSINT_SOBRE_CORONA_TOTAL, GRAF_ASSINT_SOBRE_CORONA_TOTAL, CV19_LEVE, PERC_LEVE_SOBRE_CORONA_TOTAL, GRAF_LEVE_SOBRE_CORONA_TOTAL, CV19_GRAVE, PERC_GRAVE_SOBRE_CORONA_TOTAL, GRAF_GRAVE_SOBRE_CORONA_TOTAL, OMT,PERC_OMT_SOBRE_TotAtend, GRAF_OMT_SOBRE_TotAtend ) ;
   select    'B' As CODIGO                                                                                                                    ;
   , aa.EVOLUCAO                                                                                                                     ;
   , aa.bop_id                                                                                                                       ;
   , aa.bop_nome                                                                                                                     ;
   , tt.TOTATEND                                                                                                                     ;
   , aa.CORONA_TOTAL                                                                                                                 ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.CORONA_TOTAL/tt.TOTATEND )*100),0) As N(6,2) )                  As PERC_CORONA_SOBRE_TotAtend     ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.CORONA_TOTAL/tt.TOTATEND )*80,0) ), 100 )        As GRAF_CORONA_SOBRE_TotAtend     ;
   ;
   , aa.CV19_ASSINT                                                                                                                  ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_ASSINT/tt.CORONA_TOTAL )*100),0) As N(6,2) )           As PERC_ASSINT_SOBRE_CORONA_TOTAL ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_ASSINT/tt.CORONA_TOTAL )*80 ,0)), 100 ) As GRAF_ASSINT_SOBRE_CORONA_TOTAL ;
   ;
   , aa.CV19_LEVE                                                                                                                    ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_LEVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )             As PERC_LEVE_SOBRE_CORONA_TOTAL   ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_LEVE/tt.CORONA_TOTAL )*80 ,0)), 100  )  As GRAF_LEVE_SOBRE_CORONA_TOTAL   ;
   ;
   , aa.CV19_GRAVE                                                                                                                   ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_GRAVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )            As PERC_GRAVE_SOBRE_CORONA_TOTAL  ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_GRAVE/tt.CORONA_TOTAL )*80 ,0)), 100 )  As GRAF_GRAVE_SOBRE_CORONA_TOTAL  ;
   ;
   , aa.OMT                                                                                                                          ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.OMT/tt.TOTATEND )*100) ,0) As N(6,2) )                          As PERC_OMT_SOBRE_TotAtend        ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.OMT/tt.TOTATEND )*80,0)), 100  )                 As GRAF_OMT_SOBRE_TotAtend        ;
   FROM     bdmdc!V_BASE_COVIDl9_U7D aa                                                                                                       ;
   JOIN (   Select                                                                                                                            ;
   aa.bop_id                                                                                                                ;
   , Sum(aa.CORONA_TOTAL)  As CORONA_TOTAL                                                                                   ;
   , Sum(aa.CV19_ASSINT)   As CV19_ASSINT                                                                                    ;
   , Sum(aa.CV19_LEVE)   As CV19_LEVE                                                                                        ;
   , Sum(aa.CV19_GRAVE)  As CV19_GRAVE                                                                                       ;
   , Sum(aa.OMT)  As OMT                                                                                                     ;
   , Sum(aa.CORONA_TOTAL+aa.OMT)  As TOTATEND                                                                                ;
   FROM      bdmdc!V_BASE_COVIDl9_U7D aa                                                                                            ;
   GROUP By  aa.bop_id ) tt On tt.bop_id= aa.bop_id ;


Insert Into (cTmp) ( CODIGO, EVOLUCAO, bop_id, bop_nome, TOTATEND, CORONA_TOTAL, PERC_CORONA_SOBRE_TotAtend, GRAF_CORONA_SOBRE_TotAtend, CV19_ASSINT, PERC_ASSINT_SOBRE_CORONA_TOTAL, GRAF_ASSINT_SOBRE_CORONA_TOTAL, CV19_LEVE, PERC_LEVE_SOBRE_CORONA_TOTAL, GRAF_LEVE_SOBRE_CORONA_TOTAL, CV19_GRAVE, PERC_GRAVE_SOBRE_CORONA_TOTAL, GRAF_GRAVE_SOBRE_CORONA_TOTAL, OMT,PERC_OMT_SOBRE_TotAtend, GRAF_OMT_SOBRE_TotAtend ) ;
   select    'C' As CODIGO                                                                                                                    ;
   , aa.EVOLUCAO                                                                                                                     ;
   , aa.bop_id                                                                                                                       ;
   , aa.bop_nome                                                                                                                     ;
   , tt.TOTATEND                                                                                                                     ;
   , aa.CORONA_TOTAL                                                                                                                 ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.CORONA_TOTAL/tt.TOTATEND )*100),0) As N(6,2) )                  As PERC_CORONA_SOBRE_TotAtend     ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.CORONA_TOTAL/tt.TOTATEND )*80,0) ), 100 )        As GRAF_CORONA_SOBRE_TotAtend     ;
   ;
   , aa.CV19_ASSINT                                                                                                                  ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_ASSINT/tt.CORONA_TOTAL )*100),0) As N(6,2) )           As PERC_ASSINT_SOBRE_CORONA_TOTAL ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_ASSINT/tt.CORONA_TOTAL )*80 ,0)), 100 ) As GRAF_ASSINT_SOBRE_CORONA_TOTAL ;
   ;
   , aa.CV19_LEVE                                                                                                                    ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_LEVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )             As PERC_LEVE_SOBRE_CORONA_TOTAL   ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_LEVE/tt.CORONA_TOTAL )*80 ,0)), 100  )  As GRAF_LEVE_SOBRE_CORONA_TOTAL   ;
   ;
   , aa.CV19_GRAVE                                                                                                                   ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_GRAVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )            As PERC_GRAVE_SOBRE_CORONA_TOTAL  ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_GRAVE/tt.CORONA_TOTAL )*80 ,0)), 100 )  As GRAF_GRAVE_SOBRE_CORONA_TOTAL  ;
   ;
   , aa.OMT                                                                                                                          ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.OMT/tt.TOTATEND )*100) ,0) As N(6,2) )                          As PERC_OMT_SOBRE_TotAtend        ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.OMT/tt.TOTATEND )*80,0)), 100  )                 As GRAF_OMT_SOBRE_TotAtend        ;
   FROM     bdmdc!V_BASE_COVIDl9_U14D aa                                                                                                       ;
   JOIN (   Select                                                                                                                            ;
   aa.bop_id                                                                                                                ;
   , Sum(aa.CORONA_TOTAL)  As CORONA_TOTAL                                                                                   ;
   , Sum(aa.CV19_ASSINT)   As CV19_ASSINT                                                                                    ;
   , Sum(aa.CV19_LEVE)   As CV19_LEVE                                                                                        ;
   , Sum(aa.CV19_GRAVE)  As CV19_GRAVE                                                                                       ;
   , Sum(aa.OMT)  As OMT                                                                                                     ;
   , Sum(aa.CORONA_TOTAL+aa.OMT)  As TOTATEND                                                                                ;
   FROM      bdmdc!V_BASE_COVIDl9_U14D aa                                                                                            ;
   GROUP By  aa.bop_id ) tt On tt.bop_id= aa.bop_id ;

Insert Into (cTmp) ( CODIGO, EVOLUCAO, bop_id, bop_nome, TOTATEND, CORONA_TOTAL, PERC_CORONA_SOBRE_TotAtend, GRAF_CORONA_SOBRE_TotAtend, CV19_ASSINT, PERC_ASSINT_SOBRE_CORONA_TOTAL, GRAF_ASSINT_SOBRE_CORONA_TOTAL, CV19_LEVE, PERC_LEVE_SOBRE_CORONA_TOTAL, GRAF_LEVE_SOBRE_CORONA_TOTAL, CV19_GRAVE, PERC_GRAVE_SOBRE_CORONA_TOTAL, GRAF_GRAVE_SOBRE_CORONA_TOTAL, OMT,PERC_OMT_SOBRE_TotAtend, GRAF_OMT_SOBRE_TotAtend ) ;
   select    'D' As CODIGO                                                                                                                    ;
   , aa.EVOLUCAO                                                                                                                     ;
   , aa.bop_id                                                                                                                       ;
   , aa.bop_nome                                                                                                                     ;
   , tt.TOTATEND                                                                                                                     ;
   , aa.CORONA_TOTAL                                                                                                                 ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.CORONA_TOTAL/tt.TOTATEND )*100),0) As N(6,2) )                  As PERC_CORONA_SOBRE_TotAtend     ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.CORONA_TOTAL/tt.TOTATEND )*80,0) ), 100 )        As GRAF_CORONA_SOBRE_TotAtend     ;
   ;
   , aa.CV19_ASSINT                                                                                                                  ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_ASSINT/tt.CORONA_TOTAL )*100),0) As N(6,2) )           As PERC_ASSINT_SOBRE_CORONA_TOTAL ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_ASSINT/tt.CORONA_TOTAL )*80 ,0)), 100 ) As GRAF_ASSINT_SOBRE_CORONA_TOTAL ;
   ;
   , aa.CV19_LEVE                                                                                                                    ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_LEVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )             As PERC_LEVE_SOBRE_CORONA_TOTAL   ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_LEVE/tt.CORONA_TOTAL )*80 ,0)), 100  )  As GRAF_LEVE_SOBRE_CORONA_TOTAL   ;
   ;
   , aa.CV19_GRAVE                                                                                                                   ;
   , Cast( Iif(tt.CORONA_TOTAL>0, ((aa.CV19_GRAVE/tt.CORONA_TOTAL )*100),0) As N(6,2) )            As PERC_GRAVE_SOBRE_CORONA_TOTAL  ;
   , Padr( Replicate( '|', Iif(tt.CORONA_TOTAL>0, (aa.CV19_GRAVE/tt.CORONA_TOTAL )*80 ,0)), 100 )  As GRAF_GRAVE_SOBRE_CORONA_TOTAL  ;
   ;
   , aa.OMT                                                                                                                          ;
   , Cast( Iif(tt.TOTATEND>0, ((aa.OMT/tt.TOTATEND )*100) ,0) As N(6,2) )                          As PERC_OMT_SOBRE_TotAtend        ;
   , Padr( Replicate( '|', Iif(tt.TOTATEND>0, (aa.OMT/tt.TOTATEND )*80,0)), 100  )                 As GRAF_OMT_SOBRE_TotAtend        ;
   FROM     bdmdc!V_BASE_COVIDl9_U30D aa                                                                                                       ;
   JOIN (   Select                                                                                                                            ;
   aa.bop_id                                                                                                                ;
   , Sum(aa.CORONA_TOTAL)  As CORONA_TOTAL                                                                                   ;
   , Sum(aa.CV19_ASSINT)   As CV19_ASSINT                                                                                    ;
   , Sum(aa.CV19_LEVE)   As CV19_LEVE                                                                                        ;
   , Sum(aa.CV19_GRAVE)  As CV19_GRAVE                                                                                       ;
   , Sum(aa.OMT)  As OMT                                                                                                     ;
   , Sum(aa.CORONA_TOTAL+aa.OMT)  As TOTATEND                                                                                ;
   FROM      bdmdc!V_BASE_COVIDl9_U30D aa                                                                                            ;
   GROUP By  aa.bop_id ) tt On tt.bop_id= aa.bop_id ;


Select * From (cTmp) Order By  CODIGO, bop_id Into Cursor (cTmp) Readwrite

If _Tally > 0

   Select *, EVOLUCAO As xEVO From (cTmp) Into Cursor lvANLSCVl9

   Select (cTmp)
   Do While !Eof()
      cCod = CODIGO
      nCtd = 0
      Scan While cCod = CODIGO
         If nCtd>0
            Replace EVOLUCAO With ''
         Endif
         nCtd = nCtd + 1
      Endscan
   Enddo

   Do Form c:\desenv\win\vfp9\libbase\PESQUISA With 'SELECT * FROM '+cTmp ,,'FI_cv19GRAFICO("lvANLSCVl9")','Estatisticas Diversas', [IIF(CODIGO $ "AC",16777088,16777215)]

Endif

Use In ( Select('lvANLSCVl9') )


Use In ( Select(cTmp))
For x=1 To Aused( laClosed )
   If Ascan( aOpen, laClosed[x,1]) = 0
      Use In (laClosed[x,1])
   Endif
Next


Select (nSel)
