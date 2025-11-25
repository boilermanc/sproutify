# Find all keystore files and check their fingerprints
Write-Host "Searching for keystore files..." -ForegroundColor Cyan
Write-Host ""

# Expected fingerprint from Google Play Console
$ExpectedSHA1 = "FB:60:2B:60:DF:9F:6F:51:F9:EC:19:F0:70:DE:A4:95:B8:98:4D:44"

# Search common locations
$SearchPaths = @(
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    "C:\Users\clint\Documents\Github"
)

$KeystoreFiles = @()
foreach ($Path in $SearchPaths) {
    if (Test-Path $Path) {
        $Files = Get-ChildItem -Path $Path -Filter *.jks -Recurse -ErrorAction SilentlyContinue -Depth 5
        $Files += Get-ChildItem -Path $Path -Filter *.keystore -Recurse -ErrorAction SilentlyContinue -Depth 5
        $KeystoreFiles += $Files
    }
}

if ($KeystoreFiles.Count -eq 0) {
    Write-Host "No keystore files found in common locations." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You may need to:" -ForegroundColor Cyan
    Write-Host "1. Check with team members who created previous builds"
    Write-Host "2. Check password managers or secure storage"
    Write-Host "3. Check CI/CD systems (Codemagic, GitHub Actions, etc.)"
    Write-Host "4. Contact Google Play Support to reset app signing"
    exit 0
}

Write-Host "Found $($KeystoreFiles.Count) keystore file(s):" -ForegroundColor Green
Write-Host ""
foreach ($File in $KeystoreFiles) {
    Write-Host "  - $($File.FullName)" -ForegroundColor White
}
Write-Host ""

Write-Host "To verify a keystore's fingerprint, run:" -ForegroundColor Cyan
Write-Host "  keytool -list -v -keystore `"<path-to-keystore>`"" -ForegroundColor Yellow
Write-Host ""
Write-Host "Then compare the SHA1 fingerprint to:" -ForegroundColor Cyan
Write-Host "  Expected: $ExpectedSHA1" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or use the verify script:" -ForegroundColor Cyan
Write-Host "  .\verify_keystore.ps1 `"<path-to-keystore>`"" -ForegroundColor Yellow





