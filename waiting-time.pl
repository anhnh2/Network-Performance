#type: perl waitingtime.pl <tracefile> <flow_id> <required_node>
$infile=$ARGV[0];
$flow=$ARGV[1];
$qnode = $ARGV[2];
$avg_wait = 0;
@enqueued = (0..0);
@dequeued = (0..0);
$max_pktid = 0;
$num = 0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
	@x = split(' ');
	$event_ = $x[0];
	$time_ = $x[1];
	$pkt_ = $x[11];
	$flow_ = $x[7];
	$node_ = $x[3] if ($event_ eq "+");
	$node_ = $x[2] if ($event_ eq "-");
	if (($event_ eq "+") && ($x[3] == $qnode) && ($flow_ == $flow) && (!$enqueued[$pkt_]) ) {
		$enqueued[$pkt_] = $time_;
		$max_pktid = $pkt_ if ($max_pktid < $pkt_);
	}
	if (($event_ eq "-") && ($flow_ == $flow) && ($x[2] == $qnode) ) {
		$dequeued[$pkt_] = $time_;
		$num++;		
	}
}

$delay = 0;
for ($count = 0; $count <= $max_pktid; $count ++) {
	if ($enqueued[$count] && $dequeued[$count]) {
		$enqueued_ = $enqueued[$count];
		$dequeued_ = $dequeued[$count];
		$avg_wait = $avg_wait + ($dequeued_ - $enqueued_);
	}
}

$waitingtime = 0;
if ($num>0){
$waitingtime = $avg_wait/$num;
}

print (" max_pktid=", $max_pktid, "\n");
print (" Waitingtime=", $avg_wait, "\n");
print (" Flow Id=", $flow, "\n");
print (" Packet Nums=", $num, "\n");
print (" Avg Waitingtime=", $waitingtime, " (s)\n");
