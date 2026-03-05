# ============================================================
#  TOOLS COLLECTOR — EPIC EDITION (FIXED)
# ============================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "Stop"

cls

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "      TOOLS COLLECTOR - EPIC EDITION  " -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------
# Admin Check (FIXED)
# -----------------------
$identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Restarting as administrator..." -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs -ArgumentList `
        "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# -----------------------
# Folder Setup
# -----------------------
$root = "C:\"
$base = "SS"
$i = 1
while (Test-Path "$root$base$i") { $i++ }
$folder = "$root$base$i"

New-Item -ItemType Directory -Path $folder | Out-Null
Set-Location $folder

Write-Host "[+] Created folder: $folder" -ForegroundColor Cyan

# -----------------------
# Defender Exclusion (SAFE)
# -----------------------
function Add-DefenderExclusion {
    Write-Host "[*] Adding Defender exclusion..." -ForegroundColor Cyan
    try {
        if (Get-Command Add-MpPreference -ErrorAction SilentlyContinue) {
            Add-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
            Write-Host "[OK] Defender exclusion added" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[!] Defender exclusion failed" -ForegroundColor Yellow
    }
}

Add-DefenderExclusion

# -----------------------
# ZIP Support
# -----------------------
Add-Type -AssemblyName System.IO.Compression.FileSystem

# -----------------------
# Download Function
# -----------------------
function Download-File {
    param ([string]$Url)

    $file = Split-Path $Url -Leaf
    $dest = Join-Path $folder $file

    try {
        Invoke-WebRequest -Uri $Url -OutFile $dest -UseBasicParsing
        Write-Host "    [+] $file" -ForegroundColor Green

        if ($file.ToLower().EndsWith(".zip")) {
            $out = Join-Path $folder ([IO.Path]::GetFileNameWithoutExtension($file))
            Expand-Archive -Path $dest -DestinationPath $out -Force
            Remove-Item $dest -Force
            Write-Host "        Extracted to $out" -ForegroundColor DarkCyan
        }
    }
    catch {
        Write-Host "    [X] Failed: $file" -ForegroundColor Red
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
    'https://github.com/spokwn/prefetch-parser/releases/download/v1.5.5/PrefetchParser.exe'
)

# -----------------------
# Download Loop
# -----------------------
$count = 0
$total = $urls.Count

foreach ($url in $urls) {
    $count++
    Write-Host "`n[$count/$total] $(Split-Path $url -Leaf)" -ForegroundColor Cyan
    Download-File $url
}

# -----------------------
# Done
# -----------------------
Start-Process explorer.exe $folder
Write-Host "`n[✓] Finished successfully" -ForegroundColor Green
