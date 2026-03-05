# =====================================
# Frusky Tools - Cool Edition (IEX Safe)
# =====================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'

Clear-Host

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "        FRUSKY TOOLS LOADER          " -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------
# Admin check
# -------------------------------------
$identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Not running as admin, restarting..." -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/zuedyyy/Frusky-Tool/main/FruskyTools.ps1)`""
    exit
}

Write-Host "[+] Administrator privileges confirmed" -ForegroundColor Green
Write-Host ""

# -------------------------------------
# Folder setup
# -------------------------------------
Write-Host "[*] Preparing workspace..." -ForegroundColor Cyan

$root = "C:\"
$base = "SS"
$i = 1
while (Test-Path ($root + $base + $i)) { $i++ }
$folder = $root + $base + $i

New-Item -ItemType Directory -Path $folder | Out-Null
Set-Location $folder

Write-Host "[+] Workspace created:" -ForegroundColor Green -NoNewline
Write-Host " $folder" -ForegroundColor White
Write-Host ""

# -------------------------------------
# ZIP support
# -------------------------------------
Add-Type -AssemblyName System.IO.Compression.FileSystem

# -------------------------------------
# Download function
# -------------------------------------
function DownloadFile {
    param ([string]$Url)

    $file = Split-Path $Url -Leaf

    Write-Host "[*] Downloading:" -ForegroundColor Cyan -NoNewline
    Write-Host " $file" -ForegroundColor White

    try {
        Invoke-WebRequest -Uri $Url -OutFile $file -UseBasicParsing
        Write-Host "    [+] Downloaded successfully" -ForegroundColor Green

        if ($file.ToLower().EndsWith(".zip")) {
            $out = [IO.Path]::GetFileNameWithoutExtension($file)
            Expand-Archive $file $out -Force
            Remove-Item $file -Force
            Write-Host "    [+] Extracted archive" -ForegroundColor DarkCyan
        }
    }
    catch {
        Write-Host "    [X] Download failed" -ForegroundColor Red
    }

    Write-Host ""
}

# -------------------------------------
# URLs (FULL LIST - FIXED)
# -------------------------------------
$urls = @(
    "https://github.com/spokwn/BAM-parser/releases/download/v1.2.9/BAMParser.exe",
    "https://github.com/spokwn/Tool/releases/download/v1.1.3/espouken.exe",
    "https://github.com/spokwn/KernelLiveDumpTool/releases/download/v1.1/KernelLiveDumpTool.exe",
    "https://github.com/spokwn/PathsParser/releases/download/v1.2/PathsParser.exe",
    "https://github.com/spokwn/prefetch-parser/releases/download/v1.5.5/PrefetchParser.exe",
    "https://github.com/spokwn/JournalTrace/releases/download/1.2/JournalTrace.exe",

    "https://www.nirsoft.net/utils/winprefetchview-x64.zip",
    "https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe",
    "https://www.nirsoft.net/utils/usbdeview-x64.zip",
    "https://www.nirsoft.net/utils/networkusageview-x64.zip",

    "https://d1kpmuwb7gvu1i.cloudfront.net/AccessData_FTK_Imager_4.7.1.exe",
    "https://github.com/Yamato-Security/hayabusa/releases/download/v3.6.0/hayabusa-3.6.0-win-x64.zip",
    "https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip",
    "https://www.nirsoft.net/utils/usbdrivelog.zip",

    "https://www.voidtools.com/Everything-1.4.1.1029.x64-Setup.exe",
    "https://www.nirsoft.net/utils/previousfilesrecovery-x64.zip",

    "https://github.com/Col-E/Recaf/releases/download/2.21.14/recaf-2.21.14-J8-jar-with-dependencies.jar",
    "https://github.com/NotRequiem/InjGen/releases/download/v2.0/InjGen.exe",
    "https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/download/RL/RedLotusModAnalyzer.exe",
    "https://github.com/RedLotus-Development/White-Lotus-Scanner/releases/download/forensics/WhiteLotus.exe",

    "https://download.ericzimmermanstools.com/net9/MFTECmd.zip",
    "https://download.ericzimmermanstools.com/net9/MFTExplorer.zip",
    "https://github.com/zedoonvm1/TasksParser/releases/download/1.1/Tasks.Parser.exe",
    "https://download.ericzimmermanstools.com/net9/PECmd.zip",
    "https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip",

    "https://github.com/Orbdiff/Fileless/releases/download/v1.1/Fileless.exe",
    "https://github.com/txvch/Screenshare-Collector/releases/download/tech/Technical.Utilities.exe",
    "https://github.com/ItzIceHere/RedLotusAltChecker/releases/download/RL/RedLotusAltChecker.exe",
    "https://api.anticheat.ac/dl/cli"
)

# -------------------------------------
# Download loop
# -------------------------------------
$count = 0
$total = $urls.Count

foreach ($u in $urls) {
    $count++
    Write-Host "[$count/$total]" -ForegroundColor Yellow -NoNewline
    Write-Host " Processing next tool..." -ForegroundColor DarkGray
    DownloadFile $u
}

# -------------------------------------
# Done
# -------------------------------------
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "[+] All tools collected successfully" -ForegroundColor Green
Write-Host "[+] Opening workspace folder" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan

Start-Process explorer.exe $folder
