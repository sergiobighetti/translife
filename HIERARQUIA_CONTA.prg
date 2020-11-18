* nNivel = 1

CLOSE DATABASES all
CLEAR

USE conta

fi_Hierarquia( 20020, 'idcta', 'idGrupo', ALIAS(),  'idGrupo' )


FUNCTION fi_Hierarquia
Lparameters iPK as Integer, cPKField as String, cParentPKField as String, cAlias as String, cFinalSortTag as String
*---Parm Notes
* iPK            = The "key" value of the first parent record
* cPKField    = The name of the "field" used as the "primary key".
* cParentPKField = The name of the "field" used to "relate a child back to it's parent".
* cAlias    = The name of the "table" to get records from.
* cFinalSortTag    = The field(s) that will "sort" the final results.

*---Clean Up Parms (You should change this to substitute your own "Default" values).
If Type('iPK') <> 'N'
   =MessageBox("Please pass a beginning Primary Key Value to process.",48,"Error",5000)
   Return
EndIf
If Type('cPKField') <> 'C' or Empty(cPKField)
   cPKField = "inl_pk"
EndIf
If Type('cAlias') <> 'C' or Empty(cAlias)
   cAlias = "invline"
Endif
If Type('cParentPKField') <> 'C' or Empty(cParentPKField)
   cParentPKField = 'inl_parent_pk'
EndIf
If Type('cFinalSortTag') <> 'C' or Empty(cFinalSortTag)
   cFinalSortTag = 'inl_show_order'
Endif

If !Used(cAlias)
   Use (cAlias) In 0
EndIf


*---Setup cursors.
If Used('csrAll')
   Use In csrAll
Endif
If Used('csrChildRows')
   Use In csrChildRows
Endif

*Get original Parent Record and store them in our "master" cursor csrAll.
Select * From &cAlias Where &cPKField = iPK Into Cursor csrAll Readwrite

*Initialize this csrChildRows cursor with original parent set.
Select * From csrAll Into Cursor csrChildRows Readwrite


*---Get Child Records.
*Drill down through all levels of child, grandchild, etc. to extract related records.
If !Eof('csrAll')
   Do While .T.
      *Get all children for the current set of parent records.
      Select * From &cAlias Where &cParentPKField In   (Select &cPKField From csrChildRows) Into Cursor csrNewRows Readwrite

      If _Tally = 0
         Exit
      EndIf
      
      *Add the found children records to our "Master" table.
      Select csrAll
      Append From Dbf('csrNewRows') For !Deleted()

      *Make this set of children, the next set of parents (this is the 'recursive' part).
      Select * From csrNewRows Into Cursor csrChildRows Readwrite
   Enddo
Endif


   Use In (SELECT('csrAllRows'))
   Use In (SELECT('csrChildRows'))
   Use In (SELECT('csrNewRows'))


*---At this point, our "master" cursor (csrAll) contains the original
*Parent records and ALL related children, grandchildren, and so on.
Select csrAll
Select * from csrAll order by &cFinalSortTag into cursor csrSorted


Select csrAll
Browse normal title "All Related Records..."

If Used('csrSorted')
   Use in csrSorted
ENDIF

*---Cleanup
If Used('csrAll')
   Use in csrAll
EndIf