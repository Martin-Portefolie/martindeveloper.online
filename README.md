```sh
# 1. Start Docker and build the containers
docker compose up --build -d #(only on install)
docker compose up  -d #(if already installed)

# 2. Install dependencies
docker compose exec php composer install  #(only on install)

# 3. Migrate the database
docker compose exec php bin/console doctrine:migrations:migrate  #(only on install)

# 4. Load fixtures
docker compose exec php bin/console doctrine:fixtures:load

# 5.create admin
docker compose exec php bin/console create-user                

# 5. Start Tailwind CSS compilation
docker compose exec php bin/console tailwind:build --watch --poll
```
