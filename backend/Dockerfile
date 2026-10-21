FROM php:8.5-cli

# Установка системных зависимостей и компиляция необходимых расширений
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    supervisor \
    && docker-php-ext-install -j$(nproc) \
    pdo_pgsql \
    zip \
    pcntl \
    posix \
    bcmath \
    sockets

# OPcache уже встроен в PHP, просто настраиваем его через ini-файл (важно для Octane)
RUN echo "opcache.enable=1" > /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/opcache.ini

# Установка Redis PHP extension
#RUN pecl install redis \
#    && docker-php-ext-enable redis

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка RoadRunner v3.x (официальный способ из документации)
RUN curl --fail --location --output /tmp/roadrunner.tar.gz \
      https://github.com/roadrunner-server/roadrunner/releases/download/v3.0.0/roadrunner-3.0.0-linux-amd64.tar.gz \
    && tar -xzf /tmp/roadrunner.tar.gz --strip-components=1 -C /usr/local/bin roadrunner-3.0.0-linux-amd64/rr \
    && chmod +x /usr/local/bin/rr \
    && rm /tmp/roadrunner.tar.gz

# Рабочая директория
WORKDIR /var/www/html

# Копируем composer файлы для кэширования слоя Docker
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader || true

# Копируем весь исходный код
COPY . .

# Завершаем установку composer (генерация автолоадера)
RUN composer dump-autoload --optimize

# Открываем порты: 8000 для Octane/RR, 8080 для Reverb
EXPOSE 8000 8080

# Команда по умолчанию
CMD ["php", "artisan", "octane:start", "--server=roadrunner", "--host=0.0.0.0", "--port=8000"]
