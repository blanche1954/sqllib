// Include Header Files
#include "inkey.ch"
#include "setcurs.ch"

#include "SQLLIB.ch"

REQUEST SQLLIB
REQUEST PGSQL

REQUEST DBFCDX
REQUEST HB_LANG_PT

#define     COLSEP     CHR(32)  + CHR(179) + CHR(32)
#define     HEADSEP    CHR(205) + CHR(209) + CHR(205)
#define     FOOTSEP    CHR(205) + CHR(207) + CHR(205)

FUNCTION Main( cRDD )

   LOCAL b, column, nKey, cScreen, nConn, lRet, aArq
   
   clear screen
   
   cScreen := savescreen()
   
   if valtype( cRdd ) != "C" .or. .not. upper(cRdd) $ [CDX,SQL]
      clear screen
      @10, 01 say "Para executar este exemplo, voce precisa escolher uma das duas opcoes:"
      @12, 01 say "Ex: TBR01 CDX  -> executa este exemplo usando o driver RDDCDX"
      @13, 01 say "Ex: TBR01 SQL  -> executa este exemplo usando o driver SQLLIB"
      @14, 01 say ""
      quit
   endif

   cRdd := upper(cRdd)
   
   HB_LANGSELECT( "PT" )

   SET SCOREBOARD OFF
   SET CONFIRM    ON
   set date       to BRITISH
   set deleted    ON
   set century    ON
   SET AUTOPEN    OFF
   SET AUTORDER   TO 1

   CRIA_TABELA( "CDX" )
   
   if cRdd == "SQL"
      SQL CONN PARAMS TO HOST "localhost" ;
                         USER "postgres"  ;
                     PASSWORD "postgres"  ;
                          VIA "PGSQL"

      if !SL_DATABASE( "demosqllib" )
         SQL CREATE DATABASE "demosqllib" INTO lRet
         IF !lRet
            xmsgstop( "N�o foi poss�vel criar a tabela <demosqllib>" )
            QUIT
         EndIF
      endif

      SQL CONNECT DATABASE "demosqllib" ;
                    SCHEMA "public" ;
                      INTO nConn

      if nConn = 0
         xmsgerror( "Falha na conexao:;;" + SQLERR_MSG() )
         quit
      endif

      SL_DELETEINDEX( , "customer" )  && Aqui exclue todos os indices da tabela "customer"

      SQL RENAMETABLE "test1" TO "testa2" INTO lRet  && Aqui vai retornar .F., pois a tabela n�o existe
 
      if !lRet
         xmsginfo( "N�o foi poss�vel renomear a tabela <test1> !!!", "Aten��o" )
      endif

      SQL RENAMETABLE "customer" TO "customerss" SCHEMA "public" INTO lRet
 
      if !lRet
         xmsginfo( "N�o foi poss�vel renomear a tabela <customer> !!!", "Aten��o" )
      endif

      SQL RENAMETABLE "customerss" TO "customer" INTO lRet
 
      if !lRet
         xmsginfo( "N�o foi poss�vel renomear a tabela <customerss> !!!", "Aten��o" )
      endif

      aStruct := { }
      SQL ADD FIELD "FIRST"  "C" (12, 0) NEWNAME "NOME" DEFAULT "EU"        NOT NULL UNIQUE INTO aStruct
      SQL ADD FIELD "STREET" "C" (40, 0) NEWNAME "RUA"  DEFAULT "RUA GOIAS" NOT NULL UNIQUE INTO aStruct

**
** Aqui mudamos a estrutura da tabela e fazemos backup das COLUNAS que foram modificadas
**

**      SQL CHANGESTRUCT "customer" WITH aStruct INTO lRet BACKUP "030709"
      SQL CHANGESTRUCT "customer" WITH aStruct INTO lRet ONLYFIELDS BACKUP "030709"
** ATEN��O: Se voc� n�o definir o parametro <ONLYFIELDS>, todos os campos(colunas) n�o especificados, ser�o apagados
**          caso contr�rio, somente os campos(colunas) citados acima ser�o modificados sem modificar/apagar os outros
**          campos(colunas)

      if !lRet
         xmsginfo( "N�o foi poss�vel mudar a estrutura da tabela <customer> !!!", "Aten��o" )
      endif

