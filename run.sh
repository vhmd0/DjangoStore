#!/bin/bash

if ! command -v uv &> /dev/null
then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
fi

if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null
then
    uv python install
fi

if [ ! -d ".venv" ]; then
    uv venv
fi

source .venv/bin/activate

if [ -f "requirements.txt" ]; then
    uv pip sync -r requirements.txt
fi

if [ -f "manage.py" ]; then
    uv run python manage.py migrate

    echo "from django.contrib.auth import get_user_model; \
User = get_user_model(); \
if not User.objects.filter(username='admin').exists(): \
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | uv run python manage.py shell

    if [ -f "load_data.py" ]; then
        echo "Loading seed data..."
        uv run python load_data.py
    fi

    uv run python manage.py collectstatic --noinput

    if command -v open &> /dev/null; then
        open "http://127.0.0.1:8000/admin"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "http://127.0.0.1:8000/admin"
    fi

    uv run uvicorn shop.asgi:application --host 127.0.0.1 --port 8000
else
    exit 1
fi