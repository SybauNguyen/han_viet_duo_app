import 'dart:math';

import 'han_character.dart';
import 'question.dart';

const List<HanCharacter> seedCharacters = [
  HanCharacter(character: '一', hanVietReading: 'nhất', meaning: 'một', radical: '一', structure: 'Đơn thể', difficulty: 1, examples: ['Nhất định', 'Thống nhất']),
  HanCharacter(character: '二', hanVietReading: 'nhị', meaning: 'hai', radical: '二', structure: 'Đơn thể', difficulty: 1, examples: ['Nhị phân', 'Nhịp']),
  HanCharacter(character: '三', hanVietReading: 'tam', meaning: 'ba', radical: '一', structure: 'Đơn thể', difficulty: 1, examples: ['Tam giác', 'Tam quan']),
  HanCharacter(character: '人', hanVietReading: 'nhân', meaning: 'người', radical: '人', structure: 'Đơn thể', difficulty: 1, examples: ['Nhân loại', 'Nhân dân']),
  HanCharacter(character: '大', hanVietReading: 'đại', meaning: 'to lớn', radical: '大', structure: 'Đơn thể', difficulty: 1, examples: ['Đại học', 'Vĩ đại']),
  HanCharacter(character: '小', hanVietReading: 'tiểu', meaning: 'nhỏ bé', radical: '小', structure: 'Đơn thể', difficulty: 1, examples: ['Tiểu học', 'Tiểu đội']),
  HanCharacter(character: '中', hanVietReading: 'trung', meaning: 'ở giữa, bên trong', radical: '丨', structure: 'Đơn thể', difficulty: 1, examples: ['Trung tâm', 'Trung gian']),
  HanCharacter(character: '日', hanVietReading: 'nhật', meaning: 'mặt trời, ngày', radical: '日', structure: 'Đơn thể', difficulty: 1, examples: ['Nhật ký', 'Nhật nguyệt']),
  HanCharacter(character: '月', hanVietReading: 'nguyệt', meaning: 'mặt trăng, tháng', radical: '月', structure: 'Đơn thể', difficulty: 1, examples: ['Nguyệt thực', 'Nhật nguyệt']),
  HanCharacter(character: '山', hanVietReading: 'sơn', meaning: 'núi', radical: '山', structure: 'Đơn thể', difficulty: 2, examples: ['Sơn hà', 'Sơn thủy']),
  HanCharacter(character: '水', hanVietReading: 'thủy', meaning: 'nước', radical: '水', structure: 'Đơn thể', difficulty: 2, examples: ['Thủy điện', 'Thủy ngân']),
  HanCharacter(character: '木', hanVietReading: 'mộc', meaning: 'cây, gỗ', radical: '木', structure: 'Đơn thể', difficulty: 2, examples: ['Thảo mộc', 'Mộc bản']),
  HanCharacter(character: '火', hanVietReading: 'hỏa', meaning: 'lửa', radical: '火', structure: 'Đơn thể', difficulty: 2, examples: ['Hỏa lực', 'Hỏa hoạn']),
  HanCharacter(character: '心', hanVietReading: 'tâm', meaning: 'trái tim, tâm trí', radical: '心', structure: 'Đơn thể', difficulty: 2, examples: ['Tâm lý', 'Tâm hồn']),
  HanCharacter(character: '學', hanVietReading: 'học', meaning: 'học tập', radical: '子', structure: 'Trên dưới', difficulty: 3, examples: ['Học sinh 學生', 'Đại học 大學']),
  HanCharacter(character: '生', hanVietReading: 'sinh', meaning: 'sinh ra, sống', radical: '生', structure: 'Đơn thể', difficulty: 3, examples: ['Sinh viên', 'Sinh nhật']),
  HanCharacter(character: '忠', hanVietReading: 'trung', meaning: 'trung thành', radical: '心', structure: 'Trên dưới: 中 + 心', difficulty: 3, examples: ['Trung thành 忠誠', 'Trung thần 忠臣']),
  HanCharacter(character: '休', hanVietReading: 'hưu', meaning: 'nghỉ ngơi', radical: '亻', structure: 'Trái phải: 亻 + 木', difficulty: 3, examples: ['Hưu trí', 'Hưu chiến']),
  HanCharacter(character: '明', hanVietReading: 'minh', meaning: 'sáng, rõ', radical: '日', structure: 'Trái phải: 日 + 月', difficulty: 3, examples: ['Thông minh', 'Văn minh']),
  HanCharacter(character: '林', hanVietReading: 'lâm', meaning: 'rừng', radical: '木', structure: 'Trái phải: 木 + 木', difficulty: 3, examples: ['Lâm nghiệp', 'Sơn lâm']),
  HanCharacter(character: '好', hanVietReading: 'hảo', meaning: 'tốt, đẹp', radical: '女', structure: 'Trái phải: 女 + 子', difficulty: 3, examples: ['Hảo hán', 'Hảo ý']),
  HanCharacter(character: '語', hanVietReading: 'ngữ', meaning: 'lời nói, ngôn ngữ', radical: '言', structure: 'Trái phải', difficulty: 3, examples: ['Ngôn ngữ', 'Thành ngữ']),
  HanCharacter(character: '國', hanVietReading: 'quốc', meaning: 'nước, quốc gia', radical: '囗', structure: 'Bao quanh', difficulty: 3, examples: ['Quốc gia', 'Tổ quốc']),
  HanCharacter(character: '愛', hanVietReading: 'ái', meaning: 'yêu thương', radical: '心', structure: 'Trên dưới', difficulty: 3, examples: ['Ái quốc', 'Bác ái']),
  HanCharacter(character: '家', hanVietReading: 'gia', meaning: 'nhà, gia đình', radical: '宀', structure: 'Trên dưới', difficulty: 3, examples: ['Gia đình', 'Quốc gia']),

  // --- BO SUNG: SO DEM ---
  HanCharacter(character: '四', hanVietReading: 'tứ', meaning: 'bốn', radical: '囗', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '五', hanVietReading: 'ngũ', meaning: 'năm', radical: '二', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '六', hanVietReading: 'lục', meaning: 'sáu', radical: '八', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '七', hanVietReading: 'thất', meaning: 'bảy', radical: '一', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '八', hanVietReading: 'bát', meaning: 'tám', radical: '八', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '九', hanVietReading: 'cửu', meaning: 'chín', radical: '乙', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '十', hanVietReading: 'thập', meaning: 'mười', radical: '十', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '百', hanVietReading: 'bách', meaning: 'trăm', radical: '白', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '千', hanVietReading: 'thiên', meaning: 'nghìn', radical: '十', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '萬', hanVietReading: 'vạn', meaning: 'mười nghìn', radical: '艸', structure: 'Chưa bổ sung', difficulty: 3),

  // --- PHUONG HUONG VA VI TRI ---
  HanCharacter(character: '東', hanVietReading: 'đông', meaning: 'phía đông', radical: '木', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '西', hanVietReading: 'tây', meaning: 'phía tây', radical: '襾', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '南', hanVietReading: 'nam', meaning: 'phía nam', radical: '十', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '北', hanVietReading: 'bắc', meaning: 'phía bắc', radical: '匕', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '左', hanVietReading: 'tả', meaning: 'bên trái', radical: '工', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '右', hanVietReading: 'hữu', meaning: 'bên phải', radical: '口', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '前', hanVietReading: 'tiền', meaning: 'phía trước', radical: '刀', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '後', hanVietReading: 'hậu', meaning: 'phía sau', radical: '彳', structure: 'Chưa bổ sung', difficulty: 3),
  HanCharacter(character: '上', hanVietReading: 'thượng', meaning: 'bên trên', radical: '一', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '下', hanVietReading: 'hạ', meaning: 'bên dưới', radical: '一', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '內', hanVietReading: 'nội', meaning: 'bên trong', radical: '入', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '外', hanVietReading: 'ngoại', meaning: 'bên ngoài', radical: '夕', structure: 'Chưa bổ sung', difficulty: 2),

  // --- TU NHIEN ---
  HanCharacter(character: '天', hanVietReading: 'thiên', meaning: 'trời', radical: '大', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '地', hanVietReading: 'địa', meaning: 'đất', radical: '土', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '風', hanVietReading: 'phong', meaning: 'gió', radical: '風', structure: 'Chưa bổ sung', difficulty: 3),
  HanCharacter(character: '雨', hanVietReading: 'vũ', meaning: 'mưa', radical: '雨', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '雲', hanVietReading: 'vân', meaning: 'mây', radical: '雨', structure: 'Chưa bổ sung', difficulty: 3),
  HanCharacter(character: '雪', hanVietReading: 'tuyết', meaning: 'tuyết', radical: '雨', structure: 'Chưa bổ sung', difficulty: 3),
  HanCharacter(character: '電', hanVietReading: 'điện', meaning: 'điện, sấm chớp', radical: '雨', structure: 'Chưa bổ sung', difficulty: 3),
  HanCharacter(character: '星', hanVietReading: 'tinh', meaning: 'ngôi sao', radical: '日', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '草', hanVietReading: 'thảo', meaning: 'cỏ', radical: '艸', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '花', hanVietReading: 'hoa', meaning: 'bông hoa', radical: '艸', structure: 'Chưa bổ sung', difficulty: 2),

  // --- GIA DINH VA CON NGUOI ---
  HanCharacter(character: '男', hanVietReading: 'nam', meaning: 'đàn ông, con trai', radical: '田', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '女', hanVietReading: 'nữ', meaning: 'phụ nữ, con gái', radical: '女', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '父', hanVietReading: 'phụ', meaning: 'cha, bố', radical: '父', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '母', hanVietReading: 'mẫu', meaning: 'mẹ', radical: '毋', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '子', hanVietReading: 'tử', meaning: 'con cái', radical: '子', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '兄', hanVietReading: 'huynh', meaning: 'anh trai', radical: '儿', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '弟', hanVietReading: 'đệ', meaning: 'em trai', radical: '弓', structure: 'Chưa bổ sung', difficulty: 2),

  // --- BO PHAN CO THE ---
  HanCharacter(character: '目', hanVietReading: 'mục', meaning: 'con mắt', radical: '目', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '耳', hanVietReading: 'nhĩ', meaning: 'lỗ tai', radical: '耳', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '口', hanVietReading: 'khẩu', meaning: 'cái miệng', radical: '口', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '手', hanVietReading: 'thủ', meaning: 'bàn tay', radical: '手', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '足', hanVietReading: 'túc', meaning: 'cái chân', radical: '足', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '頭', hanVietReading: 'đầu', meaning: 'cái đầu', radical: '頁', structure: 'Chưa bổ sung', difficulty: 3),

  // --- DONG TU VA TINH TU ---
  HanCharacter(character: '來', hanVietReading: 'lai', meaning: 'đến, lại', radical: '人', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '去', hanVietReading: 'khứ', meaning: 'đi', radical: '厶', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '出', hanVietReading: 'xuất', meaning: 'đi ra', radical: '凵', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '入', hanVietReading: 'nhập', meaning: 'đi vào', radical: '入', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '多', hanVietReading: 'đa', meaning: 'nhiều', radical: '夕', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '少', hanVietReading: 'thiểu', meaning: 'ít', radical: '小', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '新', hanVietReading: 'tân', meaning: 'mới', radical: '斤', structure: 'Chưa bổ sung', difficulty: 3),
  HanCharacter(character: '古', hanVietReading: 'cổ', meaning: 'cũ, xưa', radical: '口', structure: 'Chưa bổ sung', difficulty: 2),
  HanCharacter(character: '白', hanVietReading: 'bạch', meaning: 'màu trắng', radical: '白', structure: 'Chưa bổ sung', difficulty: 1),
  HanCharacter(character: '黑', hanVietReading: 'hắc', meaning: 'màu đen', radical: '黑', structure: 'Chưa bổ sung', difficulty: 3),


  // --- DONG VAT ---
  HanCharacter(character: '犬', hanVietReading: 'khuyển', meaning: 'con chó', radical: '犬', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '貓', hanVietReading: 'miêu', meaning: 'con mèo', radical: '豸', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '馬', hanVietReading: 'mã', meaning: 'con ngựa', radical: '馬', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '牛', hanVietReading: 'ngưu', meaning: 'con trâu, con bò', radical: '牛', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '羊', hanVietReading: 'dương', meaning: 'con dê, cừu', radical: '羊', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '鳥', hanVietReading: 'điểu', meaning: 'con chim', radical: '鳥', structure: 'Đơn thể', difficulty: 3),
  HanCharacter(character: '魚', hanVietReading: 'ngư', meaning: 'con cá', radical: '魚', structure: 'Đơn thể', difficulty: 3),
  HanCharacter(character: '蟲', hanVietReading: 'trùng', meaning: 'côn trùng', radical: '虫', structure: 'Đơn thể', difficulty: 3),
  HanCharacter(character: '龍', hanVietReading: 'long', meaning: 'con rồng', radical: '龍', structure: 'Đơn thể', difficulty: 3),

  // --- MAU SAC: 日/月 da co trong bo du lieu nen khong tao ban ghi trung ---
  HanCharacter(character: '青', hanVietReading: 'thanh', meaning: 'màu xanh', radical: '青', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '黃', hanVietReading: 'hoàng', meaning: 'màu vàng', radical: '黃', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '赤', hanVietReading: 'xích', meaning: 'màu đỏ', radical: '赤', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '綠', hanVietReading: 'lục', meaning: 'màu xanh lá', radical: '糸', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '藍', hanVietReading: 'lam', meaning: 'màu xanh lam', radical: '艸', structure: 'Trên dưới', difficulty: 3),
  HanCharacter(character: '紫', hanVietReading: 'tử', meaning: 'màu tím', radical: '糸', structure: 'Trên dưới', difficulty: 3),

  // --- HANH DONG CO BAN ---
  HanCharacter(character: '走', hanVietReading: 'tẩu', meaning: 'chạy, đi bộ', radical: '走', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '飛', hanVietReading: 'phi', meaning: 'bay', radical: '飛', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '游', hanVietReading: 'du', meaning: 'bơi lội, đi chơi', radical: '水', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '看', hanVietReading: 'khán', meaning: 'nhìn, xem', radical: '目', structure: 'Trên dưới: 手 + 目', difficulty: 2),
  HanCharacter(character: '聽', hanVietReading: 'thính', meaning: 'nghe', radical: '耳', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '說', hanVietReading: 'thuyết', meaning: 'nói', radical: '言', structure: 'Trái phải', difficulty: 2),
  HanCharacter(character: '讀', hanVietReading: 'độc', meaning: 'đọc', radical: '言', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '寫', hanVietReading: 'tả', meaning: 'viết', radical: '宀', structure: 'Trên dưới', difficulty: 3),
  HanCharacter(character: '食', hanVietReading: 'thực', meaning: 'ăn, thức ăn', radical: '食', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '飲', hanVietReading: 'ẩm', meaning: 'uống', radical: '食', structure: 'Trái phải', difficulty: 3),

  // --- CAM XUC VA TRANG THAI; 愛 da co san ---
  HanCharacter(character: '恨', hanVietReading: 'hận', meaning: 'ghét, hận', radical: '心', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '喜', hanVietReading: 'hỷ', meaning: 'vui vẻ', radical: '口', structure: 'Trên dưới', difficulty: 3),
  HanCharacter(character: '怒', hanVietReading: 'nộ', meaning: 'tức giận', radical: '心', structure: 'Trên dưới', difficulty: 3),
  HanCharacter(character: '哀', hanVietReading: 'ai', meaning: 'đau buồn', radical: '口', structure: 'Trên dưới', difficulty: 3),
  HanCharacter(character: '樂', hanVietReading: 'lạc', meaning: 'vui thú, âm nhạc', radical: '木', structure: 'Trên dưới', difficulty: 3),
  HanCharacter(character: '苦', hanVietReading: 'khổ', meaning: 'đắng, khổ cực', radical: '艸', structure: 'Trên dưới', difficulty: 2),
  HanCharacter(character: '甜', hanVietReading: 'điềm', meaning: 'ngọt', radical: '甘', structure: 'Trái phải', difficulty: 3),

  // --- THOI GIAN; 日 va 月 da co san ---
  HanCharacter(character: '年', hanVietReading: 'niên', meaning: 'năm', radical: '干', structure: 'Đơn thể', difficulty: 1),
  HanCharacter(character: '時', hanVietReading: 'thời', meaning: 'thời gian, giờ', radical: '日', structure: 'Trái phải', difficulty: 2),
  HanCharacter(character: '分', hanVietReading: 'phân', meaning: 'phút, chia ra', radical: '刀', structure: 'Trên dưới', difficulty: 2),
  HanCharacter(character: '秒', hanVietReading: 'miểu', meaning: 'giây', radical: '禾', structure: 'Trái phải', difficulty: 3),
  HanCharacter(character: '今', hanVietReading: 'kim', meaning: 'hiện tại, nay', radical: '人', structure: 'Trên dưới', difficulty: 1),
  HanCharacter(character: '昔', hanVietReading: 'tích', meaning: 'ngày xưa', radical: '日', structure: 'Trên dưới', difficulty: 3),

  // --- DO VAT GAN GUI: them de mo rong nhom bo thu ---
  HanCharacter(character: '門', hanVietReading: 'môn', meaning: 'cửa', radical: '門', structure: 'Bao quanh', difficulty: 2),
  HanCharacter(character: '車', hanVietReading: 'xa', meaning: 'xe cộ', radical: '車', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '金', hanVietReading: 'kim', meaning: 'vàng, kim loại', radical: '金', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '石', hanVietReading: 'thạch', meaning: 'đá', radical: '石', structure: 'Trên dưới', difficulty: 1),
  HanCharacter(character: '田', hanVietReading: 'điền', meaning: 'ruộng', radical: '田', structure: 'Đơn thể', difficulty: 1),
  HanCharacter(character: '竹', hanVietReading: 'trúc', meaning: 'tre', radical: '竹', structure: 'Đơn thể', difficulty: 2),
  HanCharacter(character: '米', hanVietReading: 'mễ', meaning: 'gạo', radical: '米', structure: 'Đơn thể', difficulty: 2),

];

