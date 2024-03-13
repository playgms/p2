set ns [new Simulator]
set nf [open p2.nam w]
$ns namtrace-all $nf
set tf [open p2.tr w]
$ns trace-all $tf
set cwind [open win2.tr w]

for {set i 1} {$i<=6} {incr i} {
set n$i [$ns node]
}

set duplex-link $n1 $n3 2Mb 2ms DropTail
set duplex-link $n2 $n3 2Mb 2ms DropTail
set duplex-link $n3 $n4 2Mb 2ms DropTail
set duplex-link $n4 $n5 2Mb 2ms DropTail
set duplex-link $n4 $n6 2Mb 2ms DropTail


set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n6 $sink0
$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink1 [new Agent/TCPSink1]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1

$ns ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns at 1.0 "$ftp start"

$ns tel [new Application/Telnet]
$tel attach-agent $tcp1
$ns at 1.1 "$tel start"

proc plotwindow {tcpsource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd0 [$tcpsource set cwnd_]
puts $file "$now $cwnd0"
$ns at [expr $time+$now] plotwindow "$tcpsource $file"
}
$ns at 2.0 "plotwindow $tcp0 $cwind"
$ns at 4.0 "plotwindow $tcp1 $cwind"

proc finish{} {
global ns tf nf cwind
$ns flush-trace 
close $tf
close $nf
exec nam p2.nam & 
exec xgraph win2.tr &
exit 0
}
$ns run







