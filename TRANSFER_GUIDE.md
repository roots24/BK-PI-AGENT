# Guida al Trasferimento di Configurazione: Pi Coding Agent

Questa guida descrive la procedura completa per trasferire l'intera configurazione di **Pi Coding Agent** da un computer a un altro. Il processo include il backup e il ripristino di skill, tool, agenti, sessioni, impostazioni e variabili d'ambiente.

## 📋 Panoramica
Per garantire che l'agente funzioni esattamente come sul PC di origine, non è sufficiente copiare i file; è necessario trasferire sia i dati persistenti (file) sia i parametri di runtime (variabili d'ambiente).

I due set di script forniti automatizzano questo processo per Windows e macOS/Linux.

---

## 🚀 Procedura Passo-Passo

### 1. Fase di Backup (PC di Origine)

#### 🪟 Su Windows
1. Apri un terminale **PowerShell**.
2. Esegui lo script: `.\backup_pi.ps1`

#### 🍎 Su macOS / Linux
1. Apri il **Terminale**.
2. Rendi lo script eseguibile: `chmod +x backup_pi_mac.sh`
3. Esegui lo script: `./backup_pi_mac.sh`

**Cosa succede in questa fase:**
Lo script creerà una cartella chiamata `pi_coding_agent_backup` all'interno della cartella `BK-PI`, contenente tutte le skill, i tool, i log delle sessioni e un file `pi_env_vars.txt` con le variabili d'ambiente.

### 2. Trasferimento Dati
Sposta l'intera cartella `BK-PI` sul nuovo computer usando un supporto esterno (USB, Cloud, Rete).

### 3. Fase di Ripristino (PC di Destinazione)

#### 🪟 Su Windows
1. **Installazione Pulita:** Installa **Pi Coding Agent**.
2. Apri **PowerShell** nella cartella `BK-PI`.
3. Esegui lo script: `.\restore_pi.ps1`
4. **Configurazione Ambiente:** Imposta le variabili elencate in `pi_env_vars.txt` tramite:
   `[Environment]::SetEnvironmentVariable('NOME', 'VALORE', 'User')`

#### 🍎 Su macOS / Linux
1. **Installazione Pulita:** Installa **Pi Coding Agent**.
2. Apri il **Terminale** nella cartella `BK-PI`.
3. Rendi lo script eseguibile: `chmod +x restore_pi_mac.sh`
4. Esegui lo script: `./restore_pi_mac.sh`
5. **Configurazione Ambiente:** Copia le righe `export ...` fornite dallo script e incollale nel tuo file di configurazione della shell (solitamente `~/.zshrc` su Mac o `~/.bashrc` su Linux).
6. Applica le modifiche: `source ~/.zshrc`

---

## 📂 Dettaglio dei Dati Trasferiti

| Componente | Percorso Sorgente | Descrizione |
| :--- | :--- | :--- |
| **Skill** | `.agents\skills` / `.agents/skills` | Tutte le skill personalizzate e i prompt di sistema. |
| **Estensioni/Tool** | `.pi\agent\extensions` / `.pi/agent/extensions` | Tool aggiuntivi e plugin installati per l'agente. |
| **Missioni** | `.pi\agent\missions` / `.pi/agent/missions` | Definizione degli obiettivi e degli agenti specializzati. |
| **Sessioni** | `.pi\agent\sessions` / `.pi/agent/sessions` | Lo storico completo di tutte le conversazioni e i contesti. |
| **Modelli** | `.pi\agent\models.json` / `.pi/agent/models.json` | Configurazione dei modelli utilizzati e loro mappatura. |
| **Impostazioni** | `.pi\agent\settings.json` / `.pi/agent/settings.json` | Preferenze utente, API key e configurazioni globali. |
| **Ambiente** | Variabili `PI_*` | Parametri di runtime come `PI_PROVIDER` e `PI_REASONING_LEVEL`. |

---

## ⚠️ Note Importanti

- **Sicurezza:** I file di configurazione potrebbero contenere API Key. Assicurati che il trasferimento avvenga in modo sicuro.
- **Versioni:** Si raccomanda di usare la stessa versione di Pi Coding Agent su entrambi i sistemi.
- **Node Modules:** Gli script **non** copiano le cartelle `node_modules` per evitare conflitti di architettura. L'installazione pulita sul nuovo PC è obbligatoria.