**
** Aqui deletados as colunas de BACKUP
**
      SQL DELETE BACKUP TABLE "customer" INTO lRet

      if !lRet
         xmsginfo( "N�o foi poss�vel apagar as colunas de BACKUP !!!", "Aten��o" )
      endif

      SQL EXIST SCHEMA "public" DATABASE "demosqllib" INTO lRet
      
      xmsgstop( "schema <public> existe em <demosqllib> ?" + hb_valtostr( lRet ) )

      SQL LIST DATABASE INTO lRet

      xmsgstop( "Quais os bancos de dados que existem ? " + SL_ToString( lRet ) )

      SQL LIST SCHEMA DATABASE "demosqllib" INTO lRet

      xmsgstop( "Quais os schemas existem dentro do BD <demosqllib> ?" + SL_ToString( SL_LISTSCHEMA( , "demosqllib" ) ) )

      xmsgstop( "Existe banco de dados <novo> ? " + hb_valtostr(SL_DATABASE( "novo" ) ) )

      SQL CREATE DATABASE "novo" INTO lRet

      xmsgstop( "Criou database <novo> ?" + hb_valtostr( lret ) )

      SQL RENAME DATABASE "novo" TO "velho" INTO lRet

      xmsgstop( "Renomeou o database <novo> para <velho> ?" + hb_valtostr( lRet ) )

      SQL DELETE DATABASE "velho" INTO lRet

      xmsgstop( "Apagou o database <velho> ?" + hb_valtostr( lRet ) )

      SQL EXIST SCHEMA "teste" DATABASE "demosqllib" INTO lRet

      xmsgstop( "Existe schema <teste> no BD <demosqllib> ? " + hb_valtostr( lRet ) )

      SQL CREATE SCHEMA "teste" INTO lRet

      xmsgstop( "Criou o schema <teste> ? " + hb_valtostr( lRet ) )

      SQL EXIST SCHEMA "teste" DATABASE "demosqllib" INTO lRet

      xmsgstop( "Existe schema <teste> no BD <demosqllib> ? " + hb_valtostr( lRet ) )

      SQL RENAME SCHEMA "teste" TO "novo_teste" INTO lRet

      xmsgSTOP( "Alterou o schema <teste> para <novo_teste> ? " + hb_valtostr( lRet ) )

      SQL EXIST SCHEMA "teste" DATABASE "demosqllib" INTO lRet

      xmsgstop( "Existe schema <teste> no BD <demosqllib> ? " + hb_valtostr( lRet ) )

      SQL DELETE SCHEMA "novo_teste" INTO lRet

      xmsgSTOP( "Deletou o schema <novo_teste> ? " + hb_valtostr( lRet ) )

      SQL EXIST SCHEMA "novo_teste" DATABASE "demosqllib" INTO lRet

      xmsgstop( "Existe schema <novo_teste> no BD <demosqllib> ? " + hb_valtostr( lRet ) )

      CRIA_TABELA( "SQL" )

** Para se atribuir aos campos os atributos do sql (NOT NULL / UNIQUE / PRIMARY KEY / DEFAULT), primeiro voc�
** deve importar os DBF�s para dentro do SQL e depois preencher os novos atributos dos campos usando os comandos
** <SQL ADD FIELD> e <SQL CHANGESTRUCT> como citado abaixo:

**      if !SL_FILE( "test" )
**         aArqs := { "test.dbf", "test1.dbf", "test2.dbf" }
**         SQL IMPORT DBF aArqs VIA "DBFCDX" PACK
**      endif
      SQL IMPORT DBF { "test.dbf" } VIA "DBFCDX" PACK

* Tirar esta linha depois
      SL_EXECQUERYEX( "delete from test where sequ = 100" )

      aStruct := { }

      SQL ADD FIELD "SEQU" "N" (15, 0) NOT NULL        PRIMARY KEY 2        INTO aStruct
      SQL ADD FIELD "FLD1" "N" (10, 0) NOT NULL        PRIMARY KEY 1        INTO aStruct
      SQL ADD FIELD "FLD2" "N" (12, 0)          UNIQUE                      INTO aStruct
      SQL ADD FIELD "FLD3" "N" (10, 3) NOT NULL        DEFAULT "-123"       INTO aStruct
      SQL ADD FIELD "FLD4" "C" (30, 0) NOT NULL        DEFAULT "teste1"     INTO aStruct
      SQL ADD FIELD "FLD5" "D" (08, 0) NOT NULL        DEFAULT "2009-07-10" INTO aStruct
      SQL ADD FIELD "FLD6" "L" (01, 0) NOT NULL        DEFAULT "true"       INTO aStruct

      SQL CHANGESTRUCT "test" WITH aStruct INTO lRet BACKUP "060709"

      if !lRet
         xmsginfo( "N�o foi poss�vel mudar a estrutura da tabela <customer> !!!", "Aten��o" )
      endif

      SQL DELETE BACKUP TABLE "test" INTO lRet

      if !lRet
         xmsginfo( "N�o foi poss�vel apagar as colunas de BACKUP !!!", "Aten��o" )
      endif
      
      aArq := { }

