#include<iostream>

using namespace std;

struct node{
	int dist[10];
	int nh[10];
}rt[10];

int main()
{
	int dm[10][10],n,i,j,k,flag;
	cout<<"Enter the number of nodes:- ";
	cin>>n;
	cout<<"Enter the distance matrix:-(999 if link doesn't exist)\n";
	for(i=0;i<n;i++)
	{
		dm[i][i]=0;
		for(j=0;j<n;j++)
		{
			cin>>dm[i][j];
			rt[i].dist[j]=dm[i][j];
			rt[i].nh[j]=j;
		}
	}
	cout<<"Calculating routes...\n";
	do
	{
		flag=0;
		for(i=0;i<n;i++)
			for(j=0;j<n;j++)
				if(i!=j)
					for(k=0;k<n;k++)
						if(rt[i].dist[j]>rt[i].dist[k]+rt[k].dist[j])
						{
							rt[i].dist[j]=rt[i].dist[k]+rt[k].dist[j];
							rt[i].nh[j]=k;
							flag++;
						}
	}while(flag != 0);
	cout<<"The routing tables are:-\n";
	for(i=0;i<n;i++)
	{
		cout<<"Routing table for router "<<i+1<<endl;
		cout<<"Source\tDest\tDist\tNextHop\n";
		for(j=0;j<n;j++)
			if(i!=j)
				cout<<i+1<<"\t"<<j+1<<"\t"<<rt[i].dist[j]<<"\t"<<rt[i].nh[j]<<endl;
	}
	return 0;
}
