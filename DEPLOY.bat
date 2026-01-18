@echo off
echo [SYSTEM] Initiating V8.1 Sovereign OS Global Sync...
cd /d %~dp0
vercel --prod --yes --force
echo [SUCCESS] Global Nodes Updated.
pause