xmsgstop( "select * from test = " + hb_valtostr( SL_EXECQUERYEX( "select * from test", , @aArq ) ), "Retornando os dados para uma ARRAY" )

xmsgstop( SL_ToString( aArq ), "aArq" )

xmsgstop( "select * from test = " + hb_valtostr( SL_EXECQUERYEX( "select * from test", , "arqtmp.dbf", .F. ) ), "Retornando os dados para um DBF" )

      USE arqtmp ALIAS "ARQTMP" via "DBFCDX" exclusive new

      clear typeahead
      keyboard chr(0)

      ARQTMP->( browse() )
      
      ARQTMP->( dbclosearea() )
      
xmsgstop( "select * from test = " + hb_valtostr( SL_EXECQUERYEX( "select * from test", , "arqtmp.dbf", .T. ) ), "Retornando os dados para um DBF + RECNO + DELETED" )

      USE arqtmp ALIAS "ARQTMP" via "DBFCDX" exclusive new

      clear typeahead
      keyboard chr(0)

      ARQTMP->( browse() )
      
      ARQTMP->( dbclosearea() )
      
      USE test ALIAS "test" via "SQLLIB" exclusive new
      SL_DELETEINDEX( "_tmp" )

   else
      USE test ALIAS "test" via "DBFCDX" exclusive new
   endif

   index on str(fld1,10,0) to _tmp

*  SETCURSOR(SC_NONE)

   SETCOLOR("N/W")
   
   clear typeahead
   keyboard chr(0)
   
   test->( dbgotop() )

   @ 2, 6 TO 21,72 DOUBLE COLOR "W+/BG"

   b := TBrowseDB( 3, 7, 20, 71 )

   b:colorSpec := "W+/BG,N/W,W/N,N,GR+/W,N/BG,B+/BG,GR+/BG"
   b:colSep    := COLSEP
   b:headSep   := HEADSEP
   b:footSep   := FOOTSEP
   b:freeze    := 1

   // TBColumn objects
   column := TBColumnNew( "Sequence", {|| test->SEQU} )
   column:footing := "SEQU"
   b:addColumn( column )

   column := TBColumnNew( "Field 1", {|| test->fld1} )
   b:addColumn( column )

   column := TBColumnNew( "Field 2", {|| test->fld2} )
   b:addColumn( column )

   column := TBColumnNew( "Field 3", {|| test->fld3} )
   b:addColumn( column )

   column := TBColumnNew( "Field 4", {|| test->fld4} )
   b:addColumn( column )

   column := TBColumnNew( "Field 5", {|| test->fld5} )
   b:addColumn( column )

   column := TBColumnNew( "Field 6", {|| test->fld6} )
   column:footing := "Last;Column"
   b:addColumn( column )

   DO WHILE .T.

      @22, 00 say pad( "[ESC] Encerrar       [DEL] Deletar Registro         [INS] Inserir Registro", 80 )

      IF b:colPos <= b:freeze
         b:colPos := b:freeze + 1
      ENDIF

      ForceStable( b )

      IF b:stable
         IF b:hitTop .OR. b:hitBottom
            TONE(87.3,1)
         ENDIF
         nKey := INKEY(0)
         // Process key
         IF !TBMoveCursor( b, nKey )
            IF     nKey == K_ESC
                   EXIT
            elseif nKey == K_INS
                   TEST->( dbappend() )
                   TEST->( dbcommit() )
            ELSEIF nKey == K_DEL
                   TEST->( dbdelete() )
            ENDIF
         ENDIF
      ENDIF

   ENDDO

   restscreen(,,,,cScreen)

   dbcloseall()

   if cRdd == "SQL"
      SetColor( "W,N" )
      clear screen
      @20, 00 say "Disconectando..."
      SQL DISCONNECT FROM nConn
   endif

   SETCURSOR(SC_NORMAL)
   ? " "
   
