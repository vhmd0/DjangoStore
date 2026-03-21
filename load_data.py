#!/usr/bin/env python
"""
Load seeding data into SQLite database.
Run: uv run python load_data.py
"""

import os
import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "db.sqlite3"


def load_env():
    env_path = BASE_DIR / ".env"
    if env_path.exists():
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):
                    if "=" in line:
                        key, val = line.split("=", 1)
                        os.environ[key.strip()] = val.strip()


def load_data():
    load_env()
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    sql_files = [
        ("Seeding Data", BASE_DIR / "data_seeding.sql"),
    ]

    for name, sql_file in sql_files:
        if not sql_file.exists():
            print(f"  File not found: {sql_file}")
            continue

        print(f"Loading {name}...")
        with open(sql_file, "r", encoding="utf-8") as f:
            sql_content = f.read()

        for statement in sql_content.split(";"):
            statement = statement.strip()
            if (
                statement
                and not statement.startswith("--")
                and not statement.startswith("SET")
                and not statement.startswith("START")
                and not statement.startswith("COMMIT")
            ):
                try:
                    cursor.execute(statement)
                except sqlite3.IntegrityError as e:
                    if (
                        "UNIQUE constraint failed" in str(e)
                        or "already exists" in str(e).lower()
                    ):
                        continue
                    print(f"   Warning: {e}")
                except sqlite3.OperationalError as e:
                    print(f"   Warning: {e}")
                except Exception as e:
                    print(f"   Warning: {e}")

        print(f"   {name} loaded")

    conn.commit()
    conn.close()
    print("\nData loaded successfully!")


if __name__ == "__main__":
    load_data()
