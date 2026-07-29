$ErrorActionPreference = 'Stop'

Write-Host "Creating C:\src directory..."
New-Item -ItemType Directory -Force -Path "C:\src" | Out-Null

$zipPath = "C:\src\flutter.zip"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.44.8-stable.zip"

Write-Host "Downloading Flutter SDK (This may take a few minutes)..."
Invoke-WebRequest -Uri $flutterUrl -OutFile $zipPath

Write-Host "Extracting Flutter SDK to C:\src..."
Expand-Archive -Path $zipPath -DestinationPath "C:\src" -Force

Write-Host "Cleaning up zip file..."
Remove-Item -Path $zipPath -Force

Write-Host "Adding Flutter to User PATH environment variable..."
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$flutterBin = "C:\src\flutter\bin"

if ($userPath -notlike "*$flutterBin*") {
    $newPath = $userPath + ";$flutterBin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Flutter added to User PATH."
} else {
    Write-Host "Flutter is already in User PATH."
}

Write-Host "Installing Dart MCP Server globally..."
# Jalankan dart dengan path absolut karena PATH di proses saat ini belum terupdate
$dartExe = "C:\src\flutter\bin\dart.bat"
if (Test-Path $dartExe) {
    & $dartExe pub global activate dart_mcp
} else {
    $dartExe = "C:\src\flutter\bin\dart.exe"
    & $dartExe pub global activate dart_mcp
}

Write-Host ""
Write-Host "=========================================================="
Write-Host "Instalasi Selesai!"
Write-Host "PENTING: Silakan RESTART terminal/IDE Anda"
Write-Host "agar perubahan PATH dapat diterapkan."
Write-Host "Setelah restart, Anda bisa menjalankan 'flutter doctor'."
Write-Host "=========================================================="
