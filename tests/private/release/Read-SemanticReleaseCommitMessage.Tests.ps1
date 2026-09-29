BeforeAll {
    $projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    . (Join-Path $projectRoot 'src/private/release/Read-SemanticReleaseCommitMessage.ps1')
    . (Join-Path $projectRoot 'src/private/shared/Invoke-SemanticReleaseGitCommand.ps1')
}

Describe 'Read-SemanticReleaseCommitMessage' {
    It 'returns an empty array when no git repository is available' {
        function Get-SemanticReleaseCommitRangeBasis {
            param($ProjectRoot)

            return [pscustomobject]@{
                ProjectRoot = $ProjectRoot
                IsRepository = $false
                HasVersionTag = $false
                LastTag = $null
                RevisionRange = $null
            }
        }

        $messages = Read-SemanticReleaseCommitMessage -ProjectRoot '/repo'

        @($messages).Count | Should -Be 0
    }

    It 'uses the detected revision range when a version tag exists' {
        function Get-SemanticReleaseCommitRangeBasis {
            param($ProjectRoot)
            $null = $ProjectRoot

            return [pscustomobject]@{
                ProjectRoot = '/repo'
                IsRepository = $true
                HasVersionTag = $true
                LastTag = 'v1.0.0'
                RevisionRange = 'v1.0.0..HEAD'
            }
        }
        Mock Invoke-SemanticReleaseGitCommand {
            return [pscustomobject]@{
                ExitCode = 0
                Output = @('feat: add x', '--END-COMMIT--')
            }
        }

        Read-SemanticReleaseCommitMessage -ProjectRoot '/repo' | Out-Null

        Should -Invoke Invoke-SemanticReleaseGitCommand -ParameterFilter { $Arguments -contains 'v1.0.0..HEAD' }
    }

    It 'falls back to plain git log when no version tag is found' {
        function Get-SemanticReleaseCommitRangeBasis {
            param($ProjectRoot)
            $null = $ProjectRoot

            return [pscustomobject]@{
                ProjectRoot = '/repo'
                IsRepository = $true
                HasVersionTag = $false
                LastTag = $null
                RevisionRange = $null
            }
        }
        Mock Invoke-SemanticReleaseGitCommand {
            return [pscustomobject]@{
                ExitCode = 0
                Output = @('fix: a bug', '--END-COMMIT--')
            }
        }

        Read-SemanticReleaseCommitMessage -ProjectRoot '/repo' | Out-Null

        Should -Invoke Invoke-SemanticReleaseGitCommand -ParameterFilter { -not ($Arguments -match '\.\.HEAD$') }
    }

    It 'splits commits on the delimiter, trims them, and drops blank entries' {
        function Get-SemanticReleaseCommitRangeBasis {
            param($ProjectRoot)
            $null = $ProjectRoot

            return [pscustomobject]@{
                ProjectRoot = '/repo'
                IsRepository = $true
                HasVersionTag = $false
                LastTag = $null
                RevisionRange = $null
            }
        }
        function Invoke-SemanticReleaseGitCommand {
            param($ProjectRoot, $Arguments)
            $null = $ProjectRoot
            $null = $Arguments

            return [pscustomobject]@{
                ExitCode = 0
                Output = @('feat: add x', 'body', '--END-COMMIT--', '', 'fix: a bug', '--END-COMMIT--')
            }
        }

        $messages = Read-SemanticReleaseCommitMessage -ProjectRoot '/repo'

        @($messages).Count | Should -Be 2
        $messages[0] | Should -Be ('feat: add x' + [Environment]::NewLine + 'body')
        $messages[1] | Should -Be 'fix: a bug'
    }
}
