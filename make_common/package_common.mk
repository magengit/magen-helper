KILL_MONGO=bash $(MAGEN_HELPER)/helper_scripts/kill_local_mongo.sh
START_MONGO=bash $(MAGEN_HELPER)/helper_scripts/start_local_mongo.sh
UPLOAD_ARTIFACTS=bash $(MAGEN_HELPER)/helper_scripts/upload_artifacts.sh $(DOCKER_SRC_TAG) $(DOCKER_IMAGE)
RUN_PACKAGE=bash $(MAGEN_HELPER)/helper_scripts/run_pkg_service.sh $(SERVER_NAME)

common_default:
	@echo 'Makefile for $(PACKAGE_NAME)'
	@echo
	@echo 'Usage:'
	@echo '	make clean    		:Remove packages from system and pyc files'
	@echo '	make test     		:Run the test suite'
	@echo '	make package  		:Create Python wheel package'
	@echo '	make install  		:Install Python wheel package'
	@echo '	make all      		:clean->package->install'
	@echo '	make list     		:List of All Magen Dependencies'
	@echo '	make build_docker 	:Pull Base Docker Image and Current Image'
	@echo '	make run_docker   	:Build and Run required Docker containers with mounted source'
	@echo '	make runpkg_docker	:Build and Run required Docker containers with created wheel'
	@echo '	make test_docker  	:Build, Start and Run tests inside main Docker container interactively'
	@echo '	make stop_docker  	:Stop and Remove All running Docker containers'
	@echo '	make clean_docker 	:Remove Docker unused images'
	@echo '	make rm_docker    	:Remove All Docker images if no containers running'
	@echo '	make update		:Update submodules for current GitHub repository'
	@echo '	make doc		:Generate Sphinx API docs'
	@echo
	@echo

start_mongo: stop_docker clean_docker
	@$(START_MONGO)

kill_mongo:
	@$(KILL_MONGO)

common_update:
	@git submodule foreach git pull origin master

common_all: common_update
	$(MAKE) clean
	$(MAKE) uninstall
	$(MAKE) package
	$(MAKE) install

common_clean:
	$(info ************  CLEANING $(PACKAGE_NAME) ************)
	@rm -f dist/*.whl
	@rm -f $(DOCKER_DIR)/*.whl
	$(MAKE) clean_pycache

common_package:
	$(info ************ BUILDING PACKAGE: $(PACKAGE_NAME) ************)
	@cd dist; rm -f $(WHEEl)
	@$(PYTHON) setup.py bdist_wheel
	@cp dist/$(WHEEL) docker_$(PACKAGE_TAG)/

common_install:
	$(info ************ INSTALL $(PACKAGE_NAME) *************)
	@cd dist; $(PIP) install $(WHEEL)
	@$(PIP) show $(PACKAGE_NAME) ; if [ $$? -gt 0 ];\
	    then echo '========== $(PACKAGE_NAME) WAS NOT INSTALLED ========== ';\
	    else echo '========== $(PACKAGE_NAME) INSTALLED =========='; fi

common_upload:
	$(UPLOAD_ARTIFACTS)

uninstall:
	$(info ************ UNINSTALL $(PACKAGE_NAME) *************)
	@$(PIP) show $(PACKAGE_NAME) ; if [ $$? -eq 0 ] ; then $(PIP) uninstall --yes $(PACKAGE_NAME) ; fi

common_list:
	$(info =========== PACKAGES INSTALLED ===========)
	@if [ `$(PIP) list --format=legacy | grep magen | wc -l` -eq 0 ];\
	    then echo "NO PACKAGES";\
	    else $(PIP) list --format=legacy | grep magen; fi

clean_pycache:
	@find . \( -name \*.pyc -o -name \*.pyo -o -name __pycache__ \) -prune -exec rm -rf {} +
	@find . \( -name coverage_html_report \) -prune -exec rm -rf {} +
	@find . \( -name build \) -prune -exec rm -rf {} +
	@find . \( -name \*.egg-info \) -prune -exec rm -rf {} +
	@find . \( -name \magen_logs \) -prune -exec rm -rf {} +
	@find . \( -name \.cache \) -prune -exec rm -rf {} +
	@find . \( -name \htmlcov \) -prune -exec rm -rf {} +

coverage_report:
	@coverage report
	@coverage html

pre_test:
	$(info ==========  PRETEST CLEANING ==========)
	@rm -rf coverage_html_report
	@coverage erase

run_unit_test:
	@sleep 2
	$(info ************  STARTING TESTS ************)
	@$(COVERAGE) $(PYTEST) tests

common_test:
	@$(MAKE) start_mongo
	@$(MAKE) pre_test
	@$(MAKE) run_unit_test
	@$(MAKE) coverage_report

common_test_travis:
	@$(MAKE) pre_test
	@$(MAKE) run_unit_test
	@$(MAKE) coverage_report

clean_test: stop_docker clean_docker
	@$(MAKE) start_mongo
	@$(MAKE) pre_test
	@$(MAKE) run_unit_test
	@$(MAKE) coverage_report

common_run:
	$(RUN_PACKAGE)

check:
	@$(PYTHON) -m flake8

.PHONY:  pre_test coverage_report all build_docker
