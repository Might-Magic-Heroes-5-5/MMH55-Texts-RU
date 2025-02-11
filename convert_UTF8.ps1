$directory = "$PSScriptRoot\mod\"
Write-Output "Processing directory..."

# - UTF-8 is used by this repository so github can show diff during PRs
$encoding = [System.Text.Encoding]::UTF8

Get-ChildItem -Path $directory -Filter "*.txt" -Recurse | ForEach-Object {
	$inputFile = $_.FullName
	Write-Output "Converting: $inputFile"

	## Read the file and write it back in UTF-8
	$content = Get-Content -Raw -Path $inputFile
	[System.IO.File]::WriteAllText($inputFile, $content, $encoding)
}
Write-Output "Conversion complete!"