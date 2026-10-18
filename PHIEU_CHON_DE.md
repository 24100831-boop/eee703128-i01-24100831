# Phiếu chọn đề B2 — in ra, điền, nộp lên LMS

```
HỌ TÊN: Dương Minh Dương	  MSSV: 24100831	  LỚP: EEE703128-1-1-26(N02)
```

---

## Bước 1 — đọc danh mục

Mở `02_De_tai_B2/B2_DANH_MUC_DE_TAI_VA_RUBRIC.html` (hoặc phần "80 phiếu đề" trong lab guide).
Cả hai đều có **bộ lọc** theo nhóm và độ khó.

## Bước 2 — hiểu nhóm mình định chọn

| Nhóm | Chủ đề | Số đề | Loại |
|---|---|---|---|
| **A** | Số học tổ hợp (cộng, trừ, so sánh) | 9 | tổ hợp |
| **B** | Mã hoá, giải mã, chuyển đổi mã | 9 | tổ hợp |
| **C** | Ngưỡng, cảnh báo, giám sát | 7 | 3 tổ hợp + 4 tuần tự |
| **D** | Bộ đếm và chia tần | 7 | tuần tự |
| **E** | Thanh ghi dịch, xử lý chuỗi bit | 7 | tuần tự |
| **F** | Máy trạng thái hữu hạn (FSM) | 10 | tuần tự |
| **G** | Xử lý tín hiệu số đơn giản | 7 | tuần tự |
| **H** | Giao tiếp nối tiếp (UART, SPI, I2C) | 7 | tuần tự |
| **I** | Số học nâng cao (chia, căn, Booth) | 5 | tuần tự |
| **J** | Đề khó — nhiều khối, bắt tay, đường ống | 12 | tuần tự · **khó** |

**Nhóm nào cũng đủ điểm tối đa.** Rubric thưởng **chất lượng đọc hiểu**, không thưởng độ khó của đề.

### Ba gợi ý thật lòng

* **Muốn chắc chắn, bám sát đúng thứ đã học trên lớp** → **nhóm C**. Case của học phần
  (`threshold_alarm`) chính là nhóm này; bài mẫu A và B áp thẳng vào.
* **Muốn báo cáo có chiều sâu để ăn điểm cao** → **nhóm G**. Nhóm duy nhất cho phép chạy **hai
  phương án** rồi so sánh bằng số đo thật.
* **Thích làm việc với tín hiệu và waveform** → **nhóm H**. Nhóm duy nhất waveform là bằng chứng chính.

> ⚠️ **Nhóm J chỉ chọn nếu em đã chạy CI xanh trước tuần 11.** Chọn J vì nghĩ "khó thì điểm cao"
> là hiểu sai rubric — và thường kết thúc bằng một bài làm dở cả ba yêu cầu.

## Bước 3 — điền phiếu
```
ĐỀ SỐ: I01

TÊN ĐỀ: Bộ chia số nguyên 8-bit cho 4-bit theo thuật toán khôi phục

NHÓM: I         LOẠI:  ☐ tổ hợp     ☑ tuần tự

EM CHỌN ĐỀ NÀY VÌ: Muốn tìm hiểu thuật toán chia tuần tự và cách thiết kế khối số học nâng cao.

___________________________________________________________________________
```

> Một câu *"vì ..."* đó là bắt buộc. Nó cho thầy biết em đã đọc đề thật hay chỉ chọn theo số.

## Bước 4 — trước khi bắt tay vào làm, tự trả lời ba câu

```
① Mạch của em CÓ NHỚ không?         ☑ có   ☐ không

   Vì sao em biết? Mạch là bộ chia tuần tự thực hiện phép chia khôi phục qua 8 chu kỳ xung nhịp.

② Em ĐOÁN thiết kế của em sẽ ra:    280–390 linh kiện (cell)   23–26 ô nhớ (FF)

③ "Câu phân tích riêng" của đề em hỏi gì? Chép lại nguyên văn:

   Phép chia là phép tốn kém nhất trong số học số. So sánh diện tích thiết kế này với bộ nhân cùng cỡ (đề A05 hoặc I03) và nêu tỉ lệ; giải thích vì sao chia đắt hơn nhân.

   ________________________________________________________________________
```

Ba câu này là **ba câu đầu tiên thầy hỏi khi gặp riêng**. Ghi sẵn thì em không bị bất ngờ — và
quan trọng hơn: **con số em đoán trước, so với con số thật, chính là chỗ em học được nhiều nhất.**

---

## Lịch B2 — ghi vào sổ

| Tuần | Việc | Hạn |
|---|---|---|
| **10** | Chọn đề, nộp phiếu này | ____/____ |
| **11–12** | **Nộp ảnh chụp một lần chạy CI xanh** với thiết kế mẫu (chỉ đạt/không đạt, không tính điểm) | ____/____ |
| **12** | Gặp mentor nếu chưa có CI xanh | ____/____ |
| **13** | Nộp thử — kiểm 4 tiêu chí tái lập | ____/____ |
| **15** | Nộp bản cuối + trình bày | ____/____ |

> Mốc tuần 11–12 **không tính điểm** nhưng là mốc quan trọng nhất của cả tuyến. Nó bảo đảm em
> không tới tuần 14 mới phát hiện mình chưa từng chạy được lần nào.

---

*EEE703128 · v2.3 · 15/09/2026 · Giảng viên phụ trách: Đinh Văn Nam*
