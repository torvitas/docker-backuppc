include .env
up:
	docker-compose up -d --build
log:
	docker-compose logs -f --tail=100
ps:
	docker-compose ps
stop:
	docker-compose stop
kill:
	docker-compose kill
build:
	docker-compose build --no-cache
pull:
	docker-compose pull
down:
	docker-compose down -v
public-key:
	docker-compose exec backuppc cat /var/lib/BackupPC/.ssh/id_rsa.pub
