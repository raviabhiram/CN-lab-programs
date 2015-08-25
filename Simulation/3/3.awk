#!/usr/bin/awk -f

BEGIN {
	pktdrop = 0;
}
{
	if($1=="d")
		pktdrop++;
}
END {
	print("Total packets dropped= ",pktdrop);
}
