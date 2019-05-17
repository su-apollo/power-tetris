$logo = @(
'          _          _            _             _            _     ', 
'        /\ \       /\ \         / /\      _   /\ \         /\ \    ',
'       /  \ \     /  \ \       / / /    / /\ /  \ \       /  \ \   ',
'      / /\ \ \   / /\ \ \     / / /    / / // /\ \ \     / /\ \ \  ',
'     / / /\ \_\ / / /\ \ \   / / /_   / / // / /\ \_\   / / /\ \_\ ',
'    / / /_/ / // / /  \ \_\ / /_//_/\/ / // /_/_ \/_/  / / /_/ / / ',
'   / / /__\/ // / /   / / // _______/\/ // /____/\    / / /__\/ /  ',
'  / / /_____// / /   / / // /  \____\  // /\____\/   / / /_____/   ',
' / / /      / / /___/ / //_/ /\ \ /\ \// / /______  / / /\ \ \     ',
'/ / /      / / /____\/ / \_\//_/ /_/ // / /_______\/ / /  \ \ \    ',
'\/_/       \/_________/      \_\/\_\/ \/__________/\/_/    \_\/    ',
'       _            _          _          _         _              ',
'      /\ \         /\ \       /\ \       /\ \      / /\            ',
'      \_\ \       /  \ \      \_\ \      \ \ \    / /  \           ',
'      /\__ \     / /\ \ \     /\__ \     /\ \_\  / / /\ \__        ',
'     / /_ \ \   / / /\ \_\   / /_ \ \   / /\/_/ / / /\ \___\       ',
'    / / /\ \ \ / /_/_ \/_/  / / /\ \ \ / / /    \ \ \ \/___/       ',
'   / / /  \/_// /____/\    / / /  \/_// / /      \ \ \             ',
'  / / /      / /\____\/   / / /      / / /   _    \ \ \            ',
' / / /      / / /______  / / /   ___/ / /__ /_/\__/ / /            ',
'/_/ /      / / /_______\/_/ /   /\__\/_/___\\ \/___/ /             ',
'\_\/       \/__________/\_\/    \/_________/ \_____\/              '
)

# Host
$speaker = New-Object -ComObject "SAPI.SpVoice";
$voices = $speaker.GetVoices();
$windowSize = $host.ui.rawui.WindowSize;
$backGroundColor = $Host.UI.RawUI.BackgroundColor;
$point = New-Object Management.Automation.Host.Coordinates;

# Ground
$groundX = 10
$groundY = 5
$groundW = 16
$groundH = 20

$groundBuffer = $null
$groundFrame = New-Object Management.Automation.Host.Rectangle;
$groundFrame.Left = $groundX
$groundFrame.Top = $groundY
$groundFrame.Right = $groundX + $groundW
$groundFrame.Bottom = $groundY + $groundH

$borderColor = [system.consolecolor]::Magenta

# Tetromino
$minoX = $groundX + ($groundW / 2) - 2
$minoY = $groundY
$minoW = 4
$minoH = 4

# Game
$step = 400;

$nowShape = 0
$nowX = $minoX
$nowY = $minoY
$rotation = 0
$prevNowX = $nowX
$prevNowY = $nowY
$prevRotation = $rotation

$nextShape = 0
$nextBuffer = $null
$nextX = $groundX + $groundW + 4
$nextY = 9

$gameFrame = New-Object Management.Automation.Host.Rectangle;
$gameFrame.Left = 0
$gameFrame.Top = 0
$gameFrame.Right = $windowSize.Width
$gameFrame.Bottom = $windowSize.Height

# Tetromino Shapes
$I = 0
$J = 1
$L = 2
$O = 3
$S = 4
$T = 5
$Z = 6
$maxShape = 6
$maxRotation = 4

$minoChar = '@'

$I0 = @(
    '    ', 
    '@@@@', 
    '    ', 
    '    ')
$I1 = @(
    '  @ ', 
    '  @ ', 
    '  @ ', 
    '  @ ')
$I2 = @(
    '    ', 
    '    ', 
    '@@@@', 
    '    ')
$I3 = @(
    ' @  ', 
    ' @  ', 
    ' @  ', 
    ' @  ')

$J0 = @(
    '@   ', 
    '@@@ ', 
    '    ', 
    '    ')
$J1 = @(
    ' @@ ', 
    ' @  ', 
    ' @  ', 
    '    ')
$J2 = @(
    '    ', 
    '@@@ ', 
    '  @ ', 
    '    ')
$J3 = @(
    ' @  ', 
    ' @  ', 
    '@@  ', 
    '    ')

