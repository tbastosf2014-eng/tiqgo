@echo off
REM ╔══════════════════════════════════════════════════════════════════╗
REM ║ TIQGO - Sistema de Predição de Futebol e Apostas de Valor      ║
REM ║ Script de Instalação Automatizada para Windows                 ║
REM ║                                                                  ║
REM ║ Este script:                                                    ║
REM ║ ✅ Verifica se Python está instalado                           ║
REM ║ ✅ Cria um ambiente virtual                                    ║
REM ║ ✅ Instala todas as dependências                              ║
REM ║ ✅ Configura o projeto para execução                          ║
REM ║                                                                  ║
REM ║ Uso: Duplo clique neste arquivo ou:                           ║
REM ║      install.bat                                               ║
REM ╚══════════════════════════════════════════════════════════════════╝

setlocal enabledelayedexpansion
chcp 65001 >nul
cls

REM ════════════════════════════════════════════════════════════════════
REM Variáveis de cores (aproximação para Windows CMD)
REM ════════════════════════════════════════════════════════════════════

REM Nota: Windows CMD tem limitações com cores. Usaremos símbolos ao invés.

REM ════════════════════════════════════════════════════════════════════
REM PASSO 0: Verificar se está rodando como Administrador (opcional)
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ TIQGO - Sistema de Predição de Futebol e Apostas de Valor      ║
echo ║ Script de Instalação Automatizada para Windows                 ║
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

REM ════════════════════════════════════════════════════════════════════
REM PASSO 1: Verificar se Python está instalado
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 1: Verificando Instalação do Python
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

python --version >nul 2>&1
if errorlevel 1 (
    py --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Python não encontrado no seu sistema!
        echo.
        echo Por favor, instale Python 3.8 ou superior:
        echo https://www.python.org/downloads/
        echo.
        echo Ao instalar, NÃO ESQUEÇA DE MARCAR:
        echo ✓ "Add Python to PATH"
        echo ✓ "Install pip"
        echo.
        echo Depois, execute este script novamente.
        echo.
        pause
        exit /b 1
    ) else (
        set "PYTHON_CMD=py"
    )
) else (
    set "PYTHON_CMD=python"
)

REM Obter versão do Python
for /f "tokens=*" %%i in ('%PYTHON_CMD% --version 2^>^&1') do set "PYTHON_VERSION=%%i"
echo ✅ Python encontrado: %PYTHON_VERSION%

REM Verificar se versão é 3.8+
for /f "tokens=2" %%i in ('%PYTHON_CMD% --version 2^>^&1') do set "PYTHON_VER=%%i"
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VER%") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
)

if %MAJOR% lss 3 (
    echo ❌ Python 3.8+ é requerido. Versão encontrada: %PYTHON_VER%
    pause
    exit /b 1
)

if %MAJOR% equ 3 if %MINOR% lss 8 (
    echo ❌ Python 3.8+ é requerido. Versão encontrada: %PYTHON_VER%
    pause
    exit /b 1
)

echo ✅ Versão Python compatível!

REM ════════════════════════════════════════════════════════════════════
REM PASSO 2: Verificar se pip está instalado
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 2: Verificando pip (Gestor de Pacotes Python)
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

%PYTHON_CMD% -m pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ pip não está instalado!
    echo.
    echo Para resolver, reinstale Python marcando a opção "pip"
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('%PYTHON_CMD% -m pip --version') do set "PIP_VERSION=%%i"
echo ✅ pip encontrado: %PIP_VERSION%

REM ════════════════════════════════════════════════════════════════════
REM PASSO 3: Criar ambiente virtual
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 3: Criando Ambiente Virtual Python
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

set "VENV_DIR=venv"

if exist "%VENV_DIR%" (
    echo ⚠️  Ambiente virtual já existe em '%VENV_DIR%'
    set /p RECREATE="Deseja recriá-lo? (s/n): "
    if /i "!RECREATE!"=="s" (
        echo ℹ️  Removendo ambiente virtual existente...
        rmdir /s /q "%VENV_DIR%"
    ) else (
        echo ℹ️  Mantendo ambiente virtual existente
        goto :SKIP_VENV_CREATE
    )
)

