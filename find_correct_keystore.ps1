# Find keystore with the correct fingerprint for Google Play
# Expected SHA1: 20:CC:C9:20:37:48:D4:DC:5B:26:44:D5:D8:9D:70:41:94:F5:D4:CD

$ExpectedSHA1 = "20:CC:C9:20:37:48:D4:DC:5B:26:44:D5:D8:9D:70:41:94:F5:D4:CD"

Write-Host "Searching for keystore files with SHA1: $ExpectedSHA1" -ForegroundColor Cyan
Write-Host ""

# Search paths
$SearchPaths = @(
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    "C:\Users\clint\Documents\Github",
    "C:\Users\clint\Documents",
    "C:\Users\clint\Desktop"
)

$KeystoreFiles = @()
foreach ($Path in $SearchPaths) {
    if (Test-Path $Path) {
        Write-Host "Searching: $Path" -ForegroundColor Gray
        $Files = Get-ChildItem -Path $Path -Filter *.jks -Recurse -ErrorAction SilentlyContinue -Depth 5
        $Files += Get-ChildItem -Path $Path -Filter *.keystore -Recurse -ErrorAction SilentlyContinue -Depth 5
        $KeystoreFiles += $Files
    }
}

# Also check current project
$CurrentKeystore = "C:\Users\clint\Documents\Github\sproutify\android\app\upload-keystore.jks"
if (Test-Path $CurrentKeystore) {
    $KeystoreFiles += Get-Item $CurrentKeystore
}

# Remove duplicates
$KeystoreFiles = $KeystoreFiles | Sort-Object FullName -Unique

if ($KeystoreFiles.Count -eq 0) {
    Write-Host "No keystore files found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You may need to:" -ForegroundColor Cyan
    Write-Host "1. Check with team members who created previous builds"
    Write-Host "2. Check password managers or secure storage"
    Write-Host "3. Check CI/CD systems (Codemagic, GitHub Actions, etc.)"
    Write-Host "4. Check Google Play Console -> App Signing to see if App Signing by Google Play is enabled"
    exit 0
}

Write-Host "Found $($KeystoreFiles.Count) keystore file(s). Checking fingerprints..." -ForegroundColor Green
Write-Host ""

$FoundMatch = $false
foreach ($File in $KeystoreFiles) {
    Write-Host "Checking: $($File.FullName)" -ForegroundColor White
    
    # Try common passwords
    $Passwords = @("Sproutify01$", "Sproutify01", "sproutify", "")
    
    $FoundPassword = $null
    foreach ($Password in $Passwords) {
        try {
            if ($Password -eq "") {
                $Output = & keytool -list -v -keystore $File.FullName 2>&1
            } else {
                $Output = & keytool -list -v -keystore $File.FullName -storepass $Password 2>&1
            }
            
            if ($LASTEXITCODE -eq 0) {
                $FoundPassword = $Password
                break
            }
        } catch {
            continue
        }
    }
    
    if ($null -eq $FoundPassword) {
        Write-Host "  ⚠ Could not access (wrong password or corrupted)" -ForegroundColor Yellow
        Write-Host ""
        continue
    }
    
    # Extract SHA1
    $SHA1Line = $Output | Select-String -Pattern "SHA1:"
    if ($SHA1Line) {
        $ActualSHA1 = ($SHA1Line -split "SHA1: ")[1].Trim()
        Write-Host "  SHA1: $ActualSHA1" -ForegroundColor $(if ($ActualSHA1 -eq $ExpectedSHA1) { "Green" } else { "Gray" })
        
        if ($ActualSHA1 -eq $ExpectedSHA1) {
            Write-Host ""
            Write-Host "✓✓✓ MATCH FOUND! ✓✓✓" -ForegroundColor Green
            Write-Host "  File: $($File.FullName)" -ForegroundColor Green
            Write-Host "  Password: $(if ($FoundPassword -eq '') { 'None (prompted)' } else { $FoundPassword })" -ForegroundColor Green
            Write-Host ""
            Write-Host "Next steps:" -ForegroundColor Cyan
            Write-Host "1. Copy this keystore to: android\app\upload-keystore.jks" -ForegroundColor White
            Write-Host "2. Update android\key.properties with the correct password" -ForegroundColor White
            Write-Host "3. Run: cmd /c build.bat playstore" -ForegroundColor White
            $FoundMatch = $true
            break
        }
    }
    Write-Host ""
}

if (-not $FoundMatch) {
    Write-Host "✗ No keystore found matching the expected fingerprint." -ForegroundColor Red
    Write-Host ""
    Write-Host "Expected SHA1: $ExpectedSHA1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "1. Check Google Play Console -> App Signing" -ForegroundColor White
    Write-Host "   - If 'App signing by Google Play' is enabled, you may need to use a different upload key" -ForegroundColor White
    Write-Host "2. Check with team members or backups" -ForegroundColor White
    Write-Host "3. Contact Google Play Support to reset app signing" -ForegroundColor White
}


