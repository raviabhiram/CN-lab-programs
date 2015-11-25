#include<iostream>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<stdio.h>
#include<fcntl.h>

using namespace std;

int main()
{
	int fdr,fdw,fdc,n;
	char buff[256],fname[256];
	if((mkfifo("FIFO1",0777))<0)
	{
		perror("mkfifo");
		return -1;
	}
	if((mkfifo("FIFO2",0777))<0)
	{
		perror("mkfifo");
		return -1;
	}
	cout<<"Fifo files created.\n";
	if((fdr=open("FIFO1",O_RDONLY))<0)
	{
		perror("open");
		return -1;
	}
	if((fdw=open("FIFO2",O_WRONLY))<0)
	{
		perror("open");
		return -1;
	}
	cout<<"Waiting for connection...\n";
	if((n=read(fdr,fname,sizeof(buff)))<0)
	{
		perror("read");
		return -1;
	}
	fname[n]='\0';
	cout<<"Request received for file "<<fname<<endl;
	if((fdc=open(fname,O_RDONLY))<0)
	{
		perror("open");
		return -1;
	}
	while(n=read(fdc,buff,sizeof(buff)))
	{
		buff[n]='\0';
		write(fdw,buff,n);
	}
	cout<<"Data written.\n";
	close(fdr);
	close(fdw);
	close(fdc);
	return 0;
}