echo ℹ️  Criando novo ambiente virtual em '%VENV_DIR%'...
%PYTHON_CMD% -m venv "%VENV_DIR%"

if errorlevel 1 (
    echo ❌ Erro ao criar ambiente virtual
    pause
    exit /b 1
)

echo ✅ Ambiente virtual criado com sucesso!

:SKIP_VENV_CREATE

REM ════════════════════════════════════════════════════════════════════
REM PASSO 4: Ativar ambiente virtual
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 4: Ativando Ambiente Virtual
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

call "%VENV_DIR%\Scripts\activate.bat"

if errorlevel 1 (
    echo ❌ Erro ao ativar ambiente virtual
    pause
    exit /b 1
)

echo ✅ Ambiente virtual ativado!

REM ════════════════════════════════════════════════════════════════════
REM PASSO 5: Atualizar pip, setuptools e wheel
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 5: Atualizando pip, setuptools e wheel
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

echo ℹ️  Isto pode levar alguns minutos...
python -m pip install --upgrade pip setuptools wheel

if errorlevel 1 (
    echo ❌ Erro ao atualizar ferramentas Python
    pause
    exit /b 1
)

echo ✅ pip, setuptools e wheel atualizados!

REM ════════════════════════════════════════════════════════════════════
REM PASSO 6: Instalar dependências de requirements.txt
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 6: Instalando Dependências do requirements.txt
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

if not exist "requirements.txt" (
    echo ❌ Arquivo 'requirements.txt' não encontrado!
    echo.
    echo Certifique-se de executar este script na raiz do projeto
    echo (onde está o arquivo requirements.txt)
    echo.
    pause
    exit /b 1
)

echo ℹ️  Instalando pacotes Python...
python -m pip install -r requirements.txt

if errorlevel 1 (
    echo ❌ Erro ao instalar dependências
    echo.
    echo ⚠️  Dica: Tente novamente com:
    echo    pip install -r requirements.txt --upgrade
    echo.
    pause
    exit /b 1
)

echo ✅ Todas as dependências foram instaladas com sucesso!

REM ════════════════════════════════════════════════════════════════════
REM PASSO 7: Criar estrutura de diretórios
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 7: Criando Estrutura de Diretórios do Projeto
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

setlocal enabledelayedexpansion

set "DIRS[0]=src"
set "DIRS[1]=src\data_collection"
set "DIRS[2]=src\feature_engineering"
set "DIRS[3]=src\modeling"
set "DIRS[4]=src\betting_intelligence"
set "DIRS[5]=data"
set "DIRS[6]=data\raw"
set "DIRS[7]=data\processed"
set "DIRS[8]=models"
set "DIRS[9]=logs"
set "DIRS[10]=drivers"

for /l %%i in (0,1,10) do (
    if defined DIRS[%%i] (
        if not exist "!DIRS[%%i]!" (
            mkdir "!DIRS[%%i]!"
            echo ℹ️  Criado: !DIRS[%%i]!\
        )
    )
)

echo ✅ Estrutura de diretórios completa!

REM ════════════════════════════════════════════════════════════════════
REM PASSO 8: Criar arquivo de configuração padrão
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 8: Criando Arquivo de Configuração Padrão
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

set "CONFIG_FILE=config.py"

if not exist "%CONFIG_FILE%" (
    (
        echo # TIQGO - Sistema de Predição de Futebol e Apostas de Valor
        echo # Arquivo de Configuração Global
        echo.
        echo import os
        echo from pathlib import Path
        echo.
        echo PROJECT_ROOT = Path(__file__^).parent
        echo DATA_DIR = PROJECT_ROOT / "data"
        echo RAW_DATA_DIR = DATA_DIR / "raw"
        echo PROCESSED_DATA_DIR = DATA_DIR / "processed"
        echo MODELS_DIR = PROJECT_ROOT / "models"
        echo LOGS_DIR = PROJECT_ROOT / "logs"
        echo DRIVERS_DIR = PROJECT_ROOT / "drivers"
        echo.
        echo for dir_path in [DATA_DIR, RAW_DATA_DIR, PROCESSED_DATA_DIR, MODELS_DIR, LOGS_DIR, DRIVERS_DIR]:
        echo     dir_path.mkdir(parents=True, exist_ok=True^)
        echo.
        echo # Configurações de Scraping
        echo SELENIUM_TIMEOUT = 30
        echo HEADLESS_MODE = True
        echo SCRAPING_DELAY = 2
        echo.
        echo # Configurações de Features
        echo ROLLING_WINDOW = 5
        echo MOMENTUM_WEIGHT = 0.35
        echo.
        echo # Configurações de XGBoost
        echo XGBOOST_CONFIG = {
        echo     'max_depth': 6,
        echo     'learning_rate': 0.1,
        echo     'n_estimators': 100,
        echo }
        echo.
        echo # Configurações de Validação Cruzada
        echo CV_FOLDS = 5
        echo TEST_SIZE = 0.2
    ) > "%CONFIG_FILE%"
    
    echo ✅ Arquivo config.py criado!
) else (
    echo ℹ️  Arquivo config.py já existe, mantendo versão existente
)