$L0 = @(
    '  @ ', 
    '@@@ ', 
    '    ', 
    '    ')
$L1 = @(
    ' @  ', 
    ' @  ', 
    ' @@ ', 
    '    ')
$L2 = @(
    '    ', 
    '@@@ ', 
    '@   ', 
    '    ')
$L3 = @(
    '@@  ', 
    ' @  ', 
    ' @  ', 
    '    ')

$O0 = @(
    ' @@ ', 
    ' @@ ', 
    '    ', 
    '    ')

$S0 = @(
    ' @@ ', 
    '@@  ', 
    '    ', 
    '    ')
$S1 = @(
    ' @  ', 
    ' @@ ', 
    '  @ ', 
    '    ')
$S2 = @(
    '    ', 
    ' @@ ', 
    '@@  ', 
    '    ')
$S3 = @(
    '@   ', 
    '@@  ', 
    ' @  ', 
    '    ')

$T0 = @(
    ' @  ', 
    '@@@ ', 
    '    ', 
    '    ')
$T1 = @(
    ' @  ', 
    ' @@ ', 
    ' @  ', 
    '    ')
$T2 = @(
    '    ', 
    '@@@ ', 
    ' @  ', 
    '    ')
$T3 = @(
    ' @  ', 
    '@@  ', 
    ' @  ', 
    '    ')

$Z0 = @(
    '@@  ', 
    ' @@ ', 
    '    ', 
    '    ')
$Z1 = @(
    '  @ ', 
    ' @@ ', 
    ' @  ', 
    '    ')
$Z2 = @(
    '    ', 
    '@@  ', 
    ' @@ ', 
    '    ')
$Z3 = @(
    ' @  ', 
    '@@  ', 
    '@   ', 
    '    ')

$shapes = @(
    ($I0, $I1, $I2, $I3),
    ($J0, $J1, $J2, $J3),
    ($L0, $L1, $L2, $L3),
    ($O0, $O0, $O0, $O0),
    ($S0, $S1, $S2, $S3),
    ($T0, $T1, $T2, $T3),
    ($Z0, $Z1, $Z2, $Z3)
)

$colors = @(
    [System.ConsoleColor]::Gray,
    [System.ConsoleColor]::Green,
    [System.ConsoleColor]::Cyan,
    [System.ConsoleColor]::Red,
    [System.ConsoleColor]::Magenta,
    [System.ConsoleColor]::Yellow,
    [System.ConsoleColor]::White
);

function Update-NowTetromino($shape) {
    $script:nowX = $script:minoX
    $script:nowY = $script:minoY
    $script:rotation = 0
    $script:nowShape = $shape
}

function Update-NextTetromino($shape) {
    $script:nextShape = $shape
    $mino = $script:shapes[$shape][0]
    $color = $script:colors[$shape]

    $script:nextBuffer = $Host.UI.RawUI.NewBufferCellArray($mino, $color, $script:backGroundColor)
}

function Set-NextTetormino() {
    Update-NowTetromino $script:nextShape

    $rand = Get-random $script:maxShape
    Update-NextTetromino $rand

    Write-NextTetromino
}

function Update-GroundBuffer() {
    $script:groundBuffer = $Host.UI.RawUI.GetBufferContents($script:groundFrame)
}

function Set-PrevVariable() { 
    $script:prevNowX = $script:nowX
    $script:prevNowY = $script:nowY
    $script:prevRotation = $script:rotation
}

function Reset-Variable() {
    $script:nowX = $script:prevNowX
    $script:nowY = $script:prevNowY
    $script:rotation = $script:prevRotation
}

function Write-Border() {
    [String[]]$border = @();
    
    $line1 = '|' 
    $line2 = 'O'    
    1..$groundW | ForEach-Object { 
        $line1 += ' ' 
        $line2 += '=' 
    }    
    $line1 += '|' 
    $line2 += 'O'

    $border += $line2
    1..$groundH | ForEach-Object { 
        $border += $line1 
    }
    $border += $line2

    $buffer = $Host.UI.RawUI.NewBufferCellArray($border, $script:borderColor, $script:backGroundColor)

    $x = $groundX - 1
    $y = $groundY - 1
    Write-Buffer $x $y $buffer
}

function Write-NextTetromino() {
    Write-Buffer $script:nextX $script:nextY $script:nextBuffer
}

function Update-Rotation() {
    $script:rotation = ($script:rotation + 1) % $script:maxRotation
}

