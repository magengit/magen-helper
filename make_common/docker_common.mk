STOP_DOCKER=bash $(MAGEN_HELPER)/helper_scripts/docker_stop.sh
CLEAN_DOCKER=bash $(MAGEN_HELPER)/helper_scripts/docker_clean.sh
PULL_BASE_DOCKER=cd $(MAGEN_HELPER)/helper_scripts && bash download_base_docker.sh
REMOVE_DOCKERS=bash $(MAGEN_HELPER)/helper_scripts/docker_rm_all_images.sh

common_clean_docker:
	@$(CLEAN_DOCKER)

common_stop_docker:
	@$(STOP_DOCKER)

common_rm_docker:
	@$(STOP_DOCKER)
	@$(REMOVE_DOCKERS)

docker_dependencies:
	$(MAKE) clean
	$(MAKE) package
	@$(PULL_BASE_DOCKER)

common_build_docker: docker_dependencies
	$(MAKE) kill_mongo
	@cd docker_$(PACKAGE_TAG) && $(MAKE) docker_compose_build
	$(MAKE) stop_docker

common_test_docker: common_stop_docker
	@cd docker_$(PACKAGE_TAG) && $(MAKE) docker_compose_test
	$(MAKE) stop_docker
	$(MAKE) clean_docker

common_run_docker: common_clean_docker
	@cd docker_$(PACKAGE_TAG) && $(MAKE) docker_compose_rundev

common_runpkg_docker: common_clean_docker
	@cd docker_$(PACKAGE_TAG) && $(MAKE) docker_compose_runpkg