REM ════════════════════════════════════════════════════════════════════
REM PASSO 9: Criar arquivo __init__.py para módulos
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 9: Criando Arquivos __init__.py para Módulos
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

set "INIT_FILES[0]=src\__init__.py"
set "INIT_FILES[1]=src\data_collection\__init__.py"
set "INIT_FILES[2]=src\feature_engineering\__init__.py"
set "INIT_FILES[3]=src\modeling\__init__.py"
set "INIT_FILES[4]=src\betting_intelligence\__init__.py"

for /l %%i in (0,1,4) do (
    if defined INIT_FILES[%%i] (
        if not exist "!INIT_FILES[%%i]!" (
            type nul > "!INIT_FILES[%%i]!"
            echo ℹ️  Criado: !INIT_FILES[%%i]!
        )
    )
)

echo ✅ Módulos Python configurados!

REM ════════════════════════════════════════════════════════════════════
REM PASSO 10: Verificar Selenium e ChromeDriver
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ PASSO 10: Verificando Selenium
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

python -c "import selenium; print(f'Selenium version: {selenium.__version__}')" 2>nul

if errorlevel 1 (
    echo ❌ Erro ao importar Selenium
    echo ⚠️  Tente: pip install selenium --upgrade
) else (
    echo ✅ Selenium importado com sucesso!
)

REM ════════════════════════════════════════════════════════════════════
REM PASSO 11: Avisar sobre ChromeDriver
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ ⚠️  CONFIGURAÇÃO DO CHROMEDRIVER
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

if not exist "drivers\chromedriver.exe" (
    echo ⚠️  ChromeDriver não encontrado em: drivers\chromedriver.exe
    echo.
    echo Para usar o módulo de scraping, você precisa:
    echo.
    echo 1. Descobrir sua versão do Chrome:
    echo    - Abra Chrome
    echo    - Clique em Menu (⋮) → Ajuda → Sobre o Google Chrome
    echo    - Anote a versão (ex: 126.0.6478.57^)
    echo.
    echo 2. Baixar ChromeDriver compatível:
    echo    https://googlechromelabs.github.io/chrome-for-testing/
    echo    (Procure pela versão EXATA que você anotou^)
    echo.
    echo 3. Extrair e colocar em:
    echo    drivers\chromedriver.exe
    echo.
) else (
    echo ✅ ChromeDriver encontrado!
)

REM ════════════════════════════════════════════════════════════════════
REM RESUMO FINAL
REM ════════════════════════════════════════════════════════════════════

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║ ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

echo Próximos passos:
echo.
echo 1️⃣  USAR O PROJETO:
echo    O ambiente virtual está ativado. Você pode usar agora!
echo.
echo 2️⃣  CONFIGURAR CHROMEDRIVER (se ainda não fez^):
echo    Seguir instruções acima
echo.
echo 3️⃣  EXECUTAR O SISTEMA:
echo    python main.py --mode=scrape
echo    python main.py --mode=features
echo    python main.py --mode=train
echo    python main.py --mode=predict
echo    python main.py --mode=betting_report
echo.
echo 4️⃣  VER AJUDA:
echo    python main.py --help
echo.
echo ════════════════════════════════════════════════════════════════════
echo Documentação completa em: README.md
echo ════════════════════════════════════════════════════════════════════
echo.
echo ✅ Bom trabalho! 🚀⚽🎯
echo.

pause
