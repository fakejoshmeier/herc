#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <arpa/inet.h>

/*
** Resources:
** http://www.unixguide.net/network/socketfaq/4.3.shtml
** https://www.binarytides.com/socket-programming-c-linux-tutorial/
*/

void termination_handler (int signum){
	signal (signum, termination_handler);
}

static void pantalaimon(){
	pid_t pid = fork();
	if (pid < 0){
		perror("Can't forking do it. ");
		exit(1);
	}
	else if (pid == 0){
		close(STDIN_FILENO);
		close(STDOUT_FILENO);
		close(STDERR_FILENO);
		if (setsid() == -1){
			perror("The Power of Juicy Crust compels you! ");
			exit(1);
		}
	}
}

int main(int ac, char **av){
	struct sockaddr_in servaddr;
	int listen_fd, return_fd;
	char str[100]

	if (ac == 1){
		perror("USAGE: ./server [-D flag] PORT-NUMBER\n-D is a flag to set the server as a daemon. ");
		exit(1);
	}
	if (ac >= 3 && !strcmp(av[1], "-D")){
		pantalaimon();
		if (signal (SIGTERM, termination_handler) == SIG_IGN)
    		signal (SIGTERM, SIG_IGN);
     	signal (SIGINT, SIG_IGN);
     	signal (SIGHUP, SIG_IGN);
	}
	listen_fd = socket(AF_INET, SOCK_STREAM, 0);
	if (listen_fd == -1){
		perror("Failed to create socket.  So socket. ");
		exit(1);
	}
	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htons(INADDR_ANY);
	if (ac == 2)
		servaddr.sin_port = htons(atoi(av[1]));
	else if (ac == 3)
		servaddr.sin_port = htons(atoi(av[2]));
	bind(listen_fd, (struct sockaddr *) &servaddr, sizeof(servaddr));
	listen(listen_fd, 10);
	return_fd = accept(listen_fd, (struct sockaddr*)NULL, NULL);
	while (1){
		bzero(str, 100);
		read(return_fd, str, 100);
		if (str)
			dprintf(return_fd, "pong\npong\n");
	}
	return (0);
}