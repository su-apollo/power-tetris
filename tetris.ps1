$point = New-Object Management.Automation.Host.Coordinates;

[Boolean[][]]$current = @()

$minoWidth = 4
$minoHeight = 4

$I = '
0000
1111
0000
0000
'

$J = '
1000
1110
0000
0000
'

$S = '
0110
1100
0000
0000
'

$Z = '
1100
0110
0000
0000
'

$T = '
0100
1110
0000
0000
'

$O = '
0110
0110
0000
0000
'

$L = '
0010
1110
0000
0000
'

function NewTetroMino($type) {
    [Boolean[][]]$mino = @(
        ($false, $false, $false, $false),
        ($false, $false, $false, $false),
        ($false, $false, $false, $false),
        ($false, $false, $false, $false)
    )
    
    $x = 0
    $y = 0
    foreach($c in $type) {
        if($c -eq '0') {
            $mino[$x][$y] = $false
        } else {
            $mino[$x][$y] = $true
        }
        $x++
        if($x -gt $script:minoWidth) {
            $x = 0
            $y++
        } 
    }
    return $mino
}

function Draw($x, $y, $buffer) {
    $script:point.x = $x
    $script:point.y = $y
    $Host.UI.RawUI.SetBufferContents($script:point, $buffer)
}

function main() {    
    $script:current = NewTetroMino($L)

    $frame = New-Object Management.Automation.Host.Rectangle;
    $size = $host.ui.rawui.WindowSize;
    $frame.Left = 0
    $frame.Top = 0
    $frame.Right = $size.Width
    $frame.Bottom = $size.Height
    $frameBuffer = $Host.UI.RawUI.GetBufferContents($frame)
    $buffer = $frameBuffer.Clone();

    $x = 0
    $y = 0
    foreach($c in $script:current) {
        if($c) {
            $cell = $buffer[$y, $x]
            $cell.Character = "@"
            $cell.ForegroundColor = [System.ConsoleColor]::Magenta
            $buffer[$y, $x] = $cell

            #Write-Output "test"
        }

        $x++
        if($x -gt $script:minoWidth) {
            $x = 0
            $y++
        } 
    }

    Draw 0 0 $buffer
}

. main