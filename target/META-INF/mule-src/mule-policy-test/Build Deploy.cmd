@echo off

REM ===================================================
REM Script Maven com pausa garantida no final
REM ===================================================

REM --------------------------------------------
REM Etapa 1: Definindo variaveis de ambiente
REM --------------------------------------------
echo [INFO] Definindo variaveis de ambiente...

REM Nexus EE
set MULE_REPO_EE_NEXUS_USERNAME=telefonica.brasil.sa.nexus
set MULE_REPO_EE_NEXUS_PASSWORD=5514U6DT4ykV8qF

REM Anypoint Exchange - Connected App
set ANYPOINT_USERNAME=~~~Client~~~
set ANYPOINT_CONNECTED_APP_CLIENT_ID=4def50ccd56d4846819ed41699efc265
set ANYPOINT_CONNECTED_APP_CLIENT_SECRET=0fba4C70B7594C1d8C0F47D9711362A0
set ANYPOINT_PASSWORD=%ANYPOINT_CONNECTED_APP_CLIENT_ID%~?~%ANYPOINT_CONNECTED_APP_CLIENT_SECRET%

echo [OK] Variaveis configuradas.

REM ----------------------------------------------------
REM Etapa 2: Executando mvn clean install e deploy juntos
REM ----------------------------------------------------
echo [INFO] Iniciando build e deploy com Maven...
echo [INFO] mvn clean install deploy -s .maven/settings.xml

echo.
echo ================= MAVEN OUTPUT =================
echo.
call mvn clean install deploy -s .maven/settings.xml
set BUILD_RESULT=%ERRORLEVEL%
echo.
echo ================================================
echo.

REM ----------------------------------------------------
REM Etapa Final: Verificando sucesso ou falha
REM ----------------------------------------------------
IF %BUILD_RESULT% NEQ 0 (
    echo [ERRO] Alguma etapa falhou. Verifique o log acima.
) ELSE (
    echo [SUCESSO] Build e deploy executados com sucesso!
)

echo.
echo Pressione qualquer tecla para encerrar...
pause
exit /b 0