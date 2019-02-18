DOCKER_TAG = fstk

clean:
	-docker ps -aq | xargs docker rm 
	-docker rmi $(DOCKER_TAG)

build: clean
	docker build -t $(DOCKER_TAG) .

run:
	docker run fstk