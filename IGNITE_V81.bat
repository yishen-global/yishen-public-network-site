@echo off
title YiShen Sovereign OS Ignition
echo [1/3] Navigating to Site Directory...
cd /d J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site

echo [2/3] Cleaning old Vercel link...
if exist .vercel rmdir /s /q .vercel

echo [3/3] Forcing Production Deployment...
call vercel --prod --force --yes

echo SUCCESS! Please visit yishen.ai/login
pause