DOCKER_COMPOSE_RUN=$(MAGEN_HELPER)/helper_scripts/docker_compose_run.sh
DOCKER_COMPOSE_UP=$(MAGEN_HELPER)/helper_scripts/docker_compose_up_wrapper.sh

common_docker_compose_build:
	@docker-compose build

common_docker_compose_rundev:
	@$(DOCKER_COMPOSE_RUN) $(staging_dir)/docker-compose.yml $(mkcmn_docker_compose_service_name) $(mkcmn_docker_compose_service_port)

common_docker_compose_runpkg:
	@$(DOCKER_COMPOSE_RUN) $(staging_dir)/docker-compose-runpkg.yml $(mkcmn_docker_compose_service_name) $(mkcmn_docker_compose_service_port)

common_docker_compose_test:
	@$(DOCKER_COMPOSE_UP) -f docker-compose-test.yml up --build --abort-on-container-exit
	@$(MAGEN_HELPER)/helper_scripts/docker_compose_status.sh docker-compose-test.yml
