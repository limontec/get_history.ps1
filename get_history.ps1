$UserName = $env:USERNAME  
$Browsers = @{
    'Chrome' = "$Env:systemdrive\Users\$UserName\AppData\Local\Google\Chrome\User Data\Default\History"
    'Brave'  = "$Env:systemdrive\Users\$UserName\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\History"
    'Edge'   = "$Env:systemdrive\Users\$UserName\AppData\Local\Microsoft\Edge\User Data\Default\History"
}

$Regex = '(htt(p|s))://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?' 

Write-Host "Username | Browser | url"

foreach ($Browser in $Browsers.Keys) {
    $Path = $Browsers[$Browser]
    
    if (-not (Test-Path -Path $Path)) {
        Write-Verbose "[!] Could not find $Browser History for username: $UserName"
        continue
    }

    try {
        $Value = Get-Content -Path $Path -ErrorAction Stop | Select-String -AllMatches $Regex | ForEach-Object { ($_.Matches).Value } | Sort -Unique
    } catch {
        Write-Warning "[!] Failed to read history from $Browser $_"
        continue
    }

	foreach ($url in $Value) {
		Write-Host $UserName $Browser $url
	}
}