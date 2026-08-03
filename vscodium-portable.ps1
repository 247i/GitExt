# setup-ide.ps1
$FolderName = "vscodmium-portable"

# If VSCodium already exists, exit silently to prevent redownloading
if (Test-Path "$FolderName\VSCodium.exe") {
    exit
}

Write-Host "🔄 VSCodium portable not found. Pulling down latest binary asset..." -ForegroundColor Cyan

# Force security layout
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
$ReleasePageUrl = "https://github.com"

try {
    $Headers = @{"User-Agent" = "Mozilla/5.0"}
    $WebResponse = Invoke-WebRequest -Uri $ReleasePageUrl -Headers $Headers -UseBasicParsing
    $RawLinks = [regex]::Matches($WebResponse.Content, 'href="([^"]+)"') | ForEach-Object { $_.Groups.Value }
    $TargetRelativePath = $RawLinks | Where-Object { $_ -like "*download/*win32-x64*.zip" } | Select-Object -First 1

    if (-not $TargetRelativePath) {
        Write-Warning "Could not find a valid zip archive package link."
        exit
    }

    $DownloadUrl = "https://github.com" + $TargetRelativePath
    $ZipFile = $DownloadUrl.Split("/")[-1]

    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipFile -Headers $Headers
    Expand-Archive -Path $ZipFile -DestinationPath $FolderName -Force
    New-Item -ItemType Directory -Force -Path "$FolderName\data" | Out-Null
    Remove-Item -Path $ZipFile -Force

    Write-Host "✅ VSCodium successfully deployed in .\$FolderName!" -ForegroundColor Green
} catch {
    Write-Warning "Failed to automatically provision local IDE binary: $_"
}
