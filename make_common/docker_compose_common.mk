DOCKER_COMPOSE_RUN=bash $(MAGEN_HELPER)/helper_scripts/docker_compose_run.sh

common_docker_compose_build:
	@docker-compose build

common_docker_compose_rundev:
	@$(DOCKER_COMPOSE_RUN) $(staging_dir)/docker-compose.yml $(service_name) $(port)

common_docker_compose_runpkg:
	@$(DOCKER_COMPOSE_RUN) $(staging_dir)/docker-compose-runpkg.yml $(service_name) $(port)

common_docker_compose_test:
	@docker-compose -f docker-compose-test.yml up --build --abort-on-container-exit
	@$(MAGEN_HELPER)/helper_scripts/docker_compose_status.sh docker-compose-test.yml
