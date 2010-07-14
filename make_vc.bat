@echo off
if "%1" == "clean" goto CLEAN
if "%1" == "CLEAN" goto CLEAN

:INICIO
if "%HB_INC_PGSQL%" == ""  goto ERRO_2
if not exist libpq.dll     goto ERRO_1

if "%HRB_DIR%" == "" if not "%HB_INSTALL_PREFIX%" == ""   SET HRB_DIR=%HB_INSTALL_PREFIX%
if "%HRB_DIR%" == "" if not "%HB_PATH%"  == ""            SET HRB_DIR=%HB_PATH%

if not exist lib md lib
if     exist %HRB_DIR%\bin\hbmk2.exe         goto BUILD_HB
if     exist %HRB_DIR%\lib\win\bcc\hbvm.lib  goto BUILD_HB
goto BUILD_XHB

:BUILD_HB
   cd source
   hbmk2 -trace -info -i%HB_INC_PGSQL% -i..\include -n -w -es2 -hblib -tshead=sql_tshead.ch -osqllib *.prg *.c > make_b32.log

   if errorlevel 1 goto BUILD_ERR
   goto BUILD_OK
   
:BUILD_XHB
   cd source
   hbmake sqllib.vc
   if errorlevel 1 goto BUILD_ERR
   goto BUILD_OK
   
:BUILD_OK
   if not exist sqllib.lib goto BUILD_ERR
   copy sqllib.lib .\..\lib\sqllib.lib
   del sqllib.lib
   cd..
   if not exist libpq.def goto BUILD_DEF
   goto CLEAN

:BUILD_DEF
   .\utils\impdef.exe libpq.def libpq.dll
   lib /def:libpq.def
   copy libpq.lib lib\libpq.lib
   goto CLEAN

:BUILD_ERR
   notepad make_b32.log
   cd..
   goto EXIT

:ERRO_1
   @echo.
   @echo.
   @echo Atencao, copie a seguinte DLL para dentro dessa pasta: LIBPQ.DLL
   @echo Essa DLL pode ser encontrada dentro da pasta de instalacao do POSTGRESQL
   @echo EX: C:\Arquivos de Programas\PostgreSql\LIB
   @echo.
   Pause
   goto EXIT

:ERRO_2
   @echo.
   @echo.
   @echo Atencao, voce deve definir o caminho correto da variavel de ambiente:
   @echo SET HB_INC_PGSQL , abaixo um exemplo:
   @echo SET HB_INC_PGSQL = C:\Arquivos de Programas\PostgreSql\include
   @echo.
   Pause
   goto EXIT

:CLEAN
   del /s .\source\win\*.c
   del /s .\source\win\*.obj
   del /s source\*.ppo
   del /s source\*.log
   if exist *.map del /s *.map
   if exist *.tds del /s *.tds
   if exist *.log del /s *.log
   if exist *.exe del /s *.exe
   if exist *.ppo del /s *.ppo
   goto EXIT
   
:EXIT
