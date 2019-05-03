# Draw
$backGroundColor = $Host.UI.RawUI.BackgroundColor;
$point = New-Object Management.Automation.Host.Coordinates;

# Game
$now = @()
$next = @()

# Tetromino
$minoX = 0
$minoY = 0
$minoW = 4
$minoH = 4

# Board
$boardX = 0
$boardY = 0
$boardW = 16
$boardH = 20

# Const
$I = 0
$J = 1
$L = 2
$O = 3
$S = 4
$T = 5
$Z = 6

<#
OOOO
XXXX
OOOO
OOOO
#>
$I0 = 'OOOOXXXXOOOOOOOO'
$I1 = 'OOXOOOXOOOXOOOXO'
$I2 = 'OOOOOOOOXXXXOOOO'
$I3 = 'OXOOOXOOOXOOOXOO'

<#
XOOO
XXXO
OOOO
OOOO
#>
$J0 = 'XOOOXXXOOOOOOOOO'
$J1 = 'OXXOOXOOOXOOOOOO'
$J2 = 'OOOOXXXOOOXOOOOO'
$J3 = 'OXOOOXOOXXOOOOOO'

<#
OOXO
XXXO
OOOO
OOOO
#>
$L0 = 'OOXOXXXOOOOOOOOO'
$L1 = 'OXOOOXOOOXXOOOOO'
$L2 = 'OOOOXXXOXOOOOOOO'
$L3 = 'XXOOOXOOOXOOOOOO'

<#
OXXO
OXXO
OOOO
OOOO
#>
$O0 = 'OXXOOXXOOOOOOOOO'

<#
OXXO
XXOO
OOOO
OOOO
#>
$S0 = 'OXXOXXOOOOOOOOOO'
$S1 = 'OXOOOXXOOOXOOOOO'
$S2 = 'OOOOOXXOXXOOOOOO'
$S3 = 'XOOOXXOOOXOOOOOO'

<#
OXOO
XXXO
OOOO
OOOO
#>
$T0 = 'OXOOXXXOOOOOOOOO'
$T1 = 'OXOOOXXOOXOOOOOO'
$T2 = 'OOOOXXXOOXOOOOOO'
$T3 = 'OXOOXXOOOXOOOOOO'

<#
OXXO
OOXX
OOOO
OOOO
#>
$Z0 = 'XXOOOXXOOOOOOOOO'
$Z1 = 'OOXOOXXOOXOOOOOO'
$Z2 = 'OOOOXXOOOXXOOOOO'
$Z3 = 'OXOOXXOOXOOOOOOO'

$shapes = @(
    ($I0, $I1, $I2, $I3),
    ($J0, $J1, $J2, $J3),
    ($L0, $L1, $L2, $L3),
    ($O0, $O0, $O0, $O0),
    ($S0, $S1, $S2, $S3),
    ($T0, $T1, $T2, $T3),
    ($Z0, $Z1, $Z2, $Z3)
)

function NewTetromino($type) {
    $shape = $script:shapes[$type][0]

    #Write-Host $shape
    $mino = @()

    $i = 0
    for($y = 0; $y -lt $script:minoH; $y++) {
        for($x = 0; $x -lt $script:minoW; $x++) {
            if($shape[$i] -eq 'X') {
                $mino += $true
            } else {
                $mino += $false
            }
            $i++
        }
    }

    return $mino
}

function DrawBoard() {    
}

function DrawNow() {
    $x = 0
    $y = 0
    foreach($c in $script:now) {
        if($c -eq $true) {
            $cell = $script:buffer[$y, $x]
            $cell.Character = "@"
            $cell.ForegroundColor = [System.ConsoleColor]::Magenta
            $script:buffer[$y, $x] = $cell
        }

        $x++
        if($x -ge $script:minoW) {
            $x = 0
            $y++
        } 
    }
}

function Draw($x, $y, $buffer) {
    $script:point.x = $x
    $script:point.y = $y
    $Host.UI.RawUI.SetBufferContents($script:point, $buffer)
}

function GetEvent() {
    $e = 0;

    if ($Host.UI.RawUi.KeyAvailable){ 
        $key = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyUp");
        
        $e = switch($key.VirtualKeyCode){
            # q
            81 { -1 }
            # space
            32 { 32 }
            # arrow key
            {(37..40) -contains $_ } {$key.VirtualKeyCode} 
            # do nothing
            default { 0 } 
        }
    }

    return $e
}

function main() {    
    $script:now = NewTetromino($L)

    Clear-Host
    $frame = New-Object Management.Automation.Host.Rectangle;
    $windowSize = $host.ui.rawui.WindowSize;
    $frame.Left = 0
    $frame.Top = 0
    $frame.Right = $windowSize.Width
    $frame.Bottom = $windowSize.Height
    $script:frameBuffer = $Host.UI.RawUI.GetBufferContents($frame)
    $script:buffer = $frameBuffer.Clone()

    do {
        $code = GetEvent
    
        switch($code) {
            default {}
        }

        DrawNow
        Draw 0 0 $buffer

        Start-Sleep -m 10
    } until($code -eq -1)

    Clear-Host
}

. main