# Test passwords for keystore
$keystorePath = "C:\Users\clint\Documents\Github\rejoice\@boilermanc__rejoice.jks"
$passwords = @("Sproutify01$", "Sproutify01", "sproutify", "")

foreach ($password in $passwords) {
    Write-Host "Testing password: [$password]" -ForegroundColor Cyan
    $output = & keytool -list -keystore $keystorePath -storepass $password 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ SUCCESS! Password is: [$password]" -ForegroundColor Green
        exit 0
    }
}

Write-Host "None of the passwords worked" -ForegroundColor Red
