# homeflow/Makefile
.PHONY: help init up down migrate fresh test backend-install frontend-install

GREEN := \033[0;32m
NC := \033[0m

help:
	@echo "$(GREEN)Доступные команды homeflow:$(NC)"
	@echo "  make init            - Полная инициализация (зависимости, БД, миграции)"
	@echo "  make up              - Запуск Docker-контейнеров бэкенда"
	@echo "  make down            - Остановка Docker-контейнеров"
	@echo "  make migrate         - Выполнение миграций БД"
	@echo "  make fresh           - Полный сброс БД и запуск миграций с сидами"
	@echo "  make test            - Запуск тестов Laravel"

init:
	@echo "🚀 Инициализация окружения..."
	@if [ ! -f backend/composer.json ]; then \
		echo "❌ Ошибка: Проект Laravel не найден в папке backend/."; \
		exit 1; \
	fi
	@if [ ! -f backend/.env ]; then \
		cp backend/.env.example backend/.env; \
		echo "✅ Создан backend/.env"; \
	fi
	@make backend-install
	@make frontend-install
	@make up
	@make migrate
	@echo "$(GREEN)🎉 Проект успешно инициализирован!$(NC)"

up:
	@echo "Запуск контейнеров..."
	cd backend && docker compose up -d --build

down:
	@echo "Остановка контейнеров..."
	cd backend && docker compose down

migrate:
	@echo "Выполнение миграций..."
	cd backend && docker compose exec -T app php artisan migrate --force

fresh:
	@echo "Сброс базы данных и запуск сидов..."
	cd backend && docker compose exec -T app php artisan migrate:fresh --seed

test:
	@echo "Запуск тестов..."
	cd backend && docker compose exec -T app php artisan test

backend-install:
	@echo "Установка PHP зависимостей..."
	cd backend && docker compose run --rm app composer install --no-interaction --optimize-autoloader

frontend-install:
	@echo "Установка Node.js зависимостей..."
	@if [ ! -f frontend-desktop/package.json ]; then \
		echo "⚠️ frontend-desktop не найден. Инициализируем базовый Vue+Vite проект..."; \
		mkdir -p frontend-desktop; \
		cd frontend-desktop && npm init -y; \
		cd frontend-desktop && npm install vue vue-router pinia @vitejs/plugin-vue vite tailwindcss postcss autoprefixer; \
		cd frontend-desktop && npx tailwindcss init -p; \
	fi
	cd frontend-desktop && npm install