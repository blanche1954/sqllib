/*
 * SQLLIB RDD Project source code
 * A Free & Open source RDD for Harbour & xHarbour Compilers
 *
 * Copyright 2008 Vailton Renato <vailtom@gmail.com> and
 *                Rossine Maia   <qiinfo@ig.com.br>
 * www - http://www.harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */

#include "sqllibrdd.ch"

/*
 * Rotina para importar DBF para o Banco de dados SQL
 * 22/01/2009 - 21:12 - Rossine
 */

************************
function SL_IMPORT_FILES( aFiles, cVia, pConn, cSChema, lPack, lDelete, bBlock, nEvery, bBlockApp )
************************

local lRet := .T.
local cFile
local aStruct
local cFileSQL
local cFileDBF
local cExteDBF
local nCtd := 0, aConn

DEFAULT cVia    := rddsetdefault()
DEFAULT lPack   := .F.
DEFAULT lDelete := .F.
DEFAULT nEvery  := 1
DEFAULT cSchema := "public"

if valtype( aFiles ) != "A"
   xmsgstop( "Arquivo(s) a ser(em) importado(s) n�o definido(s) !!!" + CRLF + CRLF + ;
            "� necess�rio que se passe uma <ARRAY> definida com o(s) nome(s) do(s) arquivo(s)" + CRLF + ;
            "a ser(em) importado(s) !!!", "Aten��o" )
   return .F.
endif

if len( aFiles ) = 0
   xmsgstop( "N�o h� arquivos a serem importados !!!", "Aten��o" )
   return .F.
endif

aConn := SL_GETCONNINFO( pConn )

if valtype( aConn ) != 'A' 
   return .F.
endif

cSchema := SQLAdjustFn( cSchema )

SL_SetConnection( aConn[SL_CONN_HANDLE] )
SL_SetSchema( cSchema )

asort( aFiles,,,{ |x,y| upper(x) < upper(y) } )

/*
 Aqui verificamos se os arquivos DBF a serem importados existem.
 30/03/2009 - 11:20 - Rossine
*/

for each cFile in aFiles
    cFileDBF := lower(alltrim( cFile ))
    if !file( cFileDBF )
       xmsgstop( "Arquivo n�o existe [" + cFile + "]. Tecle ENTER...", "Aten��o" )
       lRet := .F.
       exit
    endif
next

if !lRet
   return .F.
endif

*rddsetdefault( cVia )

for each cFile in aFiles

    cFileDBF := lower(alltrim( cFile ))
    cExteDBF := substr( cFileDBF, rat( ".", cFileDBF ) )

