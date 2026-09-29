param(
    [string]$OutputDirectory = './artifacts',
    [string[]]$ExcludeTag = @()
)

Set-StrictMode -Version Latest

function Copy-SemanticReleaseArtifactIfPresent {
    param(
        [Parameter(Mandatory)][string]$SourcePath,
        [Parameter(Mandatory)][string]$DestinationPath
    )

    if (Test-Path -LiteralPath $SourcePath) {
        Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
    }
}

function ConvertTo-SemanticReleaseSingleQuotedPowerShellLiteral {
    param(
        [Parameter(Mandatory)][string]$Value
    )

    return "'$($Value.Replace("'", "''") )'"
}

function Get-SemanticReleaseValidationCommand {
    param(
        [Parameter(Mandatory)][string]$BuiltModulePath,
        [Parameter(Mandatory)][string]$CommandName,
        [string[]]$ExcludeTag = @()
    )

    $commandLine = $CommandName
    if (@($ExcludeTag).Count -gt 0) {
        $excludeTagLiteral = @($ExcludeTag | ForEach-Object { ConvertTo-SemanticReleaseSingleQuotedPowerShellLiteral -Value ([string]$_) }) -join ', '
        $commandLine += " -ExcludeTagFilter @($excludeTagLiteral)"
    }

    return "Import-Module $( ConvertTo-SemanticReleaseSingleQuotedPowerShellLiteral -Value $BuiltModulePath ) -Force -ErrorAction Stop; $commandLine"
}

function Invoke-SemanticReleaseFreshValidationCommand {
    param(
        [Parameter(Mandatory)][string]$Command
    )

    & pwsh -NoLogo -NoProfile -Command $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Validation command failed: $Command"
    }
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..' '..' '..')).Path
Set-Location $repoRoot
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

Import-Module NovaModuleTools -ErrorAction Stop

$projectInfo = Get-NovaProjectInfo
Invoke-NovaBuild
$builtModulePath = Join-Path $projectInfo.OutputModuleDir "$( $projectInfo.ProjectName ).psd1"

$semanticReleaseTestFailed = $false
try {
    $unitTestCommand = Get-SemanticReleaseValidationCommand -BuiltModulePath $builtModulePath -CommandName 'Invoke-NovaTest' -ExcludeTag $ExcludeTag
    Invoke-SemanticReleaseFreshValidationCommand -Command $unitTestCommand

    $buildValidationCommand = Get-SemanticReleaseValidationCommand -BuiltModulePath $builtModulePath -CommandName 'Test-NovaBuild' -ExcludeTag $ExcludeTag
    Invoke-SemanticReleaseFreshValidationCommand -Command $buildValidationCommand
} catch {
    $semanticReleaseTestFailed = $true
    Write-Warning "SemanticRelease CI test workflow failed: $( $_.Exception.Message )"
} finally {
    Copy-SemanticReleaseArtifactIfPresent -SourcePath (Join-Path $projectInfo.ProjectRoot 'artifacts/UnitTestResults.xml') -DestinationPath (Join-Path $OutputDirectory 'semanticrelease-unit-nunit.xml')
    Copy-SemanticReleaseArtifactIfPresent -SourcePath (Join-Path $projectInfo.ProjectRoot 'artifacts/TestResults.xml') -DestinationPath (Join-Path $OutputDirectory 'semanticrelease-integration-nunit.xml')
}

if ($semanticReleaseTestFailed) {
    exit 1
}
