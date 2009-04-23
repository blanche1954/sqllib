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

//#define SQL_DEBUG

#ifndef _SQLLIB_CONSTS_CH
   #define _SQLLIB_CONSTS_CH

   #define SL_RDD_NAME             "SQLLIB"
   #define SL_COL_RECNO            "sl_rowid"
   #define SR_COL_RECNO            "sr_recno"
   #define SL_COL_DELETED          "sl_deleted"
   #define SL_COL_BACKUP           "sl_backup"
   #define SL_COL_RECNO_SEQ        "sl_seq"
   #define SL_COL_CUSTOM           "sl_index_custom"
   #define SL_COL_CUSTOM_LEN       16
   #define SL_NULLDATE             "0001-01-01"
   #define SL_NULLDATE2            "0000-00-00"
                                   
   #define SL_LOG_FILENAME         "sqllog.txt"
   #define SL_INDEX                "sqllib$indexes"
   #define ID_PREFIX               "IDX_"
   
   /* Important RDD data */
   #define WA_SYSTEMID             1    // Current SYSTEM ID number  (ID_MYSQL, ID_POSTGRESQL)
   #define WA_ENGINE               2    // System ID for this alias as string for quick access, eg ( "MYSQL", "PGSQL", etc...)
   #define WA_CONNECTION           3    // Current Connection object
   #define WA_POINTER              3    // Single Alias for RDDs what works with pointers
   #define WA_RESULT               4    // Last fetched result-set
   #define WA_RESULT_DIRECTION     5    // Last direction for result-set
                                 
   #define WA_TABLETYPE            6    // TS_SINGLE_SQL / TS_COMPLEX_SQL
   #define WA_PACKET_SIZE          7    // Number os records to fetch 
   #define WA_TRANSCOUNTER         8    // Transaction counter
   #define WA_TEMP                 9    // Temporary item to use with DBCreate() and others
                                 
   #define WA_FLD_RECNO           10    // sl_rowid   position into WA_REAL_STRUCT
   #define WA_FLD_DELETED         11    // sl_deleted position into WA_REAL_STRUCT

   /* Quick access only */
   #define WA_SCHEMA              12    // For quick access only to prefer other data access: WA_CONNECTION
   #define WA_DATABASE            13    // For quick access only to prefer other data access: WA_CONNECTION
   #define WA_TABLENAME           14    // For quick access only to prefer other data access: WA_CONNECTION

   /* Another operations and misc values */
   #define WA_BUFFER_INFO_BASE    WA_TABLENAME          +  1    /* Anterior + 1 */
   #define WA_BUFFER_ARR          WA_BUFFER_INFO_BASE   +  0    // Array for buffer
   #define WA_BUFFER_POS          WA_BUFFER_INFO_BASE   +  1    // Buffer with current row number
   #define WA_BUFFER_ROWCOUNT     WA_BUFFER_INFO_BASE   +  2    // Number of lines in buffer to avoid LEN(WA_BUFFER_ARR)
   #define WA_INVALIDBUFFER       WA_BUFFER_INFO_BASE   +  3    // Indicates if current buffer is invalid
   
   #define WA_WORKAREA_INFO_BASE  WA_INVALIDBUFFER      +  1    /* Anterior + 1 */
   #define WA_RECORDSET           WA_WORKAREA_INFO_BASE +  0    // 
   #define WA_BOF                 WA_WORKAREA_INFO_BASE +  1    // 
   #define WA_EOF                 WA_WORKAREA_INFO_BASE +  2    // 
   #define WA_LOCATEFOR           WA_WORKAREA_INFO_BASE +  4    // 
   #define WA_SCOPEINFO           WA_WORKAREA_INFO_BASE +  5    // 
   #define WA_FCOUNT              WA_WORKAREA_INFO_BASE +  7    // 
   #define WA_RECNO               WA_WORKAREA_INFO_BASE +  8    // 
   #define WA_RECCOUNT            WA_WORKAREA_INFO_BASE +  9    // 
   #define WA_APPEND              WA_WORKAREA_INFO_BASE + 10    // dbAppend() flag
   #define WA_RECORDCHANGED       WA_WORKAREA_INFO_BASE + 11    // pArea->fRecordChanged flag
   #define WA_FOUND               WA_WORKAREA_INFO_BASE + 12    // Rossine 07/10/08
   #define WA_LOCK                WA_WORKAREA_INFO_BASE + 13    // Rossine 18/10/08
   #define WA_RECSIZE             WA_WORKAREA_INFO_BASE + 14    // Rossine 22/10/08
   #define WA_STRUCT              WA_WORKAREA_INFO_BASE + 15    // emulate dbf struct with hidden fields - 22/12/2008 - 13:40:59 Vailton Renato
   #define WA_REAL_STRUCT         WA_WORKAREA_INFO_BASE + 16    // Real table struct - 22/12/2008 - 13:41:12 Vailton Renato  
   #define WA_SL_GOTOID           WA_WORKAREA_INFO_BASE + 17
   #define WA_SL_GOTOP            WA_WORKAREA_INFO_BASE + 18
   #define WA_SL_GOBOTTOM         WA_WORKAREA_INFO_BASE + 19

   #define WA_INDEX               WA_WORKAREA_INFO_BASE + 20    // Current INDEX info
   #define WA_INDEX_CURR          WA_WORKAREA_INFO_BASE + 21    // Current SET ORDER number

   #define WA_LAST_PACKSIZE       WA_WORKAREA_INFO_BASE + 22
   
   #define WA_ALIAS               WA_WORKAREA_INFO_BASE + 23

   #define WA_SIZE                WA_ALIAS    /* Put here the last key value for this array */

   /*
    * SL_GETCONNINFO() constants
    */                       
   #define SL_CONN_HANDLE        1
   #define SL_CONN_RDD           2
   #define SL_CONN_HOST          3
   #define SL_CONN_PORT          4
   #define SL_CONN_DB            5
   #define SL_CONN_USER          6
   #define SL_CONN_PASSWORD      7
   #define SL_CONN_FLAGS         8
   #define SL_CONN_SYSTEMID      9   
   #define SL_CONN_POINTER      10
   #define SL_CONN_SCHEMA       11 
   #define SL_CONN_CHARSET      12
   #define SL_CONN_COUNT        12
      
   /*
    * SQLGetDBInfo constants
    */
   #define DBI_GETVERSION         0
   #define DBI_GETALLTABLES       1
   #define DBI_GETALLDBS          2
   #define DBI_GETALLINDEXES      3
   #define DBI_GETALLUSERS        4
   #define DBI_GETALLCONNUSERS    5
   #define DBI_GETSYSTEMID        6
   #define DBI_GETSYSTEMIDSTR     7
   
   // list the drivers currently supported or to be implemented.
   #define ID_NONE                0
   #define ID_UNKNOW              0
   #define ID_MYSQL               1       
   #define ID_POSTGRESQL          2       /* Works OK! */
   #define ID_FIREBIRD            3
   #define ID_ACCESS              4
   #define ID_ORACLE              5                 
   #define ID_MAX_DRIVERS         2
   
   /* DBCreate additional constants */
   #define DBS_REQUIRED           5
   #define DBS_DEFAULT            6
   #define DBS_FLD_TYPE           7
   
   /* Buffer direction */
