
if (!(Get-Command "uv" -ErrorAction SilentlyContinue)) {
    Write-Host "--- [Step 1/6] Installing setup tools (uv) ---" -ForegroundColor Cyan
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    $env:Path += ";$env:USERPROFILE\.cargo\bin"
}
else {
    Write-Host "--- [Step 1/6] Setup tools found ---" -ForegroundColor Green
}


if (!(Test-Path ".venv")) {
    Write-Host "--- [Step 2/6] Creating virtual environment ---" -ForegroundColor Cyan
    uv venv
}


$env:VIRTUAL_ENV = "$(Get-Location)\.venv"
$env:PATH = "$(Get-Location)\.venv\Scripts;$env:PATH"


if (Test-Path "requimentes.txt") {
    Write-Host "--- [Step 3/6] Installing dependencies (this may take a moment) ---" -ForegroundColor Cyan
    uv pip install -r requimentes.txt
}

if (Test-Path "manage.py") {
    Write-Host "--- [Step 4/7] Setting up Database ---" -ForegroundColor Cyan
    uv run python manage.py migrate

    Write-Host "--- [Step 5/7] Creating Admin Account (User: admin / Pass: admin) ---" -ForegroundColor Cyan
    $adminScript = @"
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
    print('Superuser created successfully!')
else:
    print('Admin account already exists.')
"@
    $adminScript | uv run python manage.py shell

    Write-Host "--- [Step 6/7] Loading Seed Data ---" -ForegroundColor Cyan
    if (Test-Path "load_data.py") {
        uv run python load_data.py
    }

    Write-Host "--- [Step 7/7] Collecting static files ---" -ForegroundColor Cyan
    uv run python manage.py collectstatic --noinput


    Write-Host "--- SUCCESS! Launching your project ---" -ForegroundColor Green
    Write-Host "Username: admin | Password: admin" -ForegroundColor White -BackgroundColor DarkCyan
    
    Start-Process "http://127.0.0.1:8000/admin"
    
    uv run uvicorn shop.asgi:application --host 127.0.0.1 --port 8000
}
else {
    Write-Host "ERROR: Could not find manage.py. Please make sure you are in the correct folder!" -ForegroundColor Red
    Pause
}