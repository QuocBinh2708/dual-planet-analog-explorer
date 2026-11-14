-- ========================================================
-- SUPABASE SETUP SCRIPT FOR KRONOS-SIM ANALOG EXPLORER
-- 12 SITES EXPANDED DATASET (NASA 4-PARAMETER ESI MODEL)
-- Project URL: https://prhngciivgzoarwoburu.supabase.co
-- ========================================================

-- 1. TẠO BẢNG analog_sites NẾU CHƯA CÓ
create table if not exists public.analog_sites (
  id text primary key,
  name_vi text not null,
  name_en text not null,
  short_label text not null,
  body_type text default 'moon',
  is_vietnam boolean default false,
  is_baseline boolean default false,
  is_custom boolean default false,
  earth_lat double precision not null,
  earth_lon double precision not null,
  earth_zoom integer default 11,
  planet_lat double precision not null,
  planet_lon double precision not null,
  planet_zoom integer default 7,
  planet_site_name text not null,
  target_vi text not null,
  target_en text not null,
  mineral_score numeric not null default 0.85,
  earth_mineral text,
  planet_mineral text,
  earth_slope numeric not null default 10.0,
  planet_slope numeric not null default 12.0,
  earth_temp_k numeric not null default 295.0,
  planet_temp_k numeric not null default 252.0,
  earth_pressure_kpa numeric not null default 95.0,
  planet_pressure_kpa numeric not null default 0.0,
  geology_vi text,
  geology_en text,
  limits_vi text,
  limits_en text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Tự động bổ sung các cột NASA mới nếu bảng đã được tạo trước đó
alter table public.analog_sites add column if not exists mineral_score numeric;
alter table public.analog_sites add column if not exists earth_mineral text;
alter table public.analog_sites add column if not exists planet_mineral text;
alter table public.analog_sites add column if not exists earth_slope numeric;
alter table public.analog_sites add column if not exists planet_slope numeric;
alter table public.analog_sites add column if not exists earth_temp_k numeric;
alter table public.analog_sites add column if not exists planet_temp_k numeric;
alter table public.analog_sites add column if not exists earth_pressure_kpa numeric;
alter table public.analog_sites add column if not exists planet_pressure_kpa numeric;

-- 2. BẬT BẢO MẬT HÀNG (ROW LEVEL SECURITY)
alter table public.analog_sites enable row level security;

-- 3. CẤP QUYỀN ĐỌC / GHI CHO WEBSITE
drop policy if exists "Allow public read access" on public.analog_sites;
create policy "Allow public read access"
  on public.analog_sites for select to anon, authenticated using (true);

drop policy if exists "Allow public insert access" on public.analog_sites;
create policy "Allow public insert access"
  on public.analog_sites for insert to anon, authenticated with check (true);

drop policy if exists "Allow public update access" on public.analog_sites;
create policy "Allow public update access"
  on public.analog_sites for update to anon, authenticated using (true) with check (true);

drop policy if exists "Allow public delete access" on public.analog_sites;
create policy "Allow public delete access"
  on public.analog_sites for delete to anon, authenticated using (true);

-- 4. DỌN SẠCH CÁC DÒNG CŨ ĐỂ ĐỒNG BỘ CHUẨN 12 ĐỊA ĐIỂM
delete from public.analog_sites where is_custom = false or id in ('chubluk', 'boulby', 'dallol', 'iceland', 'qaidam');

-- 5. NẠP TOÀN BỘ 12 ĐIỂM DỮ LIỆU ĐẦY ĐỦ VÀO DATABASE
insert into public.analog_sites (
  id, name_vi, name_en, short_label, body_type, is_vietnam, is_baseline, is_custom,
  earth_lat, earth_lon, earth_zoom,
  planet_lat, planet_lon, planet_zoom, planet_site_name,
  target_vi, target_en,
  mineral_score, earth_mineral, planet_mineral,
  earth_slope, planet_slope,
  earth_temp_k, planet_temp_k,
  earth_pressure_kpa, planet_pressure_kpa,
  geology_vi, geology_en, limits_vi, limits_en
) values
(
  'krongno', '1. Krông Nô – Chư Bluk (Việt Nam)', '1. Krông Nô – Chư Bluk (Việt Nam)', '🇻🇳 Krông Nô', 'moon', true, false, false,
  12.518, 107.905, 13,
  14.0, -56.0, 7, 'Marius Hills (Moon)',
  'MẶT TRĂNG (MARIUS HILLS)', 'MẶT TRĂNG (MARIUS HILLS)',
  0.9, 'Basalt (FeO 12%)', 'Mare Basalt (FeO 17%)',
  9.0, 9.5,
  296.6, 253.0,
  96.0, 0.0,
  'Hệ thống hang động ống dung nham dài nhất Đông Nam Á (>25 km, 50+ hang) tại Công viên Địa chất Đắk Nông. Trần vòm bazan dày giữ nhiệt độ ổn định (20–22°C / 295 K), che chắn bức xạ vũ trụ, lý tưởng để thử nghiệm robot tự hành SLAM và căn cứ ngầm.', 'Hệ thống hang động ống dung nham dài nhất Đông Nam Á (>25 km, 50+ hang) tại Công viên Địa chất Đắk Nông. Trần vòm bazan dày giữ nhiệt độ ổn định (20–22°C / 295 K), che chắn bức xạ vũ trụ, lý tưởng để thử nghiệm robot tự hành SLAM và căn cứ ngầm.', 'Khí hậu nhiệt đới gió mùa gây phong hóa hóa học bề mặt; trọng lực 1g (gấp 6 lần Mặt Trăng) và không có môi trường chân không.', 'Khí hậu nhiệt đới gió mùa gây phong hóa hóa học bề mặt; trọng lực 1g (gấp 6 lần Mặt Trăng) và không có môi trường chân không.'
),
(
  'lanzarote', '2. Đảo Lanzarote (Tây Ban Nha)', '2. Đảo Lanzarote (Tây Ban Nha)', '🇪🇸 Lanzarote', 'mars', false, false, false,
  28.9583, -13.7667, 11,
  -11.5, -121.0, 7, 'Arsia Mons Skylights (Mars)',
  'SAO HỎA (ARSIA MONS)', 'SAO HỎA (ARSIA MONS)',
  0.83, 'Basalt, Olivine, Pyroxene, Volcanic Ash', 'Martian Basalt, Olivine, Pyroxene',
  12.0, 15.0,
  294.0, 252.0,
  100.0, 0.6,
  'Địa hình núi lửa trẻ thuộc Công viên Quốc gia Timanfaya với các dòng chảy dung nham bazan, nón núi lửa và ống dung nham. Phục vụ thử nghiệm độ bám bánh xe rover, lập bản đồ địa chất núi lửa và công nghệ thám hiểm hang ngầm hành tinh (ESA PANGEA).', 'Địa hình núi lửa trẻ thuộc Công viên Quốc gia Timanfaya với các dòng chảy dung nham bazan, nón núi lửa và ống dung nham. Phục vụ thử nghiệm độ bám bánh xe rover, lập bản đồ địa chất núi lửa và công nghệ thám hiểm hang ngầm hành tinh (ESA PANGEA).', 'Khí hậu hải đảo, độ ẩm không khí, sự xâm lấn sinh học và phong hóa mặt đất khác biệt đáng kể so với môi trường khô lạnh, áp suất thấp của Sao Hỏa.', 'Khí hậu hải đảo, độ ẩm không khí, sự xâm lấn sinh học và phong hóa mặt đất khác biệt đáng kể so với môi trường khô lạnh, áp suất thấp của Sao Hỏa.'
),
(
  'meteor_crater', '3. Meteor Crater (Arizona, Mỹ)', '3. Meteor Crater (Arizona, Mỹ)', '🇺🇸 Meteor Crater', 'mars', false, false, false,
  35.027, -111.022, 14,
  -5.4, 137.8, 7, 'Gale Crater Rim (Mars)',
  'SAO HỎA (HỐ GALE)', 'SAO HỎA (HỐ GALE)',
  0.88, 'Impact-Brecciated Sandstone, Limestone, Shocked Minerals', 'Martian Impact Breccia, Basalt, Regolith',
  18.0, 15.0,
  285.0, 252.0,
  95.0, 0.6,
  'Hố va chạm thiên thạch hình thành khoảng 50.000 năm trước trong đá trầm tích bởi thiên thạch sắt-niken, đường kính ~1.2 km. Lưu giữ vật liệu đá biến chất va chạm và lớp ejecta, hữu ích để nghiên cứu hố va chạm và cấu trúc địa chất Sao Hỏa.', 'Hố va chạm thiên thạch hình thành khoảng 50.000 năm trước trong đá trầm tích bởi thiên thạch sắt-niken, đường kính ~1.2 km. Lưu giữ vật liệu đá biến chất va chạm và lớp ejecta, hữu ích để nghiên cứu hố va chạm và cấu trúc địa chất Sao Hỏa.', 'Khí quyển Trái Đất, xói mòn, phong hóa và trọng lực 1g khác với Sao Hỏa. Đá mục tiêu chủ yếu là sa thạch/đá vôi trầm tích thay vì lớp vỏ bazan Sao Hỏa.', 'Khí quyển Trái Đất, xói mòn, phong hóa và trọng lực 1g khác với Sao Hỏa. Đá mục tiêu chủ yếu là sa thạch/đá vôi trầm tích thay vì lớp vỏ bazan Sao Hỏa.'
),
(
  'craters_moon', '4. Craters of the Moon (Idaho, Mỹ)', '4. Craters of the Moon (Idaho, Mỹ)', '🇺🇸 Craters of Moon', 'moon', false, false, false,
  43.371, -113.493, 12,
  26.1, 3.6, 7, 'Hadley Rille - Apollo 15 (Moon)',
  'MẶT TRĂNG (HADLEY RILLE)', 'MẶT TRĂNG (HADLEY RILLE)',
  0.91, 'Basalt, Picro-Basalt, Scoria, Volcanic Glass', 'Mare Basalt, Pyroxene, Olivine',
  10.0, 14.0,
  282.0, 253.0,
  80.0, 0.0,
  'Cánh đồng núi lửa bazan rộng lớn chứa hơn 60 dòng dung nham, nón xỉ và khe nứt phun trào. Rất phù hợp để thử nghiệm di chuyển xe rover, lấy mẫu bazan và lập bản đồ các dòng chảy dung nham Mặt Trăng.', 'Cánh đồng núi lửa bazan rộng lớn chứa hơn 60 dòng dung nham, nón xỉ và khe nứt phun trào. Rất phù hợp để thử nghiệm di chuyển xe rover, lấy mẫu bazan và lập bản đồ các dòng chảy dung nham Mặt Trăng.', 'Khí quyển Trái Đất, tuyết theo mùa, hoạt động sinh học và phong hóa do nước làm biến đổi bề mặt dung nham; trọng lực lớn hơn Mặt Trăng 6 lần.', 'Khí quyển Trái Đất, tuyết theo mùa, hoạt động sinh học và phong hóa do nước làm biến đổi bề mặt dung nham; trọng lực lớn hơn Mặt Trăng 6 lần.'
),
(
  'lamayuru', '5. Thung lũng Lamayuru (Ladakh, Ấn Độ)', '5. Thung lũng Lamayuru (Ladakh, Ấn Độ)', '🇮🇳 Lamayuru', 'mars', false, false, false,
  34.28, 76.77, 12,
  -24.0, -33.3, 7, 'Eberswalde Crater (Mars)',
  'SAO HỎA (EBERSWALDE)', 'SAO HỎA (EBERSWALDE)',
  0.72, 'Sedimentary Rocks, Clay Minerals, Sulfates, Sandstone', 'Martian Basalt, Clay-Bearing Sediments',
  14.0, 15.0,
  280.0, 252.0,
  65.0, 0.6,
  'Cảnh quan khô hạn trên cao nguyên độ cao lớn (''Moonland'') với các cấu trúc trầm tích lòng hồ cổ đại bị xói mòn mạnh và các tầng địa chất lộ thiên. Thích hợp thử nghiệm dẫn đường rover và giải mã địa hình trầm tích ngập nước cổ trên Sao Hỏa.', 'Cảnh quan khô hạn trên cao nguyên độ cao lớn (''Moonland'') với các cấu trúc trầm tích lòng hồ cổ đại bị xói mòn mạnh và các tầng địa chất lộ thiên. Thích hợp thử nghiệm dẫn đường rover và giải mã địa hình trầm tích ngập nước cổ trên Sao Hỏa.', 'Lượng mưa theo mùa, tuyết, nước lỏng và điều kiện khí quyển Trái Đất tác động đến xói mòn và độ kết dính bề mặt.', 'Lượng mưa theo mùa, tuyết, nước lỏng và điều kiện khí quyển Trái Đất tác động đến xói mòn và độ kết dính bề mặt.'
),
(
  'namib', '6. Moon Landscape (Sa mạc Namib, Namibia)', '6. Moon Landscape (Sa mạc Namib, Namibia)', '🇳🇦 Namib', 'mars', false, false, false,
  -22.68986, 14.79036, 11,
  -5.1, 137.8, 7, 'Bagnold Dunes - Gale (Mars)',
  'SAO HỎA (CỒN CÁT BAGNOLD)', 'SAO HỎA (CỒN CÁT BAGNOLD)',
  0.76, 'Weathered Bedrock, Quartz, Feldspar, Desert Sediments', 'Martian Regolith, Basalt, Iron Oxides',
  13.0, 15.0,
  291.0, 252.0,
  99.0, 0.6,
  'Cảnh quan khô hạn đặc trưng bởi địa hình bị xói mòn sâu, bề mặt đá trơ trụi và các tầng trầm tích cổ. Hữu ích cho nghiên cứu quá trình phong hóa gió aeolian, hình thái bề mặt, dẫn đường robot và lập bản đồ sa mạc Sao Hỏa.', 'Cảnh quan khô hạn đặc trưng bởi địa hình bị xói mòn sâu, bề mặt đá trơ trụi và các tầng trầm tích cổ. Hữu ích cho nghiên cứu quá trình phong hóa gió aeolian, hình thái bề mặt, dẫn đường robot và lập bản đồ sa mạc Sao Hỏa.', 'Hơi ẩm khí quyển ven biển, vận chuyển trầm tích do bão cát và mưa rào không thường xuyên tác động đến bề mặt.', 'Hơi ẩm khí quyển ven biển, vận chuyển trầm tích do bão cát và mưa rào không thường xuyên tác động đến bề mặt.'
),
(
  'atacama', '⭐ 7. Valle de la Luna (Atacama, Chile)', '⭐ 7. Valle de la Luna (Atacama, Chile)', '⭐ Atacama', 'mars', false, true, false,
  -22.96, -68.28, 11,
  -0.2, -5.5, 7, 'Meridiani Planum (Mars)',
  'CHUẨN MÔ PHỎNG SAO HỎA (NASA)', 'CHUẨN MÔ PHỎNG SAO HỎA (NASA)',
  0.9, 'Evaporites, Sulfates, Chlorides, Clay Minerals', 'Martian Sulfates, Chlorides, Clay Minerals, Basalt',
  4.0, 2.5,
  289.0, 252.0,
  75.0, 0.65,
  'VÙNG CHUẨN NASA: Cảnh quan siêu khô hạn trong sa mạc Atacama chứa các mỏ muối bốc hơi, cấu trúc trầm tích và đá bị gió mài mòn. Rất hữu ích để kiểm tra thiết bị phân tích đất Sao Hỏa, phát hiện khoáng chất và công nghệ tìm kiếm sự sống.', 'VÙNG CHUẨN NASA: Cảnh quan siêu khô hạn trong sa mạc Atacama chứa các mỏ muối bốc hơi, cấu trúc trầm tích và đá bị gió mài mòn. Rất hữu ích để kiểm tra thiết bị phân tích đất Sao Hỏa, phát hiện khoáng chất và công nghệ tìm kiếm sự sống.', 'Nằm ở độ cao ~2.400 m nên áp suất khí quyển vẫn đạt ~75 kPa; có lớp khí quyển che chắn bức xạ mặt trời.', 'Nằm ở độ cao ~2.400 m nên áp suất khí quyển vẫn đạt ~75 kPa; có lớp khí quyển che chắn bức xạ mặt trời.'
),
(
  'krafla', '⭐ 8. Cao nguyên Krafla (Iceland)', '⭐ 8. Cao nguyên Krafla (Iceland)', '⭐ Krafla', 'moon', false, true, false,
  65.715, -16.728, 11,
  20.19, 30.77, 7, 'Taurus-Littrow - Apollo 17 (Moon)',
  'CHUẨN MÔ PHỎNG MẶT TRĂNG (NASA)', 'CHUẨN MÔ PHỎNG MẶT TRĂNG (NASA)',
  0.86, 'Basalt, Picro-Basalt, Rhyolite, Andesite', 'Basalt, Pyroxene, Olivine, Clay Minerals',
  10.0, 11.0,
  277.0, 252.0,
  92.0, 0.0,
  'VÙNG CHUẨN NASA: Hệ thống núi lửa còn hoạt động chứa miệng núi lửa trung tâm, các vụ phun trào khe nứt bazan, dòng dung nham tươi và các vùng thủy nhiệt biến chất. Nơi huấn luyện phi hành gia Apollo 17 và thử nghiệm bộ đồ EVA Artemis.', 'VÙNG CHUẨN NASA: Hệ thống núi lửa còn hoạt động chứa miệng núi lửa trung tâm, các vụ phun trào khe nứt bazan, dòng dung nham tươi và các vùng thủy nhiệt biến chất. Nơi huấn luyện phi hành gia Apollo 17 và thử nghiệm bộ đồ EVA Artemis.', 'Hoạt động địa nhiệt cao, nước lỏng, tuyết, khí quyển dày và các quá trình sinh học khác biệt với điều kiện bề mặt Mặt Trăng.', 'Hoạt động địa nhiệt cao, nước lỏng, tuyết, khí quyển dày và các quá trình sinh học khác biệt với điều kiện bề mặt Mặt Trăng.'
),
(
  'chott_djerid', '9. Hồ nước mặn Chott el Djerid (Tunisia)', '9. Hồ nước mặn Chott el Djerid (Tunisia)', '🇹🇳 Chott el Djerid', 'mars', false, false, false,
  33.7, 8.5, 10,
  -14.5, 175.4, 7, 'Gusev Crater Paleolake (Mars)',
  'SAO HỎA (HỐ GUSEV)', 'SAO HỎA (HỐ GUSEV)',
  0.89, 'Halite, Gypsum, Sulfates, Evaporites, Clay Minerals', 'Martian Sulfates, Chlorides, Evaporite Deposits',
  3.0, 7.0,
  296.0, 252.0,
  101.0, 0.6,
  'Vùng trũng nước mặn lớn ở tây nam Tunisia với các mỏ evaporite rộng lớn, lớp vỏ muối kết tinh và biến thiên độ ẩm theo mùa. Thích hợp nghiên cứu hồ cổ đại Sao Hỏa, quá trình hình thành muối bốc hơi và bằng chứng khoáng vật học về nước lỏng cổ.', 'Vùng trũng nước mặn lớn ở tây nam Tunisia với các mỏ evaporite rộng lớn, lớp vỏ muối kết tinh và biến thiên độ ẩm theo mùa. Thích hợp nghiên cứu hồ cổ đại Sao Hỏa, quá trình hình thành muối bốc hơi và bằng chứng khoáng vật học về nước lỏng cổ.', 'Nước ngầm theo mùa, lũ lụt cục bộ, hoạt động sinh học và độ ẩm không khí ảnh hưởng đến sự hình thành muối.', 'Nước ngầm theo mùa, lũ lụt cục bộ, hoạt động sinh học và độ ẩm không khí ảnh hưởng đến sự hình thành muối.'
),
(
  'lonar', '10. Miệng núi lửa Lonar (Ấn Độ)', '10. Miệng núi lửa Lonar (Ấn Độ)', '🇮🇳 Hố Lonar', 'mars', false, false, false,
  19.9767, 76.5083, 14,
  18.38, 77.58, 7, 'Jezero Crater (Mars)',
  'SAO HỎA (HỐ JEZERO)', 'SAO HỎA (HỐ JEZERO)',
  0.93, 'Deccan Basalt, Impact Breccia, Saponite, Carbonates', 'Martian Basalt, Impact Breccia, Clay Minerals',
  20.5, 15.0,
  299.0, 252.0,
  96.0, 0.65,
  'Hố va chạm rộng ~1.8 km hình thành trong địa hình núi lửa bazan Deccan. Chứa bazan biến chất va chạm (maskelynite), trầm tích ejecta và khoáng chất biến đổi thủy nhiệt, tương đồng sâu sắc với cấu trúc va chạm hố Jezero trên Sao Hỏa.', 'Hố va chạm rộng ~1.8 km hình thành trong địa hình núi lửa bazan Deccan. Chứa bazan biến chất va chạm (maskelynite), trầm tích ejecta và khoáng chất biến đổi thủy nhiệt, tương đồng sâu sắc với cấu trúc va chạm hố Jezero trên Sao Hỏa.', 'Lòng hố chứa hồ nước mặn siêu kiềm chịu ảnh hưởng của mưa mùa và vi sinh vật hoạt động mạnh.', 'Lòng hố chứa hồ nước mặn siêu kiềm chịu ảnh hưởng của mưa mùa và vi sinh vật hoạt động mạnh.'
),
(
  'kamchatka', '11. Vùng núi lửa Kamchatka (Nga)', '11. Vùng núi lửa Kamchatka (Nga)', '🇷🇺 Kamchatka', 'mars', false, false, false,
  56.056, 160.642, 10,
  32.1, 150.2, 7, 'Hecates Tholus (Mars)',
  'SAO HỎA (HECATES THOLUS)', 'SAO HỎA (HECATES THOLUS)',
  0.84, 'Basalt, Andesite, Pyroclastic Deposits, Volcanic Ash', 'Martian Basalt, Pyroxene, Olivine, Volcanic Deposits',
  15.0, 15.0,
  265.0, 252.0,
  55.0, 0.6,
  'Hệ thống núi lửa dạng tầng lớn tại vòng cung núi lửa Đông Kamchatka với các dòng dung nham bazan/andesit, tro mạt vụn và trầm tích băng tuyết núi cao. Hữu ích để nghiên cứu hình thái núi lửa băng và lấy mẫu đá núi lửa Sao Hỏa.', 'Hệ thống núi lửa dạng tầng lớn tại vòng cung núi lửa Đông Kamchatka với các dòng dung nham bazan/andesit, tro mạt vụn và trầm tích băng tuyết núi cao. Hữu ích để nghiên cứu hình thái núi lửa băng và lấy mẫu đá núi lửa Sao Hỏa.', 'Hoạt động phun trào thường xuyên, băng hà, tuyết dày, độ ẩm không khí và phong hóa sinh học.', 'Hoạt động phun trào thường xuyên, băng hà, tuyết dày, độ ẩm không khí và phong hóa sinh học.'
),
(
  'badlands', '12. Badlands National Park (Mỹ)', '12. Badlands National Park (Mỹ)', '🇺🇸 Badlands', 'mars', false, false, false,
  43.834, -102.394, 11,
  -5.0, 137.5, 7, 'Mount Sharp Strata (Mars)',
  'SAO HỎA (ĐỈNH SHARP - GALE)', 'SAO HỎA (ĐỈNH SHARP - GALE)',
  0.74, 'Claystone, Siltstone, Sandstone, Volcanic Ash', 'Martian Sedimentary Rocks, Clay Minerals, Sulfates',
  12.0, 15.0,
  283.0, 252.0,
  94.0, 0.6,
  'Cảnh quan trầm tích bị xói mòn sâu rộng chứa các tầng địa chất lộ thiên, đất sét giàu khoáng chất, sa thạch và trầm tích tro núi lửa. Hữu ích để nghiên cứu địa chất trầm tích Sao Hỏa và khảo sát các tầng địa tầng bằng xe rover.', 'Cảnh quan trầm tích bị xói mòn sâu rộng chứa các tầng địa chất lộ thiên, đất sét giàu khoáng chất, sa thạch và trầm tích tro núi lửa. Hữu ích để nghiên cứu địa chất trầm tích Sao Hỏa và khảo sát các tầng địa tầng bằng xe rover.', 'Lượng mưa, tuyết mùa đông, xói mòn do sông suối, thảm thực vật và các quá trình sinh học khác biệt với bề mặt Sao Hỏa hiện đại.', 'Lượng mưa, tuyết mùa đông, xói mòn do sông suối, thảm thực vật và các quá trình sinh học khác biệt với bề mặt Sao Hỏa hiện đại.'
)
on conflict (id) do update set
  name_vi = excluded.name_vi,
  name_en = excluded.name_en,
  short_label = excluded.short_label,
  body_type = excluded.body_type,
  is_vietnam = excluded.is_vietnam,
  is_baseline = excluded.is_baseline,
  earth_lat = excluded.earth_lat,
  earth_lon = excluded.earth_lon,
  earth_zoom = excluded.earth_zoom,
  planet_lat = excluded.planet_lat,
  planet_lon = excluded.planet_lon,
  planet_zoom = excluded.planet_zoom,
  planet_site_name = excluded.planet_site_name,
  target_vi = excluded.target_vi,
  target_en = excluded.target_en,
  mineral_score = excluded.mineral_score,
  earth_mineral = excluded.earth_mineral,
  planet_mineral = excluded.planet_mineral,
  earth_slope = excluded.earth_slope,
  planet_slope = excluded.planet_slope,
  earth_temp_k = excluded.earth_temp_k,
  planet_temp_k = excluded.planet_temp_k,
  earth_pressure_kpa = excluded.earth_pressure_kpa,
  planet_pressure_kpa = excluded.planet_pressure_kpa,
  geology_vi = excluded.geology_vi,
  geology_en = excluded.geology_en,
  limits_vi = excluded.limits_vi,
  limits_en = excluded.limits_en;

-- 6. KIỂM TRA LẠI 12 DÒNG DỮ LIỆU ĐÃ NẠP
select id, name_vi, body_type, mineral_score, earth_slope, earth_temp_k, earth_pressure_kpa, created_at from public.analog_sites order by created_at asc;