/*
    if !file( cFileDBF )
       xmsgstop( "Arquivo n�o existe [" + cFile + "]. Tecle ENTER...", "Aten��o" )
       lRet := .F.
       exit
    endif
*/
    cFileSQL := left( cFileDBF, at( ".", cFileDBF ) - 1 )

    if rat( "\", cFileSQL ) > 0
       cFileSQL := substr( cFileSQL, rat( "\", cFileSQL ) + 1 )
    endif

    if valtype( bBlock ) = "B"
       nCtd++

       if nCtd >= nEvery
          #IfnDef __XHARBOUR__
          BEGIN SEQUENCE WITH {|oErr| Break( oErr )}
             Eval( bBlock, cFileSql, cFileDbf )
          RECOVER

          End
          #else
          TRY
             Eval( bBlock, cFileSql, cFileDbf )
          catch e
             ? e:description
          End
          #endif
          nCtd := 0
       endif
    endif

    if SL_TABLE( cFileSQL )
       SL_DELETETABLE( cFileSQL )
    endif

**msgstop( "[" + cFileDBF + "-" + cVia + "]" )

    try
        use ( cFileDBF ) alias "EXPORT_DBF" via (cVia) NEW exclusive
    catch
        xmsgstop( "Erro de abertura no arquivo: [" + cFileDBF + "] !!!", "Erro" )
        loop
    end

    if lPack
       EXPORT_DBF->( __dbpack() )
    endif

    EXPORT_DBF->( dbgotop() )
    
    aStruct := EXPORT_DBF->( dbStruct() )

    EXPORT_DBF->( dbCloseArea() )

    dbCreate( cFileSQL, aStruct, "SQLLIB" )

    use ( cFileSQL ) alias "EXPORT_SQL" via "SQLLIB" NEW exclusive
**    use ( cFileDBF ) alias "EXPORT_DBF" via (cVia) NEW exclusive

   EXPORT_SQL->( __dbzap() )

    if valtype( bBlockApp ) = "B"
       append from (cFileDBF) via (cVia) for eval( bBlockApp, cFileSql, cFileDbf, "EXPORT_DBF" )
    else
       append from (cFileDBF) via (cVia)
**       copy to (cFileSQL) via "SQLLIB"
    endif

    EXPORT_SQL->( dbCloseArea() )

**    EXPORT_DBF->( dbCloseArea() )

    if lDelete
       aEval( Directory( strtran( cFileDBF, cExteDBF, "" ) + "*.*" ), {|a| Ferase( a[1] ) })
*       filedelete( strtran( cFileDBF, cExteDBF, "" ) + "*.*" )
    endif
next

**dbcloseall()

*rddsetdefault( "SQLLIB" )

return lRet

/*
 * Rotina para exportar SQL para DBF
 * 23/01/2009 - 09:12 - Rossine
 */

************************
function SL_EXPORT_FILES( aFiles, cVia, pConn, cSChema, lPack, lDelete, bBlock, nEvery, bBlockCopy )
************************

local cFile, aExports := { }, nCtd := 0, aConn

DEFAULT aFiles  := { }
DEFAULT cVia    := rddsetdefault()
DEFAULT lPack   := .F.
DEFAULT lDelete := .F.
DEFAULT nEvery  := 1
DEFAULT cSchema := "public"

aConn := SL_GETCONNINFO( pConn )

if valtype( aConn ) != 'A' 
   return .F.
endif

cSchema := SQLAdjustFn( cSchema )

SL_SetConnection( aConn[SL_CONN_HANDLE] )
SL_SetSchema( cSchema )

rddsetdefault( "SQLLIB" )

if len( aFiles ) = 0
   aFiles := SQLGetTables()
endif

asort( aFiles,,,{ |x,y| upper(x) < upper(y) } )

for each cFile in aFiles

    if valtype( bBlock ) = "B"
       nCtd++
       if nCtd >= nEvery
          #IfnDef __XHARBOUR__
          BEGIN SEQUENCE WITH {|oErr| Break( oErr )}
             Eval( bBlock, cFile )
          RECOVER

          End
          #else
          TRY
             Eval( bBlock, cFile )
          catch e
             ? e:description
          End
          #endif

          nCtd := 0
       endif
    endif

    if SL_file( cFile ) .and. cFile != SL_INDEX
       try
           use ( cFile ) alias "EXPORT_SQL" via "SQLLIB" NEW exclusive
       catch
           xmsgstop( "Erro de abertura no arquivo: [" + cFile + "] !!!", "Erro" )
           loop
       end
       if lPack
          EXPORT_SQL->( __dbpack() )
       endif

       if valtype( bBlockCopy ) = "B"
          copy to ( cFile ) via (cVia) for eval( bBlockCopy )
       else
          copy to ( cFile ) via (cVia)
       endif
       
       EXPORT_SQL->( dbCloseArea() )
       
       if lDelete
          @22, 01 say pad( "Excluindo a Tabela [" + cFile + "]. Aguarde...", 80 )
          SL_DELETETABLE( cFile )
       endif

       aadd( aExports, cFile )
    endif
next

dbcloseall()

rddsetdefault( cVia )

return aExports

//--EOF--//
