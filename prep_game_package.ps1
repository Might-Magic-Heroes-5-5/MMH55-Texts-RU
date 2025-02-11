$sourceDirectory = "$PSScriptRoot\mod\"
$tempDirectory = "$PSScriptRoot\Temp\"
$zipFile = "$PSScriptRoot\MMH55-RU-TEXT.zip"

Write-Output "Processing directory..."

# Ensure Temp directory exists
if (-Not (Test-Path $tempDirectory)) {
    New-Item -ItemType Directory -Path $tempDirectory | Out-Null
}

# UTF-16 LE BOM encoding
$encoding = [System.Text.Encoding]::Unicode

# Copy and convert .txt files to Temp directory while maintaining structure
Get-ChildItem -Path $sourceDirectory -Filter "*.txt" -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($sourceDirectory.Length)
    $destinationPath = Join-Path $tempDirectory $relativePath

    # Ensure the destination directory exists
    $destinationDir = Split-Path -Path $destinationPath -Parent
    if (-Not (Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir | Out-Null
    }

    Write-Output "Converting: $destinationPath"
    $content = Get-Content -Raw -Path $_.FullName
    [System.IO.File]::WriteAllText($destinationPath, $content, $encoding)
}

Write-Output "Conversion complete!"

# Create the .pak archive
Compress-Archive -Path "$tempDirectory\*" -DestinationPath $zipFile -Force
Rename-Item -Path $zipFile -NewName "MMH55-RU-TEXT.pak" -Force

# Clean up Temp directory
Remove-Item -Path $tempDirectory -Recurse -Force

Write-Output "Packaging complete: $pakFile"