RETURN NIL

/*****
 *
 * Cursor Movement Methods
 *
 */

STATIC FUNCTION TBMoveCursor( o, nKey )

   LOCAL nFound
   STATIC aKeys := { K_DOWN      , {|obj| obj:down()},;
                     K_UP        , {|obj| obj:up()},;
                     K_PGDN      , {|obj| obj:pageDown()},;
                     K_PGUP      , {|obj| obj:pageUp()},;
                     K_CTRL_PGUP , {|obj| obj:goTop()},;
                     K_CTRL_PGDN , {|obj| obj:goBottom()},;
                     K_RIGHT     , {|obj| obj:right()},;
                     K_LEFT      , {|obj| obj:left()},;
                     K_HOME      , {|obj| obj:home()},;
                     K_END       , {|obj| obj:end()},;
                     K_CTRL_LEFT , {|obj| obj:panLeft()},;
                     K_CTRL_RIGHT, {|obj| obj:panRight()},;
                     K_CTRL_HOME , {|obj| obj:panHome()},;
                     K_CTRL_END  , {|obj| obj:panEnd()} }

   nFound := ASCAN( aKeys, nKey )

   IF nFound != 0
      EVAL( aKeys[++nFound], o )
   ENDIF

RETURN nFound != 0

STATIC FUNCTION ForceStable( obj )

   obj:refreshall()

   DISPBEGIN()
      DO WHILE !obj:stabilize()
      ENDDO
   DISPEND()

RETURN (NIL)

***************************
static function CRIA_TABELA( cRdd )
***************************

local aStruct := { }, n

* Aqui criamos a Tabela dentro do banco de dados, j� com as caracteristicas "NOT NULL", "UNIQUE", "PRIMARY KEY"

SQL ADD FIELD "SEQU" "N" (15, 0) NOT NULL        PRIMARY KEY 2        INTO aStruct
SQL ADD FIELD "FLD1" "N" (10, 0) NOT NULL        PRIMARY KEY 1        INTO aStruct
SQL ADD FIELD "FLD2" "N" (12, 0)          UNIQUE                      INTO aStruct
SQL ADD FIELD "FLD3" "N" (10, 0) NOT NULL        DEFAULT "-123"       INTO aStruct
SQL ADD FIELD "FLD4" "C" (30, 0) NOT NULL        DEFAULT "teste1"     INTO aStruct
SQL ADD FIELD "FLD5" "D" (08, 0) NOT NULL        DEFAULT "2009-07-10" INTO aStruct
SQL ADD FIELD "FLD6" "L" (01, 0) NOT NULL        DEFAULT "true"       INTO aStruct

**xmsgstop( SL_ToString( astruct,,,, "DUMP.TXT" ) )

if cRdd == "SQL"
   if SL_TABLE( "test" )
      if !SL_DELETETABLE( "test" )
         xmsgstop( "N�o consegui deletar a tabela <teste> !!!", "Aten��o" )
      endif
   endif

   dbcreate( "test", aStruct, "SQLLIB" )

   USE test ALIAS "TEST" via "SQLLIB" exclusive new

**xmsgstop( SL_ToString( TEST->( dbStruct()        ), , , , "dump.txt" ), "Usando DbStruct()" )
**xmsgstop( SL_ToString( SL_DBSTRUCT( "test"       ), , , , "dump.txt" ), "Usando SL_DbStruct()" )
**xmsgstop( SL_ToString( SL_DBSTRUCT( "test",, .T. ), , , , "dump.txt" ), "Usando SL_DbStruct() com retorno <EXTEND>" )
   
   TEST->( dbclosearea() )
else
   dbcreate( "test", aStruct, "DBFCDX" )
   USE test ALIAS "TEST" via "DBFCDX" exclusive new
   for n = 1 to 100
       TEST->( dbappend() )
       TEST->SEQU := n
       TEST->FLD1 := n
       TEST->FLD2 := n
       TEST->FLD3 := hb_random( 1, 1000 ) * .03
       TEST->FLD4 := "Registro numero " + alltrim(str(n,3))
       TEST->FLD5 := date() + n
       TEST->FLD6 := iif( n < 50, .T., .F. )
   next
   TEST->( dbclosearea() )
endif

return NIL

//--EOF--//
