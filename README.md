# Script de Provisionamento Automatizado de Estações de Trabalho Windows

## 📌 Visão Geral do Projeto
Este projeto de automação de TI consiste em um script em PowerShell projetado para otimizar o processo de integração (onboarding) de novos funcionários. Em vez de baixar e instalar manualmente os softwares em notebooks corporativos novos, o técnico de suporte de TI pode executar este script para implantar todos os aplicativos padrão da empresa de forma silenciosa em poucos minutos.

## 🛠️ Tecnologias e Conceitos Utilizados
* **Linguagem:** PowerShell v5.1+
* **Gerenciador de Pacotes:** Windows Package Manager (Winget)
* **Conceitos de Suporte de TI:** Automação de elevação de Controle de Conta de Usuário (UAC), instalações silenciosas, tratamento de erros e script idempotente (verifica se o software já existe antes de iniciar a instalação).

## 🚀 Funcionalidades
* **Execução Obrigatória como Administrador:** Verifica automaticamente se o script possui privilégios elevados e solicita a elevação do UAC caso necessário.
* **Instalação Sem Interrupções (Zero-Touch):** Utiliza parâmetros específicos (`--silent`, `--accept-source-agreements`) para garantir que o técnico não precise clicar em "Avançar" ou aceitar termos manualmente.
* **Eficiência:** Instala Chrome, Firefox, Slack, Teams, Zoom, Git e VS Code em uma única execução.
* **Menu Interativo Dinâmico:** Menu via terminal (`Read-Host` e `Switch`) permitindo que o técnico escolha o perfil do funcionário.
* **Perfis Pré-definidos:** Separação lógica entre perfis de software para usuários administrativos comuns, desenvolvedores e engenheiros de TI.
* **Modo Customizado Flexível:** Permite a entrada de dados em string do usuário, processa o texto separando por delimitadores (`.Split(",")`), remove espaços vazios (`.Trim()`) e monta uma array dinâmica para instalação.
* **Instalação Silenciosa:** Mantém a automação "Zero-Touch" utilizando parâmetros que aceitam contratos de licença de forma automática.


## 📋 Como Usar
1. Baixe o arquivo `install_apps.ps1` na máquina de destino.
2. Abra o PowerShell como Administrador.
3. Se a execução de scripts estiver bloqueada na máquina, libere-a executando:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```
4. Execute o script:
   ```powershell
   .\install_apps.ps1
   ```

## 📄 Licença
Este projeto é de código aberto e está disponível sob a Licença MIT.
