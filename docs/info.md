## How it works

Dự án thực hiện bộ chia số nguyên không dấu 8-bit cho 4-bit dựa trên thuật toán chia khôi phục (Restoring Division).

- **Đầu vào**:
  - Số bị chia 8-bit (`dividend`) truyền qua các chân `ui_in[7:0]`.
  - Số chia 4-bit (`divisor`) truyền qua các chân `uio_in[3:0]`.
- **Đầu ra**:
  - Thương số 4-bit (`quotient`) xuất ra các chân `uo_out[3:0]`.
  - Số dư 4-bit (`remainder`) xuất ra các chân `uo_out[7:4]`.
  - Cờ báo chia cho 0 (`div_by_zero`) xuất ra chân `uio_out[3]`.

Mạch xử lý số bị chia và số chia để tính toán thương số và số dư tương ứng, đồng thời phát hiện và bật cờ báo lỗi khi số chia bằng 0.

## How to test

1. Đưa giá trị số bị chia 8-bit vào `ui_in[7:0]` (ví dụ: `8'd165` = `8'hA5`).
2. Đưa giá trị số chia 4-bit vào `uio_in[3:0]` (ví dụ: `4'd11` = `4'hB`).
3. Quan sát kết quả thu được tại đầu ra:
   - `uo_out[3:0]` hiển thị thương số (15 = `4'hF`).
   - `uo_out[7:4]` hiển thị số dư (0 = `4'h0`).
4. Kiểm tra ca biên chia cho 0: Đưa `uio_in[3:0] = 4'b0000`, quan sát cờ `div_by_zero` tại chân `uio_out[3]` bật lên mức `1`.

## External hardware

Dự án không sử dụng phần cứng bên ngoài. Toàn bộ tín hiệu vào/ra đều kết nối trực tiếp qua bộ khung I/O tiêu chuẩn của Tiny Tapeout.
