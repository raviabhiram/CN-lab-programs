#include<iostream>
#include<math.h>
#include<string.h>
#include<stdlib.h>

using namespace std;

int cipher[128],len,a,b,m,n,z,x;

int prime(int num)
{
	for(int i=2;i<=sqrt(num);i++)
		if(num%i==0)
			return 0;
	return 1;
}

int gcd(int d, int e)
{
	if(d==0)
		return e;
	if(e==0)
		return d;
	return (gcd(e,d%e));
}

int encode(char ch)
{
	int temp=ch;
	for(int i=1;i<m;i++)
		temp=(temp*ch)%x;
	return temp;
}

char decode(int ch)
{
	int temp=ch;
	for(int i=1;i<n;i++)
		ch=(temp*ch)%x;
	return ch;
}

int main()
{
	char msg[128];
	cout<<"Enter the message:- ";
	cin>>msg;
	len=strlen(msg);
	do
	{
		a=rand()%30;
	}while(!prime(a));
	do
	{
		b=rand()%30;
	}while(!prime(b));
	x=a*b;
	z=(a-1)*(b-1);
	do
	{
		m=rand()%z;
	}while(gcd(m,z)!=1);
	do
	{
		n=rand()%z;
	}while(((m*n)%z)!=1);
	int i;
	cout<<"Cipher text:- ";
	for(i=0;i<len;i++)
	{
		cipher[i]=encode(msg[i]);
		cout<<cipher[i];
	}
	cipher[i]='\0';
	cout<<endl;
	cout<<"Decrypted message:- ";
	for(i=0;i<len;i++)
	{
		msg[i]=decode(cipher[i]);
		cout<<msg[i];
	}
	msg[i]='\0';
	cout<<endl;
	return 0;
}
