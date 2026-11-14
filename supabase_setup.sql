-- ========================================================
-- SUPABASE SETUP SCRIPT FOR KRONOS-SIM ANALOG MISSION CONTROL
-- Project URL: https://prhngciivgzoarwoburu.supabase.co
-- ========================================================

-- 1. TẠO BẢNG analog_sites NẾU CHƯA CÓ
create table if not exists public.analog_sites (
  id text primary key,
  name text not null,
  short_label text not null,
  is_vietnam boolean default false,
  is_baseline boolean default false,
  is_custom boolean default false,
  body_type text default 'moon',
  earth_lat double precision not null,
  earth_lon double precision not null,
  earth_zoom integer default 11,
  planet_lat double precision not null,
  planet_lon double precision not null,
  planet_zoom integer default 7,
  planet_site_name text not null,
  target text not null,
  earth_slope numeric,
  earth_temp_k numeric,
  earth_pressure_kpa numeric,
  earth_mineral_score numeric,
  earth_mineral_text text,
  planet_slope numeric,
  planet_temp_k numeric,
  planet_pressure_kpa numeric,
  planet_mineral_score numeric,
  planet_mineral_text text,
  geology text,
  limits text,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. BẬT BẢO MẬT HÀNG (ROW LEVEL SECURITY)
alter table public.analog_sites enable row level security;

-- 3. CẤP QUYỀN ĐỌC / GHI CHO WEBSITE (ANON & AUTHENTICATED)
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
  id, name, short_label, is_vietnam, is_baseline, is_custom, body_type,
  earth_lat, earth_lon, earth_zoom,
  planet_lat, planet_lon, planet_zoom, planet_site_name, target,
  earth_slope, earth_temp_k, earth_pressure_kpa, earth_mineral_score, earth_mineral_text,
  planet_slope, planet_temp_k, planet_pressure_kpa, planet_mineral_score, planet_mineral_text,
  geology, limits
) values
(
  'krongno',
  '1. Krông Nô – Chư Bluk (Vietnam)',
  '🇻🇳 Krông Nô – Chư Bluk',
  true, false, false, 'moon',
  12.518, 107.905, 13,
  14.0, -56.0, 7, 'Marius Hills (Moon)', 'MOON (MARIUS HILLS)',
  9.0, 296.6, 96.0, 0.90, 'Basalt (FeO 12%)',
  9.5, 253.0, 0.0, 0.90, 'Mare Basalt (FeO 17%)',
  'Southeast Asia''s longest volcanic lava tube system (>25 km, 50+ caves including C7, A1, C3, C8) in Dak Nong UNESCO Global Geopark, erupted from Chư Bluk volcano on young Pleistocene basalts. Subsurface tube temperatures stay buffered around 20–22°C (293–295 K), demonstrating natural basaltic thermal insulation analogous to lunar mare tubes (~253 K).',
  'Tropical monsoon climate produces dense surface vegetation and rapid chemical weathering; experiences 1g Earth gravity (6x lunar gravity) and lacks high-vacuum conditions.'
),
(
  'lonar',
  '2. Lonar Crater (India)',
  '🇮🇳 Lonar Crater',
  false, false, false, 'mars',
  19.976, 76.508, 14,
  18.38, 77.58, 7, 'Jezero Crater (Mars)', 'MARS (JEZERO CRATER)',
  20.5, 300.1, 95.0, 0.95, 'Basalt, Maskelynite, Smectite',
  17.0, 218.1, 0.65, 0.95, 'Basalt, Olivine, Smectite',
  'A rare young hypervelocity impact crater (1.83 km diameter) excavated directly into Deccan flood basalts. Contains shock-metamorphosed maskelynite glass, smectite clays, and carbonates matching MRO CRISM and Perseverance observations at Jezero Crater.',
  'Hosts a perennial hyper-alkaline saline lake on the crater floor with active microbial/lacustrine ecosystems and monsoonal rainfall.'
),
(
  'qaidam',
  '3. Qaidam Basin (China)',
  '🇨🇳 Qaidam Basin',
  false, false, false, 'mars',
  37.500, 94.500, 9,
  -5.4, 137.8, 7, 'Gale Crater (Mars)', 'MARS (GALE CRATER)',
  2.5, 276.1, 71.0, 0.92, 'Halite, Gypsum, MgSO₄',
  3.5, 223.1, 0.75, 0.92, 'Gypsum, MgSO₄, Phyllosilicates',
  'High-altitude (~2,800 m) hyper-arid desert rich in evaporite deposits (halite, gypsum, magnesium sulfates) and Earth''s largest aerodynamic yardang field. Enables quantitative modeling of Martian aeolian erosion rates and rover mobility testing on fine regolith.',
  'Atmospheric pressure (~71 kPa) remains >100x higher than Mars (~0.75 kPa), and high atmospheric O₂ drives distinct surface oxidation chemistry.'
),
(
  'dallol',
  '4. Dallol Geothermal (Ethiopia)',
  '🇪🇹 Dallol',
  false, false, false, 'mars',
  14.242, 40.300, 13,
  -14.5, 175.4, 7, 'Columbia Hills - Gusev (Mars)', 'EARLY MARS (GUSEV CRATER)',
  5.0, 307.7, 102.0, 0.88, 'Jarosite, Fe-Salts, Sulfur',
  7.0, 213.1, 0.62, 0.88, 'Opaline Silica, Jarosite',
  'Polyextreme volcanic hydrothermal system (pH down to 0.25, hypersaline brines >35%, iron- and sulfur-rich precipitates) modeling Noachian Mars hot springs (~3.5 Ga). Used to calibrate astrobiological instruments for detecting fossilized biosignatures in salt chimneys.',
  'Highest annual mean air temperature on Earth (+34.6°C / 307.7 K), contrasting sharply with present-day cryogenic Martian temperatures (-60°C).'
),
(
  'boulby',
  '5. Boulby Mine (UK)',
  '🇬🇧 Boulby Mine',
  false, false, false, 'mars',
  54.555, -0.825, 13,
  -11.5, -121.0, 7, 'Arsia Mons Skylights (Mars)', 'SUBSURFACE MARS & MOON',
  3.5, 301.6, 112.0, 0.89, 'Halite, Sylvite, Polyhalite',
  5.5, 235.0, 0.5, 0.89, 'Subsurface Sulfates & Chlorides',
  '1.1 km deep Permian evaporite mine hosting the NASA/ESA MINAR (Mine Analog Research) facility. Provides a completely dark, GPS-denied, radiation-shielded environment to test autonomous subsurface rovers, deep-drilling rigs, and extremophile life-detection sensors.',
  'Geothermal gradient elevates ambient underground temperatures (~28.5°C) and barometric pressure (~112 kPa), opposite to cold, low-pressure Martian caves.'
),
(
  'atacama',
  '⭐ 6. Atacama (Mars Baseline)',
  '⭐ Atacama (Baseline)',
  false, true, false, 'mars',
  -24.095, -69.925, 11,
  4.5, 135.6, 7, 'Elysium Planitia (Mars)', 'MARS GOLD-STANDARD BASELINE',
  4.0, 289.6, 90.0, 0.94, 'Halite, Gypsum, Perchlorates',
  2.5, 215.1, 0.65, 0.94, 'Dry Basalt, Sulfates, Perchlorates',
  'NASA BENCHMARK SITE: The hyper-arid Yungay core (<1 mm/yr precipitation) features perchlorate-bearing soils and ultra-low microbial biomass, serving as the primary testbed for Viking, Curiosity, and Perseverance life-detection and mobility protocols.',
  'Located at ~1,000 m elevation, retaining ~90 kPa atmospheric pressure and Earth-like diurnal thermal cycles.'
),
(
  'iceland',
  '⭐ 7. Krafla (Moon Baseline)',
  '⭐ Krafla (Baseline)',
  false, true, false, 'moon',
  65.715, -16.755, 11,
  20.19, 30.77, 7, 'Taurus-Littrow - Apollo 17 (Moon)', 'MOON GOLD-STANDARD BASELINE',
  10.0, 274.6, 96.0, 0.93, 'Fresh Basalt, Volcanic Glass',
  11.0, 251.1, 0.0, 0.93, 'Mare Basalt, Ilmenite, Glass Beads',
  'NASA BENCHMARK SITE: Used to train Apollo astronauts and test Artemis EVA suits. Unvegetated young tholeiitic lava flows, cinder cones, and abrasive volcanic tephra closely replicate lunar mare surface mechanics.',
  'Subject to seasonal snow/ice hydrology, atmospheric weathering, and 1g terrestrial gravity.'
)
on conflict (id) do update set
  name = excluded.name,
  short_label = excluded.short_label,
  is_vietnam = excluded.is_vietnam,
  is_baseline = excluded.is_baseline,
  is_custom = excluded.is_custom,
  body_type = excluded.body_type,
  earth_lat = excluded.earth_lat,
  earth_lon = excluded.earth_lon,
  earth_zoom = excluded.earth_zoom,
  planet_lat = excluded.planet_lat,
  planet_lon = excluded.planet_lon,
  planet_zoom = excluded.planet_zoom,
  planet_site_name = excluded.planet_site_name,
  target = excluded.target,
  earth_slope = excluded.earth_slope,
  earth_temp_k = excluded.earth_temp_k,
  earth_pressure_kpa = excluded.earth_pressure_kpa,
  earth_mineral_score = excluded.earth_mineral_score,
  earth_mineral_text = excluded.earth_mineral_text,
  planet_slope = excluded.planet_slope,
  planet_temp_k = excluded.planet_temp_k,
  planet_pressure_kpa = excluded.planet_pressure_kpa,
  planet_mineral_score = excluded.planet_mineral_score,
  planet_mineral_text = excluded.planet_mineral_text,
  geology = excluded.geology,
  limits = excluded.limits;

-- 5. HIỂN THỊ KẾT QUẢ ĐÃ NẠP
select id, name, body_type, earth_slope, earth_temp_k, earth_pressure_kpa, created_at from public.analog_sites order by created_at asc;
