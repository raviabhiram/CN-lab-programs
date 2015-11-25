BEGIN {
	tcpDrops = 0.0;
	cbrDrops = 0.0;
	totalTcpSent = 0.0;
	totalCbrSent = 0.0;
} {

	if ($1 == "+" && $3 == "0" && $4 == "2")
		totalTcpSent++;
	if ($1 == "+" && $3 == "1" && $4 == "2")
		totalCbrSent++;

	if ($1 == "d") {
		if ($5 == "tcp")
			tcpDrops++;
		else if ($5 == "cbr")
			cbrDrops++;
	}

} END {

	printf "%-20s : %d\n", "TCP packets sent", totalTcpSent;
	printf "%-20s : %d\n", "TCP packets dropped", tcpDrops;
	printf "%-20s : %d\n", "CBR packets sent", totalCbrSent;
	printf "%-20s : %d\n", "CBR packets dropped", cbrDrops;

	printf "%-20s : %0.3f\n", "TCP Drop Ratio", tcpDrops/totalTcpSent;
	printf "%-20s : %0.3f\n", "CBR Drop Ratio", cbrDrops/totalCbrSent;

	printf "%-20s : %0.3f\n", "TCP Delivery Ratio", (totalTcpSent-tcpDrops)/totalTcpSent;
	printf "%-20s : %0.3f\n", "CBR Delivery Ratio", (totalCbrSent-cbrDrops)/totalCbrSent;
}
