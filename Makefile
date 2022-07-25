build:
	sudo docker build -t hermitdocs:v1.0 .
run:
	sudo docker run -p 8080:80 --name hermitdocs -d hermitdocs:v1.0
stop:
	sudo docker stop hermitdocs
remove: stop
	sudo docker rm hermitdocs
	sudo docker rmi hermitdocs:v1.0