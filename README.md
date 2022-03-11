# Network-Performance
Đánh giá hiệu năng mạng

Viết script ns-2 mô phỏng topology như sau:
- Tổng số 9 nút mạng (node) thứ tự từ 0 đến 8 với các hướng như hình bên dưới;
- Các liên kết 0-3, 1-3, 2-3: 2Mbps, 5ms;
- Các liên kết 3-4, 4-5: 1.5Mbps, 15ms;
- Các liên kết 5-6, 5-7, 5-8: 10Mbps, 5ms;
- Hàng đợi tại 3-4 kiểu DropTail giá trị 50;
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
1. Tính thông lượng trung bình của các kết nối (3 kết nối tcp, 1 kết nối udp) tính trong thời gian các kết nối hoạt động (có truyền số liệu của nguồn sinh lưu lượng).
2. Độ trễ trung bình của tất cả các gói tin số liệu của các kết nối trên.
3. Tính thông lượng và vẽ đồ thị của các kết nối tính từ khi nhận được gói tin đầu tiên đến thời điểm nhận được từng gói tin tiếp theo.
4. Tính thời gian chờ (waiting time) trung bình của tất cả các gói tin (số liệu) của từng kết nối tại hàng đợi Q.


