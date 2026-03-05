# ============================================================
#  TOOLS COLLECTOR â€” EPIC EDITION
#  Made By Zuedy | Refined & Enhanced
# ============================================================

# -----------------------
# TLS + Strict Mode
# -----------------------
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# -----------------------
# Clear + Banner
# -----------------------
cls
$banner = @"
 â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ•—     â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—
 â•šâ•â•â–ˆâ–ˆâ•”â•â•â•â–ˆâ–ˆâ•”â•â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ•”â•â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ•‘     â–ˆâ–ˆâ•”â•â•â•â•â•
    â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘     â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—
    â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘     â•šâ•â•â•â•â–ˆâ–ˆâ•‘
    â–ˆâ–ˆâ•‘   â•šâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â•šâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•‘
    â•šâ•â•    â•šâ•â•â•â•â•â•  â•šâ•â•â•â•â•â• â•šâ•â•â•â•â•â•â•â•šâ•â•â•â•â•â•â•

        T O O L S   C O L L E C T O R
"@

Write-Host $banner -ForegroundColor Cyan
Write-Host "â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•" -ForegroundColor DarkCyan
Write-Host "  Made By Zuedy | EPIC Edition" -ForegroundColor Green
Write-Host "â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•`n" -ForegroundColor DarkCyan

# -----------------------
# Admin Check
# -----------------------
$principal = New-Object Security.Principal.WindowsPrincipal `
    [Security.Principal.WindowsIdentity]::GetCurrent()

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Restarting with admin privileges..." -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs -ArgumentList `
        "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# -----------------------
# Folder Setup (C:\SS1+)
# -----------------------
$root = "C:\"
$base = "SS"
$i = 1
do { $folder = "$root$base$i"; $i++ } while (Test-Path $folder)

New-Item -ItemType Directory -Path $folder | Out-Null
Set-Location $folder

Write-Host "[+] Workspace created â†’ $folder" -ForegroundColor Cyan

# -----------------------
# Defender Exclusion
# -----------------------
function Add-DefenderExclusion {
    Write-Host "[*] Configuring Windows Defender exclusion..." -ForegroundColor Cyan
    try {
        if (Get-Command Add-MpPreference -ErrorAction SilentlyContinue) {
            Add-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
            Write-Host "[âœ“] Defender exclusion active" -ForegroundColor Green
            return
        }
    } catch {}

    Write-Host "[!] Defender exclusion failed" -ForegroundColor Yellow
}
Add-DefenderExclusion

# -----------------------
# ZIP Support
# -----------------------
Add-Type -AssemblyName System.IO.Compression.FileSystem

# -----------------------
# Download Function (Turbo)
# -----------------------
function Download-File {
    param ([string]$Url)

    $file = Split-Path $Url -Leaf
    $dest = Join-Path $folder $file

    try {
        Invoke-WebRequest -Uri $Url -OutFile $dest -UseBasicParsing
        Write-Host "    âœ” $file" -ForegroundColor Green

        if ($file.EndsWith(".zip")) {
            $out = Join-Path $folder ([IO.Path]::GetFileNameWithoutExtension($file))
            Expand-Archive -Path $dest -DestinationPath $out -Force
            Remove-Item $dest -Force
            Write-Host "      â†³ Extracted â†’ $out" -ForegroundColor DarkCyan
        }
    }
    catch {
        Write-Host "    âœ– Failed â†’ $file" -ForegroundColor Red
    }
}

# -----------------------
# URLs
# -----------------------
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

# -----------------------
# Download Loop + Progress
# -----------------------
$total = $urls.Count
$index = 0

foreach ($url in $urls) {
    $index++
    Write-Progress -Activity "Collecting tools" `
        -Status "[$index/$total] $(Split-Path $url -Leaf)" `
        -PercentComplete (($index / $total) * 100)

    Write-Host "`n[$index/$total] $(Split-Path $url -Leaf)" -ForegroundColor Cyan
    Download-File $url
}

# -----------------------
# Done
# -----------------------
Write-Progress -Completed -Activity "Collecting tools"
Start-Process explorer.exe $folder

Write-Host "`n[âœ“] All tools collected successfully." -ForegroundColor Green
Write-Host "    Location â†’ $folder" -ForegroundColor DarkGreen
