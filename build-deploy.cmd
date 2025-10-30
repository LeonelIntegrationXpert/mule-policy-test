@echo off

REM ===================================================
REM Script Maven para build e deploy de uma Mule Policy
REM Seguro, didático e pronto para rodar em ambientes corporativos
REM ===================================================

REM --------------------------------------------
REM Etapa 1: Definindo variáveis de ambiente
REM --------------------------------------------
echo [INFO] Definindo variáveis de ambiente...

REM ===================================================
REM 🧩 SEÇÃO 1 — NEXUS ENTERPRISE
REM ---------------------------------------------------
REM 🔹 Substitua pelos seus dados de acesso ao Nexus EE
REM 🔐 Dica: defina como variáveis de ambiente seguras no sistema
REM ===================================================
set MULE_REPO_EE_NEXUS_USERNAME=SEU_USUARIO_NEXUS
set MULE_REPO_EE_NEXUS_PASSWORD=SUA_SENHA_NEXUS

REM ===================================================
REM 🧩 SEÇÃO 2 — ANYPOINT EXCHANGE CONNECTED APP
REM ---------------------------------------------------
REM 🔹 Configure uma Connected App no Anypoint Platform
REM 🔹 Os dados abaixo devem ser protegidos (NÃO COMITAR!)
REM 🔐 Dica: use variáveis de ambiente ou arquivos externos
REM ===================================================
set ANYPOINT_USERNAME=~~~Client~~~
set ANYPOINT_CONNECTED_APP_CLIENT_ID=SEU_CLIENT_ID
set ANYPOINT_CONNECTED_APP_CLIENT_SECRET=SEU_CLIENT_SECRET
set ANYPOINT_PASSWORD=%ANYPOINT_CONNECTED_APP_CLIENT_ID%~?~%ANYPOINT_CONNECTED_APP_CLIENT_SECRET%

REM ===================================================
REM 🧩 SEÇÃO 3 — ORG ID DA ORGANIZAÇÃO
REM ---------------------------------------------------
REM 🔹 Usado para publicar no Exchange correto (via -DorgId=...)
REM 🔹 Deve ser o UUID da sua organização no Anypoint Platform
REM ===================================================
set ORG_ID=INSIRA_SEU_ORG_ID_AQUI

echo [OK] Variáveis configuradas com sucesso.
echo [INFO] ORG_ID definido como: %ORG_ID%

REM ----------------------------------------------------
REM Etapa 2: Executando mvn clean deploy
REM ----------------------------------------------------
echo [INFO] Iniciando build e deploy com Maven...
echo [INFO] Comando: mvn clean deploy -s .maven/settings.xml -DorgId=%ORG_ID%

echo.
echo ================ MAVEN OUTPUT ================
echo.
call mvn clean deploy -s .maven/settings.xml -DorgId=%ORG_ID%
set BUILD_RESULT=%ERRORLEVEL%
echo.
echo ==============================================
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