const List<LessonUnit> lessonUnits = [
  LessonUnit(
    title: 'Nét chữ đầu tiên',
    subtitle: 'Số đếm và con người',
    characters: ['一', '二', '三', '人', '大'],
    icon: '🌱',
  ),
  LessonUnit(
    title: 'Thế giới quanh ta',
    subtitle: 'Kích thước, mặt trời và mặt trăng',
    characters: ['小', '中', '日', '月', '山'],
    icon: '🌤️',
  ),
  LessonUnit(
    title: 'Thiên nhiên & tâm trí',
    subtitle: 'Nước, cây, lửa và trái tim',
    characters: ['水', '木', '火', '心', '明'],
    icon: '🌳',
  ),
  LessonUnit(
    title: 'Ghép chữ thành ý',
    subtitle: 'Học tập, con người và lòng trung thành',
    characters: ['學', '生', '忠', '休', '林'],
    icon: '📚',
  ),
  LessonUnit(
    title: 'Từ vựng thường gặp',
    subtitle: 'Ngôn ngữ, quốc gia, tình yêu và gia đình',
    characters: ['好', '語', '國', '愛', '家'],
    icon: '🏮',
  ),

  LessonUnit(
    title: 'Những con số tiếp theo',
    subtitle: 'Từ bốn đến tám',
    characters: ['四', '五', '六', '七', '八'],
    icon: '🔢',
  ),
  LessonUnit(
    title: 'Số lớn',
    subtitle: 'Chín, mười, trăm, nghìn và vạn',
    characters: ['九', '十', '百', '千', '萬'],
    icon: '🧮',
  ),
  LessonUnit(
    title: 'Đông Tây Nam Bắc',
    subtitle: 'Phương hướng và bên trái',
    characters: ['東', '西', '南', '北', '左'],
    icon: '🧭',
  ),
  LessonUnit(
    title: 'Vị trí quanh ta',
    subtitle: 'Phải, trước, sau, trên và dưới',
    characters: ['右', '前', '後', '上', '下'],
    icon: '📍',
  ),
  LessonUnit(
    title: 'Trong và ngoài',
    subtitle: 'Vị trí, trời, đất và gió',
    characters: ['內', '外', '天', '地', '風'],
    icon: '🌏',
  ),
  LessonUnit(
    title: 'Thời tiết',
    subtitle: 'Mưa, mây, tuyết, điện và sao',
    characters: ['雨', '雲', '雪', '電', '星'],
    icon: '🌦️',
  ),
  LessonUnit(
    title: 'Cây cỏ và gia đình',
    subtitle: 'Cỏ, hoa, nam, nữ và cha',
    characters: ['草', '花', '男', '女', '父'],
    icon: '🌼',
  ),
  LessonUnit(
    title: 'Người thân và giác quan',
    subtitle: 'Mẹ, con, anh, em và mắt',
    characters: ['母', '子', '兄', '弟', '目'],
    icon: '👨‍👩‍👧‍👦',
  ),
  LessonUnit(
    title: 'Bộ phận cơ thể',
    subtitle: 'Tai, miệng, tay, chân và đầu',
    characters: ['耳', '口', '手', '足', '頭'],
    icon: '🧍',
  ),
  LessonUnit(
    title: 'Động tác cơ bản',
    subtitle: 'Đến, đi, ra, vào và nhiều',
    characters: ['來', '去', '出', '入', '多'],
    icon: '🚶',
  ),
  LessonUnit(
    title: 'Mới, cũ và màu sắc',
    subtitle: 'Ít, mới, xưa, trắng và đen',
    characters: ['少', '新', '古', '白', '黑'],
    icon: '🎨',
  ),


  LessonUnit(
    title: 'Động vật gần gũi',
    subtitle: 'Chó, mèo, ngựa, trâu và dê',
    characters: ['犬', '貓', '馬', '牛', '羊'],
    icon: '🐾',
  ),
  LessonUnit(
    title: 'Chim, cá và linh vật',
    subtitle: 'Chim, cá, côn trùng, rồng và màu xanh',
    characters: ['鳥', '魚', '蟲', '龍', '青'],
    icon: '🐉',
  ),
  LessonUnit(
    title: 'Sắc màu',
    subtitle: 'Vàng, đỏ, xanh lá, xanh lam và tím',
    characters: ['黃', '赤', '綠', '藍', '紫'],
    icon: '🎨',
  ),
  LessonUnit(
    title: 'Những hành động đầu tiên',
    subtitle: 'Chạy, bay, bơi, nhìn và nghe',
    characters: ['走', '飛', '游', '看', '聽'],
    icon: '🏃',
  ),
  LessonUnit(
    title: 'Nói, đọc, viết và ăn',
    subtitle: 'Các hoạt động thường ngày',
    characters: ['說', '讀', '寫', '食', '飲'],
    icon: '✍️',
  ),
  LessonUnit(
    title: 'Cảm xúc',
    subtitle: 'Hận, hỷ, nộ, ai và lạc',
    characters: ['恨', '喜', '怒', '哀', '樂'],
    icon: '💭',
  ),
  LessonUnit(
    title: 'Vị đắng và thời gian',
    subtitle: 'Khổ, điềm, niên, thời và phân',
    characters: ['苦', '甜', '年', '時', '分'],
    icon: '⏳',
  ),
  LessonUnit(
    title: 'Thời gian và cánh cửa',
    subtitle: 'Giây, hiện tại, ngày xưa, cửa và xe',
    characters: ['秒', '今', '昔', '門', '車'],
    icon: '🚪',
  ),
  LessonUnit(
    title: 'Đồ vật và thiên nhiên',
    subtitle: 'Kim loại, đá, ruộng, tre và gạo',
    characters: ['金', '石', '田', '竹', '米'],
    icon: '🌾',
  ),

];

