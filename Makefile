# .env 파일 불러오기
include .env
export

# 컨테이너 빌드 & 실행
up:
	@docker compose up -d --build

# 컨테이너 중지 & 네트워크 해제
down:
	@docker compose down

# 로그 확인 (최근 300줄, 실시간 팔로우)
logs:
	@docker compose logs -f --tail=300

# DB 리셋 (컨테이너 + 볼륨 제거 후 재생성)
reset-db:
	@docker compose down -v db
	@docker volume rm $$(docker volume ls -q | grep db_data) || true
	@docker compose up -d db

# 웹 서버 컨테이너 접속 (bash 실행)
sh-web:
	@docker exec -it app-httpd bash

# PHP-FPM 컨테이너 접속 (bash 실행)
sh-php:
	@docker exec -it app-php-fpm bash

# DB 컨테이너 접속 후 mariadb 클라이언트 실행
sh-db:
	@docker exec -it app-mariadb bash -lc 'mariadb -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} $${MYSQL_DATABASE}'

# SQL 덤프 파일 가져와서 DB에 import
db-import:
	@cat dumps/latest.sql | docker exec -i app-mariadb mariadb -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} $${MYSQL_DATABASE}

# DB를 SQL 파일로 dump (날짜_시간 형식 파일명)
db-dump:
	@docker exec app-mariadb mariadb-dump -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} $${MYSQL_DATABASE} > dumps/$(shell date +%F_%H%M)_appdb.sql