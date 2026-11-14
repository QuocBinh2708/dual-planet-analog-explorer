-- ========================================================
-- SUPABASE SETUP SCRIPT FOR DUAL PLANET ANALOG EXPLORER
-- Project URL: https://prhngciivgzoarwoburu.supabase.co
-- ========================================================

-- 1. TẠO BẢNG analog_sites NẾU CHƯA CÓ
create table if not exists public.analog_sites (
  id text primary key,
  name_vi text not null,
  name_en text not null,
  body_type text default 'moon',
  is_baseline boolean default false,
  earth_lat double precision not null,
  earth_lon double precision not null,
  earth_zoom integer default 11,
  planet_lat double precision not null,
  planet_lon double precision not null,
  planet_zoom integer default 7,
  planet_site_name text not null,
  target_vi text,
  target_en text,
  earth_sio2 numeric,
  earth_feo numeric,
  earth_tio2 numeric,
  earth_density numeric,
  earth_thermal numeric,
  earth_roof numeric,
  earth_gravity numeric,
  planet_sio2 numeric,
  planet_feo numeric,
  planet_tio2 numeric,
  planet_density numeric,
  planet_thermal numeric,
  planet_roof numeric,
  planet_gravity numeric,
  geology_vi text,
  geology_en text,
  limits_vi text,
  limits_en text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. BẬT BẢO MẬT HÀNG (ROW LEVEL SECURITY)
alter table public.analog_sites enable row level security;

-- 3. CẤP QUYỀN ĐỌC / GHI / SỬA / XÓA CHO WEB BẰNG PUBLISHABLE KEY
drop policy if exists "Allow public read access" on public.analog_sites;
create policy "Allow public read access"
  on public.analog_sites for select
  to anon, authenticated
  using (true);

drop policy if exists "Allow public insert access" on public.analog_sites;
create policy "Allow public insert access"
  on public.analog_sites for insert
  to anon, authenticated
  with check (true);

drop policy if exists "Allow public update access" on public.analog_sites;
create policy "Allow public update access"
  on public.analog_sites for update
  to anon, authenticated
  using (true)
  with check (true);

drop policy if exists "Allow public delete access" on public.analog_sites;
create policy "Allow public delete access"
  on public.analog_sites for delete
  to anon, authenticated
  using (true);

-- 4. NẠP TOÀN BỘ 7 ĐIỂM DỮ LIỆU BAN ĐẦU VÀO DATABASE
insert into public.analog_sites (
  id, name_vi, name_en, body_type, is_baseline,
  earth_lat, earth_lon, earth_zoom,
  planet_lat, planet_lon, planet_zoom, planet_site_name,
  target_vi, target_en,
  earth_sio2, earth_feo, earth_tio2, earth_density, earth_thermal, earth_roof, earth_gravity,
  planet_sio2, planet_feo, planet_tio2, planet_density, planet_thermal, planet_roof, planet_gravity,
  geology_vi, geology_en, limits_vi, limits_en
) values
(
  'chubluk',
  '1. Chư Bluk (Việt Nam)',
  '1. Chư Bluk (Vietnam)',
  'moon',
  false,
  12.485, 107.902, 12,
  14.0, -56.0, 7, 'Marius Hills (Moon)',
  'MẶT TRĂNG (MARIUS HILLS)', 'MOON (MARIUS HILLS)',
  50.2, 12.1, 1.5, 2.80, 85, 15.0, 9.81,
  45.5, 17.5, 4.5, 3.10, 92, 20.0, 1.62,
  'Hệ thống hang động ống dung nham dài nhất Đông Nam Á (>25 km, hơn 100 hang) trên nền đá bazan trẻ. Trần hang dày ~15 m giúp ổn định nhiệt độ và che chắn bức xạ, lý tưởng để thử nghiệm robot tự hành không GPS (SLAM) và căn cứ ngầm Mặt Trăng.',
  'Southeast Asia''s longest volcanic lava tube system (>25 km, 100+ caves) hosted in young Pleistocene basalts. ~15 m basalt roof provides thermal buffering and radiation shielding for GPS-denied SLAM rover and lunar habitat testing.',
  'Khí hậu nhiệt đới gió mùa gây phong hóa hóa học bề mặt; trọng lực 1g (gấp 6 lần Mặt Trăng) và không có môi trường chân không.',
  'Tropical monsoon climate causes surface weathering; experiences 1g Earth gravity (6x lunar gravity) and lacks vacuum conditions.'
),
(
  'lonar',
  '2. Hố Lonar (Ấn Độ)',
  '2. Lonar Crater (India)',
  'mars',
  false,
  19.976, 76.508, 14,
  18.38, 77.58, 7, 'Jezero Crater (Mars)',
  'SAO HỎA (HỐ JEZERO)', 'MARS (JEZERO CRATER)',
  49.8, 13.4, 2.2, 2.90, 72, 0, 9.81,
  44.5, 18.2, 1.1, 2.95, 76, 0, 3.72,
  'Hố va chạm thiên thạch trẻ (đường kính 1,83 km) trên nền đá bazan Deccan, chứa thủy tinh biến chất maskelynite và khoáng sét smectite trùng khớp phổ dữ liệu tàu MRO CRISM tại hố Jezero.',
  'Young hypervelocity impact crater (1.83 km diameter) excavated into Deccan flood basalts, containing shock-metamorphosed maskelynite glass and smectite clays matching MRO CRISM spectra at Jezero Crater.',
  'Lòng hố có hồ nước siêu kiềm mặn quanh năm với hệ sinh thái vi sinh vật hoạt động mạnh.',
  'Hosts a perennial hyper-alkaline saline lake on the crater floor with active microbial ecosystems.'
),
(
  'qaidam',
  '3. Bồn địa Qaidam (TQ)',
  '3. Qaidam Basin (China)',
  'mars',
  false,
  37.500, 94.500, 9,
  -5.4, 137.8, 7, 'Gale Crater (Mars)',
  'SAO HỎA (MIỆNG NÚI LỬA GALE)', 'MARS (GALE CRATER)',
  54.0, 6.5, 0.7, 2.35, 68, 0, 9.81,
  47.2, 15.8, 0.9, 2.50, 74, 0, 3.72,
  'Hoang mạc siêu khô hạn ở độ cao ~2.800 m giàu muối bay hơi (halite, gypsum, sulfat) và địa hình đồi gió mòn (yardangs) lớn nhất Trái Đất, tương đồng trầm tích hồ cổ đại tại Gale Crater.',
  'High-altitude (~2,800 m) hyper-arid desert rich in evaporites (halite, gypsum, sulfates) and Earth''s largest aerodynamic yardang field, mirroring ancient lacustrine strata in Gale Crater.',
  'Áp suất khí quyển (~71 kPa) vẫn cao hơn Sao Hỏa >100 lần và hàm lượng oxy tự do cao.',
  'Atmospheric pressure (~71 kPa) remains >100x higher than Mars, with high atmospheric oxygen.'
),
(
  'dallol',
  '4. Địa nhiệt Dallol (Ethiopia)',
  '4. Dallol Geothermal (Ethiopia)',
  'mars',
  false,
  14.242, 40.300, 13,
  -14.5, 175.4, 7, 'Columbia Hills - Gusev (Mars)',
  'SAO HỎA CỔ ĐẠI (GUSEV)', 'EARLY MARS (GUSEV CRATER)',
  46.5, 14.8, 1.8, 2.45, 65, 0, 9.81,
  45.0, 16.5, 0.8, 2.60, 70, 0, 3.72,
  'Hệ thống suối thủy nhiệt axit siêu mặn (pH 0,25) kết tủa jarosite, muối sắt và lưu huỳnh, mô phỏng các suối nước nóng Sao Hỏa kỷ Noachian (~3,5 tỷ năm trước).',
  'Polyextreme acidic hypersaline hydrothermal system (pH 0.25) precipitating jarosite, iron salts, and sulfur, modeling Noachian Mars hot springs (~3.5 Ga).',
  'Nhiệt độ trung bình năm cao nhất Trái Đất (+34,6°C), trái ngược khí hậu lạnh giá hiện tại của Sao Hỏa.',
  'Highest annual mean air temperature on Earth (+34.6°C), contrasting sharply with present-day cryogenic Mars.'
),
(
  'boulby',
  '5. Hầm mỏ Boulby (Anh)',
  '5. Boulby Mine (UK)',
  'mars',
  false,
  54.555, -0.825, 13,
  -11.5, -121.0, 7, 'Arsia Mons Skylights (Mars)',
  'HANG NGẦM SAO HỎA (ARSIA MONS)', 'SUBSURFACE MARS (ARSIA MONS)',
  12.0, 3.2, 0.3, 2.20, 95, 1100, 9.81,
  43.8, 17.0, 1.2, 2.85, 90, 45, 3.72,
  'Mỏ muối sâu 1,1 km đặt phòng thí nghiệm MINAR của NASA/ESA. Tái tạo môi trường tối hoàn toàn, không GPS và che chắn bức xạ vũ trụ tối đa cho thử nghiệm robot khoan sâu.',
  '1.1 km deep Permian evaporite mine hosting the NASA/ESA MINAR facility. Provides a completely dark, GPS-denied, radiation-shielded environment for deep subsurface rover testing.',
  'Địa nhiệt làm tăng nhiệt độ hầm mỏ (~28,5°C) và áp suất khí quyển (~112 kPa), ngược với hang ngầm lạnh áp suất thấp trên Sao Hỏa.',
  'Geothermal gradient elevates ambient underground temperatures (~28.5°C) and barometric pressure (~112 kPa).'
),
(
  'atacama',
  '6. Sa mạc Atacama (Chile)',
  '6. Atacama Desert (Chile)',
  'mars',
  false,
  -24.095, -69.925, 11,
  4.5, 135.6, 7, 'Elysium Planitia (Mars)',
  'SAO HỎA (ELYSIUM PLANITIA)', 'MARS (ELYSIUM PLANITIA)',
  56.2, 7.8, 0.8, 2.55, 71, 0, 9.81,
  44.0, 18.0, 1.0, 2.90, 75, 0, 3.72,
  'Vùng lõi siêu khô hạn Yungay (<1 mm mưa/năm) chứa muối perchlorate và sinh khối cực thấp, bãi thử tiêu chuẩn cho các sứ mệnh Viking, Curiosity và Perseverance.',
  'Hyper-arid Yungay core (<1 mm/yr precipitation) with perchlorate-bearing soils and ultra-low biomass, serving as a primary testbed for Viking, Curiosity, and Perseverance protocols.',
  'Nằm ở độ cao ~1.000 m nên áp suất khí quyển vẫn đạt ~90 kPa.',
  'Located at ~1,000 m elevation, retaining ~90 kPa atmospheric pressure.'
),
(
  'iceland',
  '7. Krafla (Iceland)',
  '7. Krafla (Iceland)',
  'moon',
  false,
  65.715, -16.755, 11,
  20.19, 30.77, 7, 'Taurus-Littrow - Apollo 17 (Moon)',
  'MẶT TRĂNG (TAURUS-LITTROW)', 'MOON (TAURUS-LITTROW)',
  49.5, 13.0, 1.9, 2.88, 78, 4.0, 9.81,
  42.5, 17.2, 5.5, 3.15, 82, 5.0, 1.62,
  'Khu vực huấn luyện phi hành gia Apollo và thử nghiệm bộ đồ EVA Artemis. Các dòng dung nham bazan tươi không thảm thực vật mô phỏng sát cơ học bề mặt biển Mặt Trăng.',
  'Training ground for Apollo astronauts and Artemis EVA suit testing. Unvegetated young tholeiitic lava flows closely replicate lunar mare surface mechanics.',
  'Chịu tác động của tuyết/băng theo mùa, phong hóa khí quyển và trọng lực 1g.',
  'Subject to seasonal snow/ice hydrology, atmospheric weathering, and 1g gravity.'
)
on conflict (id) do update set
  name_vi = excluded.name_vi,
  name_en = excluded.name_en,
  body_type = excluded.body_type,
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
  earth_sio2 = excluded.earth_sio2,
  earth_feo = excluded.earth_feo,
  earth_tio2 = excluded.earth_tio2,
  earth_density = excluded.earth_density,
  earth_thermal = excluded.earth_thermal,
  earth_roof = excluded.earth_roof,
  earth_gravity = excluded.earth_gravity,
  planet_sio2 = excluded.planet_sio2,
  planet_feo = excluded.planet_feo,
  planet_tio2 = excluded.planet_tio2,
  planet_density = excluded.planet_density,
  planet_thermal = excluded.planet_thermal,
  planet_roof = excluded.planet_roof,
  planet_gravity = excluded.planet_gravity,
  geology_vi = excluded.geology_vi,
  geology_en = excluded.geology_en,
  limits_vi = excluded.limits_vi,
  limits_en = excluded.limits_en;

-- 5. KIỂM TRA LẠI DỮ LIỆU ĐÃ VÀO
select id, name_vi, body_type, created_at from public.analog_sites order by created_at asc;
