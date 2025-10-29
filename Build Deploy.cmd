@echo off

REM ===================================================
REM Script Maven com pausa garantida no final
REM ===================================================

REM --------------------------------------------
REM Etapa 1: Definindo variáveis de ambiente
REM --------------------------------------------
echo [INFO] Definindo variáveis de ambiente...

REM ===================================================
REM 🧩 SEÇÃO 1 — NEXUS ENTERPRISE
REM ---------------------------------------------------
REM 🔹 Substitua pelos seus dados de repositório Nexus EE
REM ===================================================
set MULE_REPO_EE_NEXUS_USERNAME=SEU_USUARIO_NEXUS
set MULE_REPO_EE_NEXUS_PASSWORD=SUA_SENHA_NEXUS

REM ===================================================
REM 🧩 SEÇÃO 2 — ANYPOINT EXCHANGE CONNECTED APP
REM ---------------------------------------------------
REM 🔹 Username é o identificador padrão (~Client~)
REM 🔹 Password é composto: CLIENT_ID~?~CLIENT_SECRET
REM ===================================================
set ANYPOINT_USERNAME=~~~Client~~~
set ANYPOINT_CONNECTED_APP_CLIENT_ID=INSIRA_SEU_CLIENT_ID_AQUI
set ANYPOINT_CONNECTED_APP_CLIENT_SECRET=INSIRA_SEU_CLIENT_SECRET_AQUI
set ANYPOINT_PASSWORD=%ANYPOINT_CONNECTED_APP_CLIENT_ID%~?~%ANYPOINT_CONNECTED_APP_CLIENT_SECRET%

echo [OK] Variáveis configuradas.

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