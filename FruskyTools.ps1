# ===============================
# Frusky Tools - IEX SAFE VERSION
# ===============================

# TLS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'

# -------------------------------
# Admin check
# -------------------------------
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -Verb RunAs -ArgumentList `
        '-NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/zuedyyy/Frusky-Tool/refs/heads/main/FruskyTools.ps1)"'
    exit
}

Write-Host "[+] Running as administrator"

# -------------------------------
# Folder setup (C:\SS1, SS2, ...)
# -------------------------------
$root = 'C:\'
$base = 'SS'
$i = 1

while (Test-Path ($root + $base + $i)) {
    $i++
}

$folder = $root + $base + $i
New-Item -ItemType Directory -Path $folder | Out-Null
Set-Location $folder

Write-Host "[+] Folder created: $folder"

# -------------------------------
# Defender exclusion
# -------------------------------
try {
    if (Get-Command Add-MpPreference -ErrorAction SilentlyContinue) {
        Add-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
        Write-Host "[+] Defender exclusion added"
    }
} catch {
    Write-Host "[!] Defender exclusion failed"
}

# -------------------------------
# ZIP support
# -------------------------------
Add-Type -AssemblyName System.IO.Compression.FileSystem

# -------------------------------
# Download function
# -------------------------------
function DownloadFile {
    param ([string]$Url)

    $file = Split-Path $Url -Leaf
    $dest = Join-Path $folder $file

    try {
        Invoke-WebRequest -Uri $Url -OutFile $dest -UseBasicParsing
        Write-Host "[+] Downloaded $file"

        if ($file.ToLower().EndsWith('.zip')) {
            $out = Join-Path $folder ([IO.Path]::GetFileNameWithoutExtension($file))
            New-Item -ItemType Directory -Path $out -Force | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory($dest, $out, $true)
            Remove-Item $dest -Force
            Write-Host "[+] Extracted $file"
        }
    } catch {
        Write-Host "[X] Failed $file"
    }
}

# -------------------------------
# URLs
# -------------------------------
$urls = @(
    'https://github.com/spokwn/BAM-parser/releases/download/v1.2.9/BAMParser.exe',
    'https://github.com/spokwn/Tool/releases/download/v1.1.3/espouken.exe',
    'https://github.com/spokwn/KernelLiveDumpTool/releases/download/v1.1/KernelLiveDumpTool.exe',
    'https://github.com/spokwn/PathsParser/releases/download/v1.2/PathsParser.exe',
    'https://github.com/spokwn/prefetch-parser/releases/download/v1.5.5/PrefetchParser.exe',
    'https://github.com/spokwn/JournalTrace/releases/download/1.2/JournalTrace.exe',
    'https://www.nirsoft.net/utils/winprefetchview-x64.zip',
    'https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe',
    'https://www.nirsoft.net/utils/usbdeview-x64.zip',
    'https://www.nirsoft.net/utils/networkusageview-x64.zip',
    'https://d1kpmuwb7gvu1i.cloudfront.net/AccessData_FTK_Imager_4.7.1.exe',
    'https://github.com/Yamato-Security/hayabusa/releases/download/v3.6.0/hayabusa-3.6.0-win-x64.zip',
    'https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip',
    'https://www.nirsoft.net/utils/usbdrivelog.zip',
    'https://www.voidtools.com/Everything-1.4.1.1029.x64-Setup.exe',
    'https://www.nirsoft.net/utils/previousfilesrecovery-x64.zip',
    'https://github.com/Col-E/Recaf/releases/download/2.21.14/recaf-2.21.14-J8-jar-with-dependencies.jar',
    'https://github.com/NotRequiem/InjGen/releases/download/v2.0/InjGen.exe',
    'https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/download/RL/RedLotusModAnalyzer.exe',
    'https://github.com/RedLotus-Development/White-Lotus-Scanner/releases/download/forensics/WhiteLotus.exe',
    'https://download.ericzimmermanstools.com/net9/MFTECmd.zip',
    'https://download.ericzimmermanstools.com/net9/MFTExplorer.zip',
    'https://github.com/zedoonvm1/TasksParser/releases/download/1.1/Tasks.Parser.exe',
    'https://download.ericzimmermanstools.com/net9/PECmd.zip',
    'https://download.ericzimmermanstools.com/net9/JumpListExplorer.zip',
    'https://github.com/Orbdiff/Fileless/releases/download/v1.1/Fileless.exe',
    'https://github.com/txvch/Screenshare-Collector/releases/download/tech/Technical.Utilities.exe',
    'https://github.com/ItzIceHere/RedLotusAltChecker/releases/download/RL/RedLotusAltChecker.exe',
    'https://api.anticheat.ac/dl/cli'
)

# -------------------------------
# Download loop
# -------------------------------
$count = 0
$total = $urls.Count

foreach ($u in $urls) {
    $count++
    Write-Host "[$count/$total] $u"
    DownloadFile $u
}

# -------------------------------
# Done
# -------------------------------
Start-Process explorer.exe $folder
Write-Host "[+] Finished"
