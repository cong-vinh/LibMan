param(
    [switch]$NoBrowser,
    [string]$DbPassword = $env:LIBMAN_DB_PASSWORD
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot

function Find-ExistingPath([string[]]$candidates) {
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    return $null
}

function Fail([string]$message) {
    Write-Host "ERROR: $message" -ForegroundColor Red
    exit 1
}

function Invoke-MySqlFile([string]$mysqlPath, [string]$sqlPath) {
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $mysqlPath
    $info.Arguments = '--protocol=TCP -h 127.0.0.1 -u root'
    $info.UseShellExecute = $false
    $info.RedirectStandardInput = $true
    $info.RedirectStandardOutput = $false
    $info.RedirectStandardError = $false
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    [void]$process.Start()
    $bytes = [IO.File]::ReadAllBytes($sqlPath)
    $process.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
    $process.StandardInput.Close()
    $process.WaitForExit()
    return $process.ExitCode
}

$javaCompiler = Get-Command javac -ErrorAction SilentlyContinue
if (-not $javaCompiler) { Fail 'javac was not found in PATH. Configure an installed JDK and retry.' }
$javaHomeCandidate = Get-ChildItem 'C:\Program Files\Java\jdk-*','C:\Program Files\Eclipse Adoptium\jdk-*' -Directory -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
$javaHome = Find-ExistingPath @($env:JAVA_HOME, $javaHomeCandidate)
if (-not $javaHome) { Fail 'JAVA_HOME was not found. Set JAVA_HOME to the installed JDK directory.' }
$env:JAVA_HOME = $javaHome
$env:JRE_HOME = $javaHome

$tomcatHome = Find-ExistingPath @(
    $env:CATALINA_HOME,
    'C:\apache-tomcat-8.5.99',
    'C:\apache-tomcat-9.0.0'
)
if (-not $tomcatHome) { Fail 'Tomcat was not found. Set CATALINA_HOME or install Tomcat.' }
$startup = Join-Path $tomcatHome 'bin\startup.bat'
if (-not (Test-Path -LiteralPath $startup)) { Fail "Invalid Tomcat installation: $tomcatHome" }

$connector = Get-ChildItem (Join-Path $projectRoot 'WebContent\WEB-INF\lib') -Filter 'mysql-connector*.jar' -File -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $connector) {
    $connector = Get-ChildItem (Join-Path $env:USERPROFILE '.m2\repository\com\mysql') -Recurse -Filter 'mysql-connector-j-*.jar' -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notlike '*sources*' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($connector) {
        $libDir = Join-Path $projectRoot 'WebContent\WEB-INF\lib'
        New-Item -ItemType Directory -Force -Path $libDir | Out-Null
        Copy-Item -LiteralPath $connector.FullName -Destination (Join-Path $libDir $connector.Name) -Force
        $connector = Get-Item (Join-Path $libDir $connector.Name)
        Write-Host "Added JDBC driver: $($connector.Name)"
    }
}
if (-not $connector) { Fail 'MySQL Connector/J was not found. Put mysql-connector-j-*.jar in WebContent\WEB-INF\lib.' }

$mysqlExe = Find-ExistingPath @(
    (Join-Path ${env:ProgramFiles} 'MySQL\MySQL Server 8.0\bin\mysql.exe'),
    (Join-Path ${env:ProgramFiles} 'MySQL\MySQL Server 9.6\bin\mysql.exe')
)
if (-not $mysqlExe) { Fail 'mysql.exe was not found. Install MySQL Server or add its bin directory to PATH.' }

if ([string]::IsNullOrWhiteSpace($DbPassword)) {
    $securePassword = Read-Host 'Enter the MySQL root password' -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    try { $DbPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}
$env:LIBMAN_DB_URL = 'jdbc:mysql://localhost:3306/libman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Bangkok'
$env:LIBMAN_DB_USER = 'root'
$env:LIBMAN_DB_PASSWORD = $DbPassword
$env:MYSQL_PWD = $DbPassword

$mysqlErrorAction = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
try {
    $pingOutput = @(& $mysqlExe --protocol=TCP -h 127.0.0.1 -u root -e 'SELECT 1' 2>&1)
    if ($LASTEXITCODE -ne 0) { Fail 'MySQL is not running or the root password is incorrect. Start MySQL and retry.' }

    $databaseExists = ((& $mysqlExe --protocol=TCP -h 127.0.0.1 -u root -N -B -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='libman'" 2>&1) | Out-String).Trim()
    if ($databaseExists -ne 'libman') {
        Write-Host 'Database libman is missing; importing database/libman.sql ...'
        $baseSql = Join-Path $projectRoot 'database\libman.sql'
        if ((Invoke-MySqlFile $mysqlExe $baseSql) -ne 0) { Fail 'Import of database/libman.sql failed.' }
    }
    $repairSql = Join-Path $projectRoot 'database\libman_repair_and_more.sql'
    if ((Invoke-MySqlFile $mysqlExe $repairSql) -ne 0) { Fail 'Vietnamese data repair/demo import failed.' }
    $tableCount = ((& $mysqlExe --protocol=TCP -h 127.0.0.1 -u root -N -B -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='libman'" 2>&1) | Out-String).Trim()
    Write-Host "MySQL OK: libman has $tableCount tables."
}
finally {
    $ErrorActionPreference = $mysqlErrorAction
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}

$classes = Join-Path $projectRoot 'build\classes'
New-Item -ItemType Directory -Force -Path $classes | Out-Null
$javaFiles = @(Get-ChildItem (Join-Path $projectRoot 'src') -Recurse -Filter '*.java' -File | ForEach-Object { $_.FullName })
if ($javaFiles.Count -eq 0) { Fail 'No Java files were found under src.' }
& $javaCompiler.Source -encoding UTF-8 -source 8 -target 8 -cp $connector.FullName -d $classes $javaFiles
if ($LASTEXITCODE -ne 0) { Fail 'Java compilation failed.' }

$webapps = Join-Path $tomcatHome 'webapps'
$deploy = Join-Path $webapps 'LibMan'
if (Test-Path -LiteralPath $deploy) { Remove-Item -LiteralPath $deploy -Recurse -Force }
New-Item -ItemType Directory -Force -Path $deploy | Out-Null
Copy-Item -Path (Join-Path $projectRoot 'WebContent\*') -Destination $deploy -Recurse -Force
$classDeploy = Join-Path $deploy 'WEB-INF\classes'
if (Test-Path -LiteralPath $classDeploy) { Remove-Item -LiteralPath $classDeploy -Recurse -Force }
New-Item -ItemType Directory -Force -Path $classDeploy | Out-Null
Get-ChildItem -LiteralPath $classes -Directory | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $classDeploy -Recurse -Force
}

$env:CATALINA_HOME = $tomcatHome
$env:CATALINA_OPTS = '-Dfile.encoding=UTF-8'
$portInUse = Test-NetConnection 127.0.0.1 -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue
if (-not $portInUse) {
    Start-Process -FilePath $startup -WorkingDirectory (Join-Path $tomcatHome 'bin') -WindowStyle Hidden | Out-Null
}

$url = 'http://localhost:8080/LibMan/bd/ReaderMainUI8.jsp?readerId=1'
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 1
    try { Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2 | Out-Null; $ready = $true; break } catch { }
}
if (-not $ready) { Fail "Tomcat did not respond at $url. Check logs under $tomcatHome\logs." }
Write-Host "LibMan is running: $url"
if (-not $NoBrowser) { Start-Process $url }
