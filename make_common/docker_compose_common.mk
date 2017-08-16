DOCKER_COMPOSE_RUN=bash $(MAGEN_HELPER)/helper_scripts/docker_compose_run.sh
DOCKER_COMPOSE_UP=bash $(MAGEN_HELPER)/helper_scripts/docker_compose_up_wrapper.sh

common_docker_compose_build:
	@docker-compose build

common_docker_compose_rundev:
	@$(DOCKER_COMPOSE_RUN) $(staging_dir)/docker-compose.yml $(service_name) $(port)

common_docker_compose_runpkg:
	@$(DOCKER_COMPOSE_RUN) $(staging_dir)/docker-compose-runpkg.yml $(service_name) $(port)

common_docker_compose_test:
	@$(DOCKER_COMPOSE_UP) -f docker-compose-test.yml up --build --abort-on-container-exit
	@$(MAGEN_HELPER)/helper_scripts/docker_compose_status.sh docker-compose-test.yml
