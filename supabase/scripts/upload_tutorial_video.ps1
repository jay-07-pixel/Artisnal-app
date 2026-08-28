# Upload local tutorial videos to Supabase Storage.
#
# Usage:
#   .\upload_tutorial_videos.ps1 -VideoPath "..\WhatsApp Video 2026-08-28 at 9.50.17 AM.mp4" -StorageKey "cushion_propped.mp4"
#
# Requires Supabase CLI logged in and project linked, OR set $env:SUPABASE_ACCESS_TOKEN.

param(
  [Parameter(Mandatory = $true)]
  [string]$VideoPath,

  [Parameter(Mandatory = $true)]
  [string]$StorageKey,

  [string]$Bucket = "tutorial-videos"
)

$resolved = Resolve-Path -LiteralPath $VideoPath
Write-Host "Uploading $resolved -> $Bucket/$StorageKey"

supabase storage cp $resolved "ss:///$Bucket/$StorageKey" --content-type "video/mp4"

if ($LASTEXITCODE -eq 0) {
  Write-Host "Done. Verify in Supabase Dashboard -> Storage -> $Bucket"
} else {
  Write-Error "Upload failed. Try Dashboard upload instead."
  exit 1
}
