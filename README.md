#  Smarts3r — Django E-Commerce Platform

A full-stack e-commerce platform built with Django and PostgreSQL,
featuring a modular architecture, Docker deployment, and Arabic 
language support.

##  Features
-  Product catalog with categories and filtering
-  Shopping cart with session management
-  Order processing and management system
-  User authentication and profile management
-  Arabic/English internationalization (i18n)
-  Dockerized with Nginx for production deployment
-  PostgreSQL with optimized ORM queries

##  Tech Stack
| Layer | Technology |
|---|---|
| Backend | Django, Python |
| Database | PostgreSQL |
| Frontend | HTML, CSS, Bootstrap, JavaScript |
| DevOps | Docker, Docker Compose, Nginx |
| i18n | Django Translations (AR/EN) |

##  Quick Start (Docker)
```bash
git clone https://github.com/vhmd0/store-p11
cd store-p11
cp .env.example .env
docker-compose up --build
```
Visit: http://localhost

##  Project Structure
```
├── products/     # Product catalog & categories
├── cart/         # Shopping cart logic
├── orders/       # Order processing
├── users/        # Authentication & profiles
├── shop/         # Main storefront
├── core/         # Shared utilities
└── nginx/        # Production server config
```
