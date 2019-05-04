# Out
$windowSize = $host.ui.rawui.WindowSize;
$backGroundColor = $Host.UI.RawUI.BackgroundColor;
$point = New-Object Management.Automation.Host.Coordinates;

# Border
$borderX = 0
$borderY = 0
$borderW = 16
$borderH = 20

# Tetromino
$minoX = $borderX + ($borderW / 2) - 2
$minoY = $borderY + 1
$minoW = 4
$minoH = 4

# Game
$nowShape = 0
$nowBuffer = $null
$nowX = $minoX
$nowY = $minoY
$rotation = 0

$minoFrame = New-Object Management.Automation.Host.Rectangle;
$minoFrame.Left = $minoX
$minoFrame.Top = $minoY
$minoFrame.Right = $minoX + $minoW
$minoFrame.Bottom = $minoY + $minoH

$nextBuffer = $null
$nextX = $borderX + $borderW + 4
$nextY = 4

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

<#
    
@@@@
    
    
#>
$I0 = @('    ', '@@@@', '    ', '    ')
$I1 = @('  @ ', '  @ ', '  @ ', '  @ ')
$I2 = @('    ', '    ', '@@@@', '    ')
$I3 = @(' @  ', ' @  ', ' @  ', ' @  ')

<#
@   
@@@ 
    
    
#>
$J0 = @('@   ', '@@@ ', '    ', '    ')
$J1 = @(' @@ ', ' @  ', ' @  ', '    ')
$J2 = @('    ', '@@@ ', '  @ ', '    ')
$J3 = @(' @  ', ' @  ', '@@  ', '    ')

<#
  @ 
@@@ 
    
    
#>
$L0 = @('  @ ', '@@@ ', '    ', '    ')
$L1 = @(' @  ', ' @  ', ' @@ ', '    ')
$L2 = @('    ', '@@@ ', '@   ', '    ')
$L3 = @('@@  ', ' @  ', ' @  ', '    ')

<#
 @@ 
 @@ 
    
    
#>
$O0 = @(' @@ ', ' @@ ', '    ', '    ')

<#
 @@ 
@@  
    
    
#>
$S0 = @(' @@ ', '@@  ', '    ', '    ')
$S1 = @(' @  ', ' @@ ', '  @ ', '    ')
$S2 = @('    ', ' @@ ', '@@  ', '    ')
$S3 = @('@   ', '@@  ', ' @  ', '    ')

<#
 @  
@@@ 
    
    
#>
$T0 = @(' @  ', '@@@ ', '    ', '    ')
$T1 = @(' @  ', ' @@ ', ' @  ', '    ')
$T2 = @('    ', '@@@ ', ' @  ', '    ')
$T3 = @(' @  ', '@@  ', ' @  ', '    ')

<#
 @@ 
  @@
    
    
#>
$Z0 = @('@@  ', ' @@ ', '    ', '    ')
$Z1 = @('  @ ', ' @@ ', ' @  ', '    ')
$Z2 = @('    ', '@@  ', ' @@ ', '    ')
$Z3 = @(' @  ', '@@  ', '@   ', '    ')

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
    $mino = $script:shapes[$shape][0]
    $color = $script:colors[$shape]

    $script:nextBuffer = $Host.UI.RawUI.NewBufferCellArray($mino, $color, $script:backGroundColor)
}

function Write-Border() {
    [String[]]$border = @();
    
    $line1 = "|"; 
    $line2 = "O";
    1..$borderW | ForEach-Object { $line1 += " "; $line2 += "="; }
    $line1 += "|"; 
    $line2 += "O";

    $border += $line2;
    1..$borderH | ForEach-Object { $border += $line1; }
    $border += $line2;

    $buffer = $Host.UI.RawUI.NewBufferCellArray($border, [system.consolecolor]::Green, $script:backGroundColor);

    Write-Buffer $borderX $borderY $buffer
}

function Write-NextTetromino() {
    Write-Buffer $script:nextX $script:nextY $script:nextBuffer
}

function Test-Collision() {
}

function Update-Rotation() {
    $script:rotation = ($script:rotation + 1) % $script:maxRotation
}

function Write-NowTetromino() {
    $shape = $script:shapes[$script:nowShape][$script:rotation]
    $color = $script:colors[$script:nowShape]

    $script:nowBuffer = $Host.UI.RawUI.NewBufferCellArray($shape, $color, $script:backGroundColor)

    Write-Buffer $script:nowX $script:nowY $script:nowBuffer
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
            # arrow key
            {(37..40) -contains $_ } {$key.VirtualKeyCode} 
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
}

function main() {    
    Start-NewGame

    do {
        $code = Get-GameEvent
        
        switch($code) {
            # right
            39 { $script:nowX++ }
            # left
            37 { $script:nowX-- }
            # up
            38 { Update-Rotation }
            # down
            40 {}
            # drop
            32 {}
            default {}
        }

        Write-NowTetromino

        Start-Sleep -m 10
    } until($code -eq -1)

    Clear-Host
}

. main