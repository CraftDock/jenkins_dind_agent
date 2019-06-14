DOCKER_IMAGE=dsuite/jenkins_dind_agent
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))


build: build-18

test: test-18

build-18:
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-18 \
		--tag $(DOCKER_IMAGE):18 \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):18 $(DOCKER_IMAGE):latest

test-18: build-18
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):18

push-18: build-18
	@docker push $(DOCKER_IMAGE):18
	@docker push $(DOCKER_IMAGE):latest

shell-18: build-18
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-v /var/run/docker.sock:/var/run/docker.sock \
		$(DOCKER_IMAGE):18 \
		bash

remove:
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{}

