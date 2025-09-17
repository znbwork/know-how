# install-maven.ps1
# Automatically download and install the latest Maven on Windows

# 1. Set installation directory
$InstallDir = "C:\Maven"

# 2. Fetch the latest Maven version from Apache
Write-Host "Fetching latest Apache Maven version..."
$Version = Invoke-RestMethod -Uri "https://dlcdn.apache.org/maven/maven-3/" `
  | Select-String -Pattern 'href="([0-9]+\.[0-9]+\.[0-9]+)/"' -AllMatches `
  | ForEach-Object { $_.Matches.Groups[1].Value } `
  | Sort-Object {[version]$_} -Descending `
  | Select-Object -First 1

Write-Host "Latest version detected: $Version"

# 3. Build download URL
$MavenUrl = "https://dlcdn.apache.org/maven/maven-3/$Version/binaries/apache-maven-$Version-bin.zip"
$ZipFile = "$env:TEMP\apache-maven-$Version-bin.zip"

# 4. Download Maven
Write-Host "Downloading Maven $Version..."
Invoke-WebRequest -Uri $MavenUrl -OutFile $ZipFile

# 5. Extract to installation directory
Write-Host "Extracting to $InstallDir..."
if (!(Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir | Out-Null }
Expand-Archive -Path $ZipFile -DestinationPath $InstallDir -Force

$MavenHome = "$InstallDir\apache-maven-$Version"

# 6. Set environment variables
Write-Host "Configuring environment variables..."
[System.Environment]::SetEnvironmentVariable("MAVEN_HOME", $MavenHome, "Machine")

$Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($Path -notlike "*$MavenHome\bin*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$Path;$MavenHome\bin", "Machine")
}

Write-Host "Maven $Version installed successfully!"
Write-Host "Please open a new terminal and run: mvn -v"
