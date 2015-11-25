#!/usr/bin/awk -f

BEGIN {
	cbrRcvd=0;
	totRcvd=0;
	ftpRcvd=0;
	throughPut=0.0;
}
{
	if(($1=="+") && ($3=="5") && ($4=="4") && ($5=="cbr"))
		cbrRcvd++;
	if(($1=="+") && ($3=="4") && ($4=="5") && ($5=="tcp"))
		ftpRcvd++;
	totRcvd=cbrRcvd+ftpRcvd;
}
END {
	throughPut=((totRcvd*500*8)/(8000000));
	printf "the throughput is %f\n",throughPut;
	printf "the cbr is %f\n",cbrRcvd;
	printf "the ftp is %f\n",ftpRcvd;
}