HanCharacter? findCharacter(String value) {
  for (final character in seedCharacters) {
    if (character.character == value) return character;
  }
  return null;
}

List<HanCharacter> charactersForUnit(int unitIndex) {
  final safeIndex = unitIndex.clamp(0, lessonUnits.length - 1) as int;
  final unit = lessonUnits[safeIndex];
  return unit.characters.map(findCharacter).whereType<HanCharacter>().toList();
}

List<Question> generateQuestions(List<HanCharacter> lessonCharacters) {
  final random = Random();
  final part1Radicals = <Question>[];
  final part2Characters = <Question>[];
  final part3Typing = <Question>[];

  final allRadicals = seedCharacters.map((c) => c.radical).toSet().toList();
  const fallbackRadicals = <String>['一', '人', '心', '水', '木', '火', '口', '日', '手', '目'];

  List<String> optionsFor(String answer, Iterable<String> candidates) {
    final pool = candidates.toSet().where((value) => value.trim().isNotEmpty).toList();
    if (!pool.contains(answer)) pool.add(answer);
    for (final fallback in fallbackRadicals) {
      if (pool.length >= 4) break;
      if (fallback != answer && !pool.contains(fallback)) pool.add(fallback);
    }
    final distractors = pool.where((value) => value != answer).toList()..shuffle(random);
    final options = <String>[answer, ...distractors.take(3)]..shuffle(random);
    return options;
  }

  final readings = seedCharacters.map((c) => c.hanVietReading).toSet();
  final symbols = seedCharacters.map((c) => c.character).toSet();

  for (final character in lessonCharacters) {
    // PHAN 1: NHAN DIEN BO THU
    part1Radicals.add(Question(
      type: QuestionType.radical,
      sectionTitle: 'Phần 1: Nhận diện Bộ thủ',
      prompt: 'Bộ thủ của chữ này là gì?',
      options: optionsFor(character.radical, allRadicals),
      correctAnswer: character.radical,
      associatedCharacter: character.character,
    ));

    // PHAN 2: HOC AM, CHU VA NGHIA
    part2Characters.add(Question(
      type: QuestionType.reading,
      sectionTitle: 'Phần 2: Học Âm & Nghĩa',
      prompt: 'Âm Hán-Việt của chữ này là gì?',
      options: optionsFor(character.hanVietReading, readings),
      correctAnswer: character.hanVietReading,
      associatedCharacter: character.character,
    ));

    part2Characters.add(Question(
      type: QuestionType.character,
      sectionTitle: 'Phần 2: Học Âm & Nghĩa',
      prompt: 'Chọn chữ Hán phù hợp với nghĩa bên dưới.',
      options: optionsFor(character.character, symbols),
      correctAnswer: character.character,
      associatedCharacter: character.character,
    ));

    if (character.character == '學') {
      part2Characters.add(Question(
        type: QuestionType.fillInTheBlank,
        sectionTitle: 'Phần 2: Học Âm & Nghĩa',
        prompt: 'Chọn chữ còn thiếu để tạo thành từ ghép “học sinh”.',
        options: optionsFor('生', const ['生', '日', '山', '水']),
        correctAnswer: '生',
        associatedCharacter: character.character,
        sentenceTokens: const [
          SentenceToken(text: '學', hanVietReading: 'học', meaning: 'học tập'),
          SentenceToken(text: '生', isBlank: true),
        ],
      ));
    }

    // PHAN 3: CHU DONG GO NHO AM HAN-VIET HOAC NGHIA
    part3Typing.add(Question(
      type: QuestionType.typing,
      sectionTitle: 'Phần 3: Kiểm tra trí nhớ',
      prompt: 'Gõ âm Hán-Việt hoặc nghĩa của chữ:',
      options: const [],
      correctAnswer: character.hanVietReading,
      acceptedAnswers: [
        character.hanVietReading.toLowerCase(),
        character.meaning.toLowerCase(),
      ],
      associatedCharacter: character.character,
    ));
  }

  part1Radicals.shuffle(random);
  part2Characters.shuffle(random);
  part3Typing.shuffle(random);

  // Khong tron ca danh sach de giu dung thu tu 3 phan.
  return [...part1Radicals, ...part2Characters, ...part3Typing];
}
