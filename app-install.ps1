<#
.SYNOPSIS
    Ferramenta Interativa de Provisionamento de Estações de Trabalho.
.DESCRIPTION
    Script interativo em PowerShell que permite ao técnico escolher perfis 
    de software (Padrão, Desenvolvedor, Avançado ou Personalizado) via menu.
#>

# 1. Garante que o script está rodando como Administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script precisa de privilégios de Administrador. Reiniciando..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# 2. Definição dos Perfis de Aplicativos (Winget IDs)
$PerfilPadrao = @("Google.Chrome", "Mozilla.Firefox", "TheDocumentFoundation.LibreOffice," "Microsoft.Teams", "Google.GoogleDrive", "RARLab.WinRAR", "Microsoft.RemoteDesktopClient")
$PerfilDev    = $PerfilPadrao + @("Git.Git", "Microsoft.VisualStudioCode", "Docker.DockerDesktop", "GitHub.GitHubDesktop")
$PerfilAvancao = $PerfilDev + @("Wireshark.Wireshark", "PuTTY.PuTTY", "Oracle.VirtualBox")

# 3. Função Principal de Instalação
function Executar-Instalacao {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$ListaApps
    )
    
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "   INICIANDO INSTALAÇÃO DOS APLICATIVOS SELECIONADOS " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    
    foreach ($App in $ListaApps) {
        Write-Host "`n[Processando] ID do Aplicativo: $App" -ForegroundColor Yellow
        
        # Verifica se o app já está instalado
        $CheckApp = winget list --id $App 2>$null
        
        if ($CheckApp) {
            Write-Host "[Pulado] $App já está instalado no sistema." -ForegroundColor Green
        } else {
            Write-Host "[Instalando] Baixando e instalando $App silenciosamente..." -ForegroundColor Cyan
            # --- MODO DE TESTE (COMENTE A LINHA ABAIXO PARA ATIVAR A INSTALAÇÃO REAL) ---
            Start-Sleep -Seconds 1 # Apenas simula o tempo de carregamento
            $LASTEXITCODE = 0      # Simula que a instalação deu certo
            
            # --- MODO REAL (DESCOMENTE A LINHA ABAIXO QUANDO QUISER INSTALAR DE VERDADE) ---
            #winget install --id $App --silent --accept-source-agreements --accept-package-agreements
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[Sucesso] $App instalado com sucesso." -ForegroundColor Green
            } else {
                Write-Warning "[Erro] Falha ao instalar $App. Código de saída: $LASTEXITCODE"
            }
        }
    }
}

# 4. Menu Interativo via Terminal
Clear-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         SCRIPT APP-INSTALL: MENU PRINCIPAL       " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Selecione o perfil de instalação para esta máquina:" -ForegroundColor White
Write-Host "1) Usuário Padrão (Chrome, Firefox, Office, Teams, Drive, WinRAR)"
Write-Host "2) Desenvolvedor  (Perfil Padrão + Git/GitHub, VS Code, Docker)"
Write-Host "3) Avançado/TI    (Perfil Dev + Wireshark, PuTTY, VirtualBox)"
Write-Host "4) Personalizado  (Digitar IDs do Winget manualmente)"
Write-Host "Q) Sair"
Write-Host "==================================================" -ForegroundColor Cyan

$Escolha = Read-Host "Digite a opção desejada (1-4 ou Q)"

switch ($Escolha) {
    "1" { Executar-Instalacao -ListaApps $PerfilPadrao }
    "2" { Executar-Instalacao -ListaApps $PerfilDev }
    "3" { Executar-Instalacao -ListaApps $PerfilAvancao }
    "4" {
        Clear-Host
        Write-Host "=== INSTALAÇÃO PERSONALIZADA ===" -ForegroundColor Cyan
        Write-Host "Digite os IDs do Winget separados por vírgula." -ForegroundColor Yellow
        Write-Host "Exemplo: VideoLAN.VLC, 7zip.7zip, Notepad++.Notepad++" -ForegroundColor Gray
        
        $InputUsuario = Read-Host "`nDigite os IDs aqui"
        
        if (-not [string]::IsNullOrWhiteSpace($InputUsuario)) {
            # Divide a string digitada por vírgulas e limpa os espaços em branco
            $AppsCustomizados = $InputUsuario.Split(",").Trim()
            Executar-Instalacao -ListaApps $AppsCustomizados
        } else {
            Write-Warning "Nenhum aplicativo foi digitado. Encerrando."
        }
    }
    "Q" { Write-Host "Operação cancelada pelo técnico." -ForegroundColor Yellow; Exit }
    Default { Write-Warning "Opção inválida. Encerrando o script." }
}

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "   PROVISIONAMENTO CONCLUÍDO COM SUCESSO!         " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