function Clear-Line() {
    $count = 0
    $buffer = $script:groundBuffer.Clone()

    foreach($y in ($script:groundH - 1)..0) {
        $fill = $true

        foreach($x in 0..($script:groundW - 1)) {
            $cell = $buffer[$y, $x]

            if($cell.Character -ne $script:minoChar) {
                $fill = $false
                break
            }
        }

        if($fill) {
            $count++
            foreach($i in $y..1) {
                foreach($x in 0..($script:groundW - 1)) {
                    $upper = $i - 1                    
                    $cell = $buffer[$upper, $x]
                    $buffer[$i, $x] = $cell
                }
            }
        }
    }

    Write-Buffer $script:groundX $script:groundY $buffer
    return $count
}

function Write-NowTetromino() {
    $shape = $script:shapes[$script:nowShape][$script:rotation]
    $color = $script:colors[$script:nowShape]
    $buffer = $script:groundBuffer.Clone()

    foreach($y in 0..($script:minoH - 1)) {
        foreach($x in 0..($script:minoW - 1)) {
            $char = $shape[$y][$x]

            if($char -eq $script:minoChar) {
                $pointX = $script:nowX - $script:groundX + $x
                $pointY = $script:nowY - $script:groundY + $y

                $cell = $buffer[$pointY, $pointX]
                if($cell.Character -ne ' ') {
                    return $false
                }

                $cell.Character = $char
                $cell.ForegroundColor = $color
                $buffer[$pointY, $pointX] = $cell
            }
        }
    }

    Write-Buffer $script:groundX $script:groundY $buffer
    return $true
}

function Write-Buffer($x, $y, $buffer) {
    $script:point.x = $x
    $script:point.y = $y
    $Host.UI.RawUI.SetBufferContents($script:point, $buffer)
}

function Write-Text($x, $y, $message) {
    $script:point.x = $x; 
    $script:point.y = $y;
    $Host.UI.RawUI.CursorPosition = $script:point;
    Write-Host $message;
}

function Get-GameEvent() {
    $e = 0;

    if ($Host.UI.RawUi.KeyAvailable){ 
        $key = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyUp");
        
        $e = switch($key.VirtualKeyCode){
            # q
            81 { -1 }
            # space
            32 { 32 }
            # arrow keys
            {(37..40) -contains $_ } {$key.VirtualKeyCode} 
            # h
            72 { 37 }
            # j
            74 { 38 }
            # k
            75 { 40 }
            # l
            76 { 39 }            
            # do nothing
            default { 0 } 
        }
    }

    return $e
}

function Start-NewGame() {
    Clear-Host
    Write-Border

    $rand = Get-random $script:maxShape
    Update-NowTetromino $rand

    $rand = Get-random $script:maxShape
    Update-NextTetromino $rand

    Write-NextTetromino

    Update-GroundBuffer
}

function Speak([Int32]$index, [Int32]$rate, [String]$words){
    $script:speaker.Rate = $rate;
    $script:speaker.Voice = $voices.Item($index);
    $color = switch($index){0 {"Red"} default {"Yellow"}};
    $script:speaker.Speak($words, 1) | Out-Null;
    Write-Host $words -ForegroundColor $color
    $script:speaker.WaitUntilDone(60000) | Out-Null;
}

function main() {    
    $i = 0
    foreach($line in $script:logo) {
        Write-Host $line -ForegroundColor $script:colors[$i]
        $i++
        $i = $i % $script:colors.Count
    }

    Speak 0 0 "Power Tetris"
    Speak 0 0 "press space key"

    do {
        $code = Get-GameEvent        
    } until ($code -eq 32)

    Start-NewGame
    $startTime = Get-Date

    do {
        Set-PrevVariable
        $code = Get-GameEvent
        
        $drop = $false
        switch($code) {
            # right
            39 { $script:nowX++ }
            # left
            37 { $script:nowX-- }
            # up
            38 { Update-Rotation }
            # down
            40 { $script:nowY++ }
            # drop
            32 {
                $result = Write-NowTetromino
                while($result){
                    $script:nowY++
                    $result = Write-NowTetromino
                }
                $script:nowY--
                $drop = $true
            }
            default {}
        }

        $result = Write-NowTetromino
        if(!$result) {
            Reset-Variable
        }

        $elapsed = ((Get-Date).Subtract($startTime)).TotalMilliseconds
        if(($elapsed -ge $script:step) -OR $drop) {
            $startTime = Get-Date
            $script:nowY++

            $result = Write-NowTetromino
            if(!$result) {
                $script:nowY--
                Update-GroundBuffer
                $line = Clear-Line
                if($line -gt 0) {
                    Update-GroundBuffer
                }
                Set-NextTetormino
                $result = Write-NowTetromino
                if(!$result) {
                    break
                }
            }
        }

        Start-Sleep -m 10
    } until($code -eq -1)

    Clear-Host
}

. main