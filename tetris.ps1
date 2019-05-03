$backGroundColor = $Host.UI.RawUI.BackgroundColor;

$point = New-Object Management.Automation.Host.Coordinates;

[Boolean[][]]$current = @()

$minoX = 0
$minoY = 0
$minoW = 4
$minoH = 4

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
        if($x -gt $script:minoW) {
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
    Clear-Host
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
        if($x -gt $script:minoW) {
            $x = 0
            $y++
        } 
    }

    do {
        $code = GetEvent
    
        switch($code) {
            default {}
        }

        Draw 0 0 $buffer

        Start-Sleep -m 10
    } until($code -eq -1)
}

. main