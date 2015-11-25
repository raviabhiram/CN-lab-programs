#include<iostream>

using namespace std;

int minimum(int a, int b)
{
	if(a<b)
		return a;
	return b;
}

int main()
{
	int size,rate,load=0,i,time,packets[10],drop;
	cout<<"Enter the size of the bucket:- ";
	cin>>size;
	cout<<"Enter the duration of simulation:- ";
	cin>>time;
	cout<<"Enter the output rate(packets per second):- ";
	cin>>rate;
	cout<<"Enter incoming packet sizes:-\n";
	for(i=0;i<time;i++)
	{
		cout<<"Packet at time "<<i+1<<"s:- ";
		cin>>packets[i];
	}
	cout<<"Time\tPcktRcv\tPktCnf\tOLoad\tPcktSnt\tPcktDrp\tNLoad\n";
	for(i=0;i<time;i++)
	{
		drop=0;
		load+=packets[i];
		cout<<i+1<<"\t"<<packets[i]<<"\t";
		if(load>size)
		{
			drop=load-size;
			load=size;
		}
		cout<<packets[i]-drop<<"\t"<<load<<"\t";
//		else
//		{
			cout<<minimum(load,rate)<<"\t";
			load-=rate;
			if(load<0)
				load=0;
//		}
		cout<<drop<<"\t"<<load<<endl;
	}
	return 0;
}
