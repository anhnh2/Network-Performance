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

Hình trên minh họa topology mạng sau khi chạy script TCL.

