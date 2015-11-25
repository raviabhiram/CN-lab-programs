set ns [new Simulator]
set tr [open 3.tr w]
set nf [open 3.nam w]

$ns trace-all $tr
$ns namtrace-all $nf

set intervaltime 0.045

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns color 1 "Red"
$ns color 2 "Green"
$ns color 3 "Blue"
$ns color 4 "Yellow"

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail
$ns duplex-link $n3 $n5 2Mb 10ms DropTail


$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient left-down
$ns duplex-link-op $n2 $n3 orient down
$ns duplex-link-op $n3 $n4 orient left-down
$ns duplex-link-op $n3 $n5 orient right-down

set ping0 [new Agent/Ping]
set ping1 [new Agent/Ping]
set ping4 [new Agent/Ping]
set ping5 [new Agent/Ping]

$ns queue-limit $n2 $n3 10

$ns attach-agent $n0 $ping0
$ns attach-agent $n1 $ping1
$ns attach-agent $n4 $ping4
$ns attach-agent $n5 $ping5

$ns connect $ping0 $ping5
$ns connect $ping1 $ping4
#$ns connect $ping4 $ping0
#$ns connect $ping5 $ping1

$ping0 set class_ 1
$ping1 set class_ 2
$ping4 set class_ 3
$ping5 set class_ 4

proc finish {} {
	global ns nf tr
	$ns flush-trace
	exit 0
}
proc sendpingpacket {} {
	global ns intervaltime ping0 ping1 ping4 ping5
	set now [$ns now]
	$ns at [expr $now+$intervaltime] "$ping0 send"
	$ns at [expr $now+$intervaltime] "$ping1 send"
	$ns at [expr $now+$intervaltime] "$ping4 send"
	$ns at [expr $now+$intervaltime] "$ping5 send"
	$ns at [expr $now+$intervaltime] "sendpingpacket"
}

set seq 1
Agent/Ping instproc recv {from rtt} {
	global seq
	$self instvar node_
	puts "64 bytes from [$node_ id] icmp_seq=$seq ttl=64 time=$rtt ms"
	set seq [expr $seq +1]
}

$ns at 0.01 "sendpingpacket"
$ns rtmodel-at 3.0 down $n2 $n3
$ns rtmodel-at 5.0 up $n2 $n3
$ns at 10.0 "finish"

$ns run
