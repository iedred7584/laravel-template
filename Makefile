create:
	@composer create-project --prefer-dist laravel/laravel project
	@cd project && cat .gitignore >> ../.gitignore && rm .gitignore
	@cd project && mv -n * .* ../
	@rm -rf project
	@sed -ie "s/DB_HOST=127.0.0.1/DB_HOST=mysql/" .env
	@sed -ie "s/DB_USERNAME=root/DB_USERNAME=laravel/" .env
	@$(eval PASSWORD := $(shell curl -s uuid.jp))
	@sed -ie "s/DB_PASSWORD=/DB_PASSWORD=${PASSWORD}/" .env
	@rm .enve
	@composer require laravel/ui
	@php artisan ui vue
add_auth:
	@docker-compose exec php php artisan ui vue --auth
	@docker-compose restart
run:
	@docker-compose up -d
	@docker-compose exec php php artisan key:generate
	@docker-compose exec php php artisan storage:link
	@echo "\n\n------------------------------------------------------\n"
	@echo "The container has been created and started."
	@echo "Waiting for preparing MySQL."
	@printf "\e[?25l"
	@for i in $$(seq -w 120 0); do \
		printf "\e[1G--- $$i s ---"; \
		sleep 1; \
	done
	@echo "\n\n------------------------------------------------------\n\n"
	@printf "\e[?25h"
	@make migrate
migrate:
	@docker-compose exec php php artisan migrate
