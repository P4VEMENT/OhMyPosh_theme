#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $sl.Colors.PromptBackgroundColor
    
    # Flash icon
    If ($lastCommandFailed) {
        $prompt = Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol)" -ForegroundColor $sl.Colors.FailedFlashIconColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }
    else {
        If (Test-Administrator) {
            $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol)" -ForegroundColor $sl.Colors.AdminFlashIconColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
        }
        else {
            $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ELevatedSymbol)" -ForegroundColor $sl.Colors.FlashIconColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
        }
    }

    # Check virtual env
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }
    else {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.SessionInfoBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }

    # Writes the path
    $pathSymbol = if ($pwd.Path -eq $HOME) { 
        $sl.PromptSymbols.PathHomeSymbol
    }
    else { 
        $sl.PromptSymbols.PathSymbol 
    }
    $path =$pathSymbol + "  " + (Get-FullPath -dir $pwd)
    $prompt += Write-Prompt -Object "$path " -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor

    # Writes Git info
    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $lastColor = $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object $($sl.PromptSymbols.SegmentForwardSymbol) -ForegroundColor $sl.Colors.PromptBackgroundColor -BackgroundColor $lastColor
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $lastColor -ForegroundColor $sl.Colors.GitForegroundColor
    }

    # Writes the time
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor -BackgroundColor $sl.Colors.TimeBackgroundColor
    $prompt += Write-Prompt -Object " $($sl.PromptSymbols.ClockSymbol) " -ForegroundColor $sl.Colors.TimeForegroundColor -BackgroundColor $sl.Colors.TimeBackgroundColor
    $timeStamp = Get-Date -Format "yyyyMMdd HH:mm:ss"
    $timestamp = "$timeStamp"
    $prompt += Write-Prompt -Object "$timeStamp " -ForegroundColor $sl.Colors.TimeForegroundColor -BackgroundColor $sl.Colors.TimeBackgroundColor
    
    # Writes the postfix to the prompt
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.TimeBackgroundColor

    $prompt += Set-Newline

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }
    $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += ' '
    $prompt
}

# Local settings
$sl = $global:ThemeSettings 

# Symbols
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.PromptSymbols.PathHomeSymbol = [char]::ConvertFromUtf32(0xf015)
$sl.PromptSymbols.PathSymbol = [char]::ConvertFromUtf32(0xf07c)
$sl.PromptSymbols.ClockSymbol = [char]::ConvertFromUtf32(0xf64f)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x276F)

# Colors
$sl.Colors.FailedFlashIconColor = [ConsoleColor]::Red
$sl.Colors.AdminFlashIconColor = [ConsoleColor]::DarkYellow
$sl.Colors.FlashIconColor = [ConsoleColor]::Green

$sl.Colors.PromptForegroundColor = [ConsoleColor]::White

$sl.Colors.PromptSymbolColor = [ConsoleColor]::White

$sl.Colors.GitForegroundColor = [ConsoleColor]::Black

$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta

$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::DarkGreen
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White

$sl.Colors.TimeForegroundColor = [System.ConsoleColor]::White
$sl.Colors.TimeBackgroundColor = [System.ConsoleColor]::DarkGray
