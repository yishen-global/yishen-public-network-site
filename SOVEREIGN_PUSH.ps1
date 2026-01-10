param(
  [string]$SiteRoot = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site",
  [string]$RepoName = "yishen-public-network-site",
  [switch]$PrivateRepo = $true
)

function Assert-Cmd($name){
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Missing command: $name" -ForegroundColor Red
    exit 1
  }
}

Write-Host "=== SOVEREIGN PUSH (J: only) ===" -ForegroundColor Cyan
Write-Host "SiteRoot: $SiteRoot" -ForegroundColor Yellow

if (-not (Test-Path $SiteRoot)) {
  Write-Host "❌ SiteRoot not found: $SiteRoot" -ForegroundColor Red
  exit 1
}

# 必备：git
Assert-Cmd git

Set-Location $SiteRoot

# 生成 .gitignore（只在 site 里）
$gitignore = @"
# Vercel local
.vercel/
.env.local
.env.*
# node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
# archives
*.tgz
*.zip
# OS
.DS_Store
Thumbs.db
"@

if (-not (Test-Path ".gitignore")) {
  $gitignore | Set-Content -Encoding UTF8 ".gitignore"
  Write-Host "✅ .gitignore created" -ForegroundColor Green
}

# 初始化 git（如果没有）
if (-not (Test-Path ".git")) {
  git init | Out-Null
  Write-Host "✅ git init" -ForegroundColor Green
}

# 设置 main 分支
git checkout -B main | Out-Null

# 添加并提交
git add -A
$hasChanges = (git status --porcelain)
if (-not $hasChanges) {
  Write-Host "✅ No changes to commit." -ForegroundColor Green
} else {
  $msg = "Sovereign publish $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  git commit -m $msg | Out-Null
  Write-Host "✅ Commit: $msg" -ForegroundColor Green
}

# 推荐：用 GitHub CLI（gh）自动创建 repo + push
# 如果你没装 gh，就会在这里停下，你可以用下面“无 gh”方案。
if (Get-Command gh -ErrorAction SilentlyContinue) {

  # 检查登录
  $auth = gh auth status 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ gh not authenticated. Run: gh auth login" -ForegroundColor Red
    exit 1
  }

  # 如果没有 remote origin，就创建 repo 并 push
  $origin = (git remote get-url origin 2>$null)
  if (-not $origin) {
    
    Write-Host "⏫ Creating GitHub repo & pushing (gh)..." -ForegroundColor Cyan
    gh repo create $RepoName $vis --source . --remote origin --push $vis --public
    if ($LASTEXITCODE -ne 0) { exit 1 }
    Write-Host "✅ Repo created & pushed: $RepoName" -ForegroundColor Green
  } else {
    Write-Host "⏫ Pushing to origin/main..." -ForegroundColor Cyan
    git push -u origin main
    if ($LASTEXITCODE -ne 0) { exit 1 }
    Write-Host "✅ Pushed to origin/main" -ForegroundColor Green
  }

  Write-Host ""
  Write-Host "NEXT (Vercel UI, once):" -ForegroundColor Yellow
  Write-Host "Vercel Project -> Settings -> Git -> Connect Repository -> select $RepoName" -ForegroundColor Yellow
  Write-Host "After that, every push triggers Production deploy (no api-upload-free)." -ForegroundColor Yellow

} else {
  Write-Host ""
  Write-Host "⚠️ gh not installed. Two options:" -ForegroundColor Yellow
  Write-Host "A) Install GitHub CLI: winget install GitHub.cli" -ForegroundColor Yellow
  Write-Host "B) Manual remote: git remote add origin https://github.com/<YOU>/$RepoName.git ; git push -u origin main" -ForegroundColor Yellow
  exit 1
}