#ifndef MS_NONE
   #define MS_NONE                0
#endif
#ifndef MS_DOWN                
   #define MS_DOWN                1
#endif   
#ifndef MS_UP                  
   #define MS_UP                  2
#endif   
   
   /* Table Stype */
   #define TS_COMPLEX_SQL         2
   #define TS_SINGLE_SQL          1
   
   /* Custom indexes constants loaded from sqllib$indexes */
   #define IDX_TABLE              1
   #define IDX_BAG                2
   #define IDX_TAG                3
   #define IDX_FIELDS             4
   #define IDX_KEYS               5
   #define IDX_KEYSIZES           6
   #define IDX_FIELDPOS           7
   #define IDX_DESCEND            8
   #define IDX_FOR                9
   #define IDX_UNIQUE            10    
   #define IDX_ROWID             11 
   #define IDX_MAX_CONSTS        IDX_ROWID
              
   /* HB_EXEC Constants */
   #define DSL_CREATE            1
   #define DSL_CREATEFIELDS      2            
   #define DSL_OPEN              3    
   #define DSL_GOTOID            4      
   #define DSL_GOTOP             5     
   #define DSL_GOBOTTOM          6        
   #define DSL_DELETED           7       
   #define DSL_DELETE            8      
   #define DSL_RECCOUNT          9        
   #define DSL_GETVALUE         10        
   #define DSL_PUTVALUE         11         
   #define DSL_INFO             12    
   #define DSL_LOCK             13    
   #define DSL_PACK             14    
   #define DSL_ZAP              15   
   #define DSL_ORDCREATE        16         
   #define DSL_ORDDESTROY       17
   #define DSL_ORDLSTADD        18
   #define DSL_SEEK             19    
   #define DSL_WRITERECORD      20           
   #define DSL_ORDINFO          21       
   #define DSL_EXECQUERY        22            
   #define DSL_EXECQUERY_MSG    23                
   #define DSL_EXECQUERY_DES    24                
   #define DSL_QUICKQUERY       25             
   #define DSL_COMMIT           26         
   #define DSL_ROLLBACK         27           
   #define DSL_CLEARINDEX       28             
   #define DSL_STARTTRANS       29             
   #define DSL_ENDTRANS         30
   #define DSL_GETFIELDTYPE     31   && Rossine 23/12/08
   #define DSL_GETFULLTABLE     32
   #define DSL_DELETETABLE      33
                                 
   #define ID_MAX_FUNCTIONS     33  
                                 
   #define FSL_CREATE( id )            ( aSystemDrivers[ id, DSL_CREATE           ] )
   #define FSL_CREATEFLDS( id )        ( aSystemDrivers[ id, DSL_CREATEFIELDS     ] )
   #define FSL_OPEN( id )              ( aSystemDrivers[ id, DSL_OPEN             ] )
   #define FSL_GOTOID( id )            ( aSystemDrivers[ id, DSL_GOTOID           ] )
   #define FSL_GOTOP( id )             ( aSystemDrivers[ id, DSL_GOTOP            ] )
   #define FSL_GOBOTTOM( id )          ( aSystemDrivers[ id, DSL_GOBOTTOM         ] )
   #define FSL_DELETED( id )           ( aSystemDrivers[ id, DSL_DELETED          ] )
   #define FSL_DELETE( id )            ( aSystemDrivers[ id, DSL_DELETE           ] )
   #define FSL_RECCOUNT( id )          ( aSystemDrivers[ id, DSL_RECCOUNT         ] )
   #define FSL_GETVALUE( id )          ( aSystemDrivers[ id, DSL_GETVALUE         ] )
   #define FSL_PUTVALUE( id )          ( aSystemDrivers[ id, DSL_PUTVALUE         ] )
   #define FSL_INFO( id )              ( aSystemDrivers[ id, DSL_INFO             ] )
   #define FSL_LOCK( id )              ( aSystemDrivers[ id, DSL_LOCK             ] )
   #define FSL_PACK( id )              ( aSystemDrivers[ id, DSL_PACK             ] )
   #define FSL_ZAP( id )               ( aSystemDrivers[ id, DSL_ZAP              ] )
   #define FSL_ORDCREATE( id )         ( aSystemDrivers[ id, DSL_ORDCREATE        ] )
   #define FSL_ORDDESTROY( id )        ( aSystemDrivers[ id, DSL_ORDDESTROY       ] )
   #define FSL_ORDLSTADD( id )         ( aSystemDrivers[ id, DSL_ORDLSTADD        ] )
   #define FSL_SEEK( id )              ( aSystemDrivers[ id, DSL_SEEK             ] )
   #define FSL_WRITERECORD( id )       ( aSystemDrivers[ id, DSL_WRITERECORD      ] )
   #define FSL_ORDINFO( id )           ( aSystemDrivers[ id, DSL_ORDINFO          ] )
   #define FSL_EXECQUERY( id )         ( aSystemDrivers[ id, DSL_EXECQUERY        ] )
   #define FSL_EXECQUERY_MSG( id )     ( aSystemDrivers[ id, DSL_EXECQUERY_MSG    ] )
   #define FSL_EXECQUERY_DES( id )     ( aSystemDrivers[ id, DSL_EXECQUERY_DES    ] )
   #define FSL_QUICKQUERY( id )        ( aSystemDrivers[ id, DSL_QUICKQUERY       ] )
   #define FSL_COMMIT( id )            ( aSystemDrivers[ id, DSL_COMMIT           ] )
   #define FSL_ROLLBACK( id )          ( aSystemDrivers[ id, DSL_ROLLBACK         ] )
   #define FSL_CLEARINDEX( id )        ( aSystemDrivers[ id, DSL_CLEARINDEX       ] )
   #define FSL_STARTTRANS( id )        ( aSystemDrivers[ id, DSL_STARTTRANS       ] )
   #define FSL_ENDTRANS( id )          ( aSystemDrivers[ id, DSL_ENDTRANS         ] )
   #define FSL_GETFIELDTYPE( id )      ( aSystemDrivers[ id, DSL_GETFIELDTYPE     ] )   && Rossine 23/12/08
   #define FSL_GETFULLTABLE( id )      ( aSystemDrivers[ id, DSL_GETFULLTABLE     ] )   && Rossine 03/01/09
   #define FSL_DELETETABLE( id )       ( aSystemDrivers[ id, DSL_DELETETABLE      ] )   && Rossine 23/01/09
#endif