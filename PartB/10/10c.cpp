#include<iostream>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<stdio.h>
#include<fcntl.h>
#include<string.h>

using namespace std;

int main()
{
	int fdr,fdw,fdc,n;
	char fname[256],buff[256];
	if((fdw=open("FIFO1",O_WRONLY))<0)
	{
		perror("open");
		return -1;
	}
	if((fdr=open("FIFO2",O_RDONLY))<0)
	{
		perror("open");
		return -1;
	}
	cout<<"Enter the file name:- ";
	cin>>fname;
	if((write(fdw,fname,strlen(fname)))<0)
	{
		perror("write");
		return -1;
	}
	while(n=read(fdr,buff,sizeof(buff)))
	{
		buff[n]='\0';
		if((write(1,buff,n))<0)
		{
			perror("write");
			return -1;
		}
	}
	close(fdr);
	close(fdw);
	close(fdc);
	return 0;
}
