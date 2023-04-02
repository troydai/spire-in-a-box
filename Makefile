.PHONY: image

up: # image
	@ docker-compose up

down:
	@ docker-compose down

key:
	@ scripts/keys/gen.sh