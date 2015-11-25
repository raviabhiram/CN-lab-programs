#include<iostream>
#include<string.h>
#include<stdio.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<unistd.h>

using namespace std;

int main(int argc,char** argv)
{
	int sd,n;
	char buffer[256],fname[256];
	struct sockaddr_in address;
	if(argc != 2)
	{
		cout<<"Please specify server ip\n";
		return -1;
	}
	address.sin_family=AF_INET;
	address.sin_port=htons(15000);
	if((inet_pton(AF_INET,argv[1],(struct sockaddr *)&address.sin_addr))<0)
	{
		perror("inet_pton");
		return -1;
	}
	if((sd=socket(AF_INET,SOCK_STREAM,0))<0)
	{
		perror("socket");
		return -1;
	}
	if((connect(sd,(struct sockaddr *)&address,sizeof(address)))<0)
	{
		perror("connect");
		return -1;
	}
	cout<<"Client connected to server.\n";
	cout<<"Enter the file name:- ";
	cin>>fname;
	if((send(sd,fname,strlen(fname),0))<0)
	{
		perror("send");
		return -1;
	}
	cout<<"File contents are:-\n";
	while(n=recv(sd,buffer,sizeof(buffer),0))
		write(1,buffer,n);
	cout<<"\nData read.\n";
	close(sd);
	return 0;
}
