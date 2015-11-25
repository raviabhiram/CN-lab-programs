#include<iostream>
#include<string.h>

#define N strlen(g)

using namespace std;

char s,t[128],cs[128],g[]="10001000000100001";
int a,e,c;

void xori()
{
	for(c=1;c<N;c++)
	{
		if(cs[c]==g[c])
			cs[c]='0';
		else
			cs[c]='1';
	}
}

void crc()
{
	for(e=0;e<N;e++)
		cs[e]=t[e];
	do
	{
		if(cs[0]=='1')
			xori();
		for(c=0;c<N-1;c++)
			cs[c]=cs[c+1];
		cs[c]=t[e++];
	}while(e<=a+N-1);
}

int main()
{
	cout<<"Enter the polynomial:- ";
	cin>>t;
	cout<<"The generating polynomial is:- "<<g<<endl;
	a=strlen(t);
	for(e=a;e<a+N-1;e++)
		t[e]='0';
	cout<<"Updated message is:- "<<t<<endl;
	crc();
	cout<<"Checksum is:- "<<cs<<endl;
	for(c=a;c<a+N-1;c++)
		t[c]=cs[c-a];
	cout<<"Transmitted message is:- "<<t<<endl;
	cout<<"Test error detection? (y or n): ";
	cin>>s;
	if(s=='y')
	{
		cout<<"Enter the position to insert an error:- ";
		cin>>e;
		t[e]=(t[e]=='0')?'1':'0';
		cout<<"Erronous message is:- "<<t<<endl;
	}
	crc();
	for(e=0;(e<N-1) && cs[e]!='1';e++)
	{
	}
	if(e<N-1)
		cout<<"Error Detected\n";
	else
		cout<<"No error detected\n";
	return 0;
}
