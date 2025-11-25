# PowerShell script to verify keystore fingerprint
# Usage: .\verify_keystore.ps1 <path-to-keystore.jks>

param(
    [Parameter(Mandatory=$true)]
    [string]$KeystorePath
)

Write-Host "Verifying keystore: $KeystorePath" -ForegroundColor Cyan
Write-Host ""

# Expected fingerprint from Google Play Console
$ExpectedSHA1 = "FB:60:2B:60:DF:9F:6F:51:F9:EC:19:F0:70:DE:A4:95:B8:98:4D:44"

Write-Host "Expected SHA1: $ExpectedSHA1" -ForegroundColor Yellow
Write-Host ""

# Prompt for keystore password
$SecurePassword = Read-Host "Enter keystore password" -AsSecureString
$Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))

# Get keystore info
$KeytoolOutput = & keytool -list -v -keystore $KeystorePath -storepass $Password 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error reading keystore. Check the password and file path." -ForegroundColor Red
    exit 1
}

# Extract SHA1 fingerprint
$SHA1Line = $KeytoolOutput | Select-String -Pattern "SHA1:"
if ($SHA1Line) {
    $ActualSHA1 = ($SHA1Line -split "SHA1: ")[1].Trim()
    Write-Host "Actual SHA1:   $ActualSHA1" -ForegroundColor $(if ($ActualSHA1 -eq $ExpectedSHA1) { "Green" } else { "Red" })
    Write-Host ""
    
    if ($ActualSHA1 -eq $ExpectedSHA1) {
        Write-Host "✓ MATCH! This keystore matches Google Play's expected fingerprint." -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Copy this keystore to: android\upload-keystore.jks"
        Write-Host "2. Create android\key.properties with your keystore details"
        Write-Host "3. Run: .\build.bat playstore"
    } else {
        Write-Host "✗ NO MATCH! This keystore does NOT match the expected fingerprint." -ForegroundColor Red
        Write-Host ""
        Write-Host "You need to find the keystore file that matches:" -ForegroundColor Yellow
        Write-Host "  $ExpectedSHA1"
    }
} else {
    Write-Host "Could not extract SHA1 fingerprint from keystore output." -ForegroundColor Red
}





