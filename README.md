Slot machine:
1. deposit : owner gọi để nạp tiền vào contract làm nguồn tiền thưởng
2. spin: Người chơi tham gian quay slot cần chuyển số tiền quy định (coinPrice đang để là mặc định là 1000wei ). Gọi hàm spin với input là loại slot muốn so kết quả chọn. Có 5 loại so slot có thể chọn tương ứng số từ 0->4 : 
- Đường ngang trên cùng-0
- Đường ngang giữa-1
- Đường ngang dưới-2
- Đường chéo trên từ trái qua qua phải -3
- Đường chéo trên từ phải qua trái-4
3. cashout: owner gọi hàm này để rút hết tiền trong contract
2. balanceOf: Người chơi kiểm tra số tiền thắng cược chưa rút 
3. withdraw: người chơi gọi hàm này để rút tiền thưởng của mình về ví 
4. setCoinPrice: chỉ owner có thể gọi hàm này để sửa lại coinprice mới
5. checkBalance: để owner kiểm tra số dư của contract
6. so quay ra trung : tu 1 den 5 thi tien thuong x2 lan so x 1000wei

