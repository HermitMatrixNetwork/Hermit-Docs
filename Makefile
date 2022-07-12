git_book:
	gitbook serve
build: git_book
	sudo docker build -t hermitdocs:v1.0 .
run:
	sudo docker run -p 8081:80 --name hermitdocs -d hermitdocs:v1.0
stop:
	sudo docker stop hermitdocs