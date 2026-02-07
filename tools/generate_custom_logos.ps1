Add-Type -AssemblyName System.Drawing

function New-Canvas([int]$size) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $bmp.MakeTransparent()
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  return @{ Bmp = $bmp; G = $g }
}

function Save-Canvas($ctx, $path) {
  $ctx.G.Dispose()
  $ctx.Bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $ctx.Bmp.Dispose()
}

$size = 512
$w = [float]$size
$h = [float]$size

# Python logo
$ctx = New-Canvas $size
$g = $ctx.G
$blue = [System.Drawing.ColorTranslator]::FromHtml('#3776AB')
$yellow = [System.Drawing.ColorTranslator]::FromHtml('#FFD43B')
$white = [System.Drawing.Color]::White

$r = $w * 0.18
$inset = $w * 0.08
$topRect = [System.Drawing.RectangleF]::new($inset, $inset, ($w - $inset * 1.8), ($h * 0.48))
$bottomRect = [System.Drawing.RectangleF]::new(($inset * 1.2), ($h * 0.44), ($w - $inset * 1.8), ($h * 0.48))

$topPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$topPath.AddArc($topRect.X, $topRect.Y, $r*2, $r*2, 180, 90)
$topPath.AddArc($topRect.Right - $r*2, $topRect.Y, $r*2, $r*2, 270, 90)
$topPath.AddArc($topRect.Right - $r*2, $topRect.Bottom - $r*2, $r*2, $r*2, 0, 90)
$topPath.AddArc($topRect.X, $topRect.Bottom - $r*2, $r*2, $r*2, 90, 90)
$topPath.CloseFigure()

$topNotch = [System.Drawing.RectangleF]::new(($w*0.55), ($h*0.30), ($w*0.28), ($h*0.22))
$topRegion = New-Object System.Drawing.Region $topPath
$topRegion.Exclude($topNotch)

$blueBrush = New-Object System.Drawing.SolidBrush $blue
$g.FillRegion($blueBrush, $topRegion)

$bottomPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$bottomPath.AddArc($bottomRect.X, $bottomRect.Y, $r*2, $r*2, 180, 90)
$bottomPath.AddArc($bottomRect.Right - $r*2, $bottomRect.Y, $r*2, $r*2, 270, 90)
$bottomPath.AddArc($bottomRect.Right - $r*2, $bottomRect.Bottom - $r*2, $r*2, $r*2, 0, 90)
$bottomPath.AddArc($bottomRect.X, $bottomRect.Bottom - $r*2, $r*2, $r*2, 90, 90)
$bottomPath.CloseFigure()

$bottomNotch = [System.Drawing.RectangleF]::new(($w*0.18), ($h*0.48), ($w*0.28), ($h*0.22))
$bottomRegion = New-Object System.Drawing.Region $bottomPath
$bottomRegion.Exclude($bottomNotch)

$yellowBrush = New-Object System.Drawing.SolidBrush $yellow
$g.FillRegion($yellowBrush, $bottomRegion)

$whiteBrush = New-Object System.Drawing.SolidBrush $white
$g.FillEllipse($whiteBrush, $w*0.28, $h*0.24, $w*0.06, $w*0.06)
$g.FillEllipse($whiteBrush, $w*0.66, $h*0.70, $w*0.06, $w*0.06)

Save-Canvas $ctx 'assets/images/python_custom.png'

# C logo
$ctx = New-Canvas $size
$g = $ctx.G
$blue1 = [System.Drawing.ColorTranslator]::FromHtml('#659AD2')
$blue2 = [System.Drawing.ColorTranslator]::FromHtml('#00599C')
$light = [System.Drawing.ColorTranslator]::FromHtml('#8DB3E2')

$center = [System.Drawing.PointF]::new(($w/2), ($h/2))
$radius = $w*0.42

$hex = New-Object System.Drawing.Drawing2D.GraphicsPath
for ($i=0; $i -lt 6; $i++) {
  $angle = ([Math]::PI/3)*$i - [Math]::PI/2
  $x = $center.X + $radius * [Math]::Cos($angle)
  $y = $center.Y + $radius * [Math]::Sin($angle)
  if ($i -eq 0) { $hex.StartFigure(); $hex.AddLine($x, $y, $x, $y) } else { $hex.AddLine($xPrev, $yPrev, $x, $y) }
  $xPrev = $x; $yPrev = $y
}
$hex.CloseFigure()

$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  ([System.Drawing.RectangleF]::new(0,0,$w,$h)),
  $blue1,
  $blue2,
  [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$g.FillPath($brush, $hex)

$penInner = New-Object System.Drawing.Pen $light, ($w*0.035)
$innerRadius = $radius*0.74
$innerHex = New-Object System.Drawing.Drawing2D.GraphicsPath
for ($i=0; $i -lt 6; $i++) {
  $angle = ([Math]::PI/3)*$i - [Math]::PI/2
  $x = $center.X + $innerRadius * [Math]::Cos($angle)
  $y = $center.Y + $innerRadius * [Math]::Sin($angle)
  if ($i -eq 0) { $innerHex.StartFigure(); $innerHex.AddLine($x, $y, $x, $y) } else { $innerHex.AddLine($xPrev, $yPrev, $x, $y) }
  $xPrev = $x; $yPrev = $y
}
$innerHex.CloseFigure()
$g.DrawPath($penInner, $innerHex)

$penC = New-Object System.Drawing.Pen ([System.Drawing.Color]::White), ($w*0.16)
$penC.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$penC.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$rectC = [System.Drawing.RectangleF]::new(($center.X - $radius*0.48), ($center.Y - $radius*0.48), ($radius*0.96), ($radius*0.96))
$g.DrawArc($penC, $rectC, 200, 220)

Save-Canvas $ctx 'assets/images/c_custom.png'
