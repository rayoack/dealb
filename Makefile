APP := dealbook
HOST_USER := $(shell id -u $$USER):$(shell id -g $$USER)
RUN := docker-compose run --user $(HOST_USER) $(APP)

setup: net
	$(RUN) bin/setup
net:
	@docker network create public 2> /dev/null || true
run:
	@rm -f tmp/pids/server.pid
	docker-compose up
test:
	$(RUN) bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
console:
	$(RUN) bundle exec rails c
bash:
	$(RUN) /bin/bash
clean:
	docker-compose down
	rm -fr ./vendor/bundle

reset: clean setup

%:
	@: # catch all (do nothing)
