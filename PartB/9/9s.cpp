#include<iostream>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<stdio.h>
#include<arpa/inet.h>
#include<fcntl.h>
#include<sys/stat.h>

using namespace std;

int main()
{
	int sd,csd,n,fd;
	char buff[256],fname[256];
	struct sockaddr_in address;
	address.sin_family=AF_INET;
	address.sin_port=htons(15000);
	address.sin_addr.s_addr=INADDR_ANY;
	if((sd=socket(AF_INET,SOCK_STREAM,0))<0)
	{
		perror("socket");
		return -1;
	}
	cout<<"Socket created\n";
	if((bind(sd,(struct sockaddr *)&address,sizeof(address)))<0)
	{
		perror("bind");
		return -1;
	}
	cout<<"Socket bound to address\n";
	if((listen(sd,3))<0)
	{
		perror("listen");
		return -1;
	}
	cout<<"Waiting for a connection...\n";
	socklen_t size=sizeof(address);
	if((csd=accept(sd,(struct sockaddr *)&address,&size))<0)
	{
		perror("accept");
		return -1;
	}
	cout<<"Connected to client...\n";
	if((n=recv(csd,fname,sizeof(fname),0))<0)
	{
		perror("recv");
		return -1;
	}
	cout<<"File name received:- "<<fname<<endl;
	if((fd=open(fname,O_RDONLY))<0)
	{
		perror("open");
		return -1;
	}
	while(n=read(fd,buff,sizeof(buff)))
	{
		if((send(csd,buff,sizeof(buff),0))<0)
		{
			perror("send");
			return -1;
		}
	}
	cout<<"Data Sent.\n";
	close(csd);
	close(sd);
	return 0;
}
