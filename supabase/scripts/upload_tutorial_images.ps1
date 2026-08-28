# Upload tutorial step images to Supabase Storage (`tutorial-images` bucket).
#
# Usage:
#   .\upload_tutorial_images.ps1
#
# Uploads every PNG under ..\tutorial-videos-images\ preserving folder paths
# (e.g. "saree roll display/saree_roll_display_howto_1.png").

param(
  [string]$SourceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\tutorial-videos-images")),
  [string]$Bucket = "tutorial-images"
)

if (-not (Test-Path -LiteralPath $SourceRoot)) {
  Write-Error "Source folder not found: $SourceRoot"
  exit 1
}

$files = Get-ChildItem -Path $SourceRoot -Recurse -Filter *.png -File
Write-Host "Uploading $($files.Count) images from $SourceRoot"

foreach ($file in $files) {
  $relative = $file.FullName.Substring($SourceRoot.Path.Length + 1) -replace '\\', '/'
  Write-Host "  -> $Bucket/$relative"
  supabase storage cp $file.FullName "ss:///$Bucket/$relative" --content-type "image/png"
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed on $relative"
    exit 1
  }
}

Write-Host "Done. Verify in Supabase Dashboard -> Storage -> $Bucket"
