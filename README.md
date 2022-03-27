# Network-Performance
Đánh giá hiệu năng mạng

**Bài 1.** Simple Simulation Example. (_Tham khảo: [http://nile.wpi.edu/NS/simple_ns.html](http://nile.wpi.edu/NS/simple_ns.html)_)

**Bài 2.** Trace Analysis Example. (_Tham khảo: [http://nile.wpi.edu/NS/analysis.html](http://nile.wpi.edu/NS/analysis.html)_)
 
**Bài 3.** Viết script ns-2 mô phỏng topology như sau:
- Tổng số 9 nút mạng (node) thứ tự từ 0 đến 8 với các hướng như hình bên dưới;
- Các liên kết 0-3, 1-3, 2-3: 2Mbps, 5ms;
- Các liên kết 3-4, 4-5: 1.5Mbps, 15ms;
- Các liên kết 5-6, 5-7, 5-8: 10Mbps, 5ms;
- Hàng đợi Q tại 3-4 kiểu DropTail giá trị 50;
- Các cặp gửi/nhận gồm: 0/8, 0/4 1/7, 2/6, cụ thể loại thông lượng như sau:
  - 0 gửi 2 loại dữ liệu TCP (sang node 8) và UDP (sang node 4);
  - 1, 2 gửi dữ liệu TCP;
  - UDP: CBR, 1.5Mbps, kích thước gói tin 1000 bytes;
  - TCP: lưu lượng kiểu FTP, kích thước cửa sổ (window size) = 32.

![image](/images/topology.png)  
**Hình 1.** Topology mạng.

Các hình dưới đây minh họa topology mạng sau khi chạy script TCL.

![image](/images/topology1.png)

![image](/images/topology2.png)

Phân tích kết quả sau khi chạy kịch bản mô phỏng nói trên:
1. Tính thông lượng trung bình của các kết nối (3 kết nối tcp, 1 kết nối udp) tính trong thời gian các kết nối hoạt động (có truyền số liệu của nguồn sinh lưu lượng). (_tham khảo file `avg_throughput_during_sim_time.pl` bên dưới_).
~~~perl
# Usage: perl avg_throughput_during_sim_time.pl <trace file> <flow id> <required node>
$infile=$ARGV[0];
$flow_id=$ARGV[1];
$tonode=$ARGV[2];
$start_time=0;
$end_time=0;
# ---------------------------------------------------------------------------
$sum=0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
	@x = split(' ');
	#checking if the event corresponds to a reception
	if ($x[0] eq 'r' && $x[7] == $flow_id && $x[3] eq $tonode) {
		if ($start_time == 0) {
			$start_time=$x[1];
		}
		$sum=$sum+$x[5];
		$end_time=$x[1];
	}
}
$totaltime = $end_time - $start_time;
$throughput = $sum/$totaltime;
print STDOUT "fid = $flow_id: sum = $sum ; time = $totaltime ; throughput = $throughput\n";
close DATA;
exit 0;
~~~
Trong đó:
- `$sum` là tổng lưu lượng (số byte) nhận được tại node `$tcpnode `
- `<trace file>` là file đầu vào dùng để phân tích (thí dụ: out.tr) 
- `<flow id>` là id của kết nối cần tính thông lượng trung bình (thí dụ với các luồng tcp0:0, tcp1:1, tcp2:2, cbr:3) 
- `<required node>` là node nhận lưu lượng cần tính thông lượng trung bình.

Kết quả thu được có dạng tương tự như bên dưới, throughput có đơn vị là Kbps:
```console
fid = 0: sum = 743640 ; time = 10.258837 ; throughput = 72487.7488549628
fid = 1: sum = 263160 ; time = 10.186517 ; throughput = 25834.149199378
fid = 2: sum = 161240 ; time = 10.042091 ; throughput = 16056.4169354769
fid = 3: sum = 682000 ; time = 5.02976 ; throughput = 135592.950757094
```
Ví dụ: `fid = 0: sum = 743640 ; time = 10.258837 ; throughput = 72487.7488549628`, có nghĩa là kết nối tcp0 từ node s0 đến node s8, có thông lượng trung bình là 72487.7488549628 Kbps

3. Độ trễ trung bình của tất cả các gói tin số liệu của các kết nối trên. (_tham khảo file `avg_delay_during_sim_time.pl` bên dưới_).
~~~perl
# Usage: perl avg_delay_during_sim_time.pl <trace file> <flow id> <source node> <dest node>
$infile=$ARGV[0];
$flow=$ARGV[1];
$src=$ARGV[2];
$dst=$ARGV[3];
@send = (0..0);
@recv = (0..0);
$max_pktid = 0;
$num = 0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
	@x = split(' ');
	$event_ = $x[0];
	$time_ = $x[1];
	$flow_ = $x[7];
	$pkt_ = $x[11];
	$node_ = $x[2] if (($event_ eq "+") || ($event_ eq "s"));
	$node_ = $x[3] if ($event_ eq "r");
	# Ghi thời điểm gửi và nhận từng gói tin vào mảng $send và $rev, $num đếm số gói tin
	if ((($event_ eq "+") || ($event_ eq "s")) && ($flow_ ==
	$flow) && ($node_ == $src) && (!$send[$pkt_])) {
		# Kiem tra (!$send[$pkt_]) dam bao luon tinh goi tin duoc gui lan dau, k tinh goi tin gui lai
		$send[$pkt_] = $time_;
		$max_pktid = $pkt_ if ($max_pktid < $pkt_);
	}
	if (($event_ eq "r") && ($flow_ == $flow) && ($node_ ==	$dst)) {
		$recv[$pkt_] = $time_;
		$num++;
	}
}
close DATA;
# Tính tổng thời gian trễ $delay rồi tính thời gian trễ trung bình của các gói tin $avg_delay
$delay = 0;
for ($count = 0; $count <= $max_pktid; $count ++) {
	if ($send[$count] && $recv[$count]) {
	$send_ = $send[$count];
	$recv_ = $recv[$count];
	$delay = $delay + ($recv_ - $send_);
	}
}
$avg_delay = $delay / $num;
print STDOUT "fid = $flow: avg=$avg_delay\n";
exit 0;
~~~
Kết quả thu được có dạng tương tự như bên dưới, avg  có đơn vị là giây (s):
```console
fid = 0: avg=0.181468615921788
fid = 1: avg=0.214076
fid = 2: avg=0.223630897435897
fid = 3: avg=0.214470928152493
```
Ví dụ: `fid = 0: avg=0.181468615921788`, có nghĩa là kết nối tcp0 có độ trễ trung bình các gói tin là 0.181468615921788 s

4. Tính thông lượng và vẽ đồ thị của các kết nối tính từ khi nhận được gói tin đầu tiên đến thời điểm nhận được từng gói tin tiếp theo. Tham khảo kết quả như hình bên dưới, khi vẽ phải bổ sung đầy đủ thông tin như title, x, y,...
![image](/images/throughput.png)

6. Tính thời gian chờ (waiting time) trung bình của tất cả các gói tin (số liệu) của từng kết nối tại hàng đợi Q.


