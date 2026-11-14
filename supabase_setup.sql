-- ========================================================
-- SUPABASE SETUP SCRIPT FOR KRONOS-SIM ANALOG EXPLORER
-- 12 PLANETARY ANALOG SITES (NASA 4-PARAMETER ESI MODEL)
-- Project URL: https://prhngciivgzoarwoburu.supabase.co
-- ========================================================

-- 1. DROP OLD TABLE AND CREATE CANONICAL ANALOG_SITES TABLE
drop table if exists public.analog_sites cascade;

create table public.analog_sites (
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

-- 2. ENABLE ROW LEVEL SECURITY (RLS)
alter table public.analog_sites enable row level security;

-- 3. PERMISSIVE PUBLIC RLS POLICIES (FOR RESEARCH WEB APPLICATION)
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

-- 4. SEED CANONICAL 12 PLANETARY ANALOG SITES (100% ENGLISH)
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
  'krongno', '1. Krong No – Chu Bluk (Vietnam)', '1. Krong No – Chu Bluk (Vietnam)', '🇻🇳 Krong No', 'moon', true, false, false,
  12.518, 107.905, 13,
  14.0, -56.0, 7, 'Marius Hills (Moon)',
  'MOON (MARIUS HILLS)', 'MOON (MARIUS HILLS)',
  0.9, 'Basalt (FeO 12%)', 'Mare Basalt (FeO 17%)',
  9.0, 9.5,
  296.6, 253.0,
  96.0, 0.0,
  'Longest basalt lava tube cave system in Southeast Asia (>25 km, 50+ tubes) in Dak Nong UNESCO Global Geopark. Thick basalt roof maintains stable 20-22°C (295 K) temperature and natural cosmic radiation shielding, ideal for SLAM autonomous rover navigation and lunar underground base simulation.',
  'Longest basalt lava tube cave system in Southeast Asia (>25 km, 50+ tubes) in Dak Nong UNESCO Global Geopark. Thick basalt roof maintains stable 20-22°C (295 K) temperature and natural cosmic radiation shielding, ideal for SLAM autonomous rover navigation and lunar underground base simulation.',
  'Tropical monsoon surface weathering, 1g Earth gravity (6x lunar gravity), atmospheric pressure (96 kPa vs lunar vacuum), and biological colonization.',
  'Tropical monsoon surface weathering, 1g Earth gravity (6x lunar gravity), atmospheric pressure (96 kPa vs lunar vacuum), and biological colonization.'
),
(
  'lanzarote', '2. Lanzarote Island (Spain)', '2. Lanzarote Island (Spain)', '🇪🇸 Lanzarote', 'mars', false, false, false,
  28.9583, -13.7667, 11,
  -11.5, -121.0, 7, 'Arsia Mons Skylights (Mars)',
  'MARS (ARSIA MONS)', 'MARS (ARSIA MONS)',
  0.83, 'Basalt, Olivine, Pyroxene, Volcanic Ash', 'Martian Basalt, Olivine, Pyroxene',
  12.0, 15.0,
  294.0, 252.0,
  100.0, 0.6,
  'Young basaltic volcanic landscape in Timanfaya National Park featuring extensive lava flows, cinder cones, and lava tubes. Extensively used for rover traction testing, volcanic geology mapping, and planetary cave exploration training (ESA PANGAEA).',
  'Young basaltic volcanic landscape in Timanfaya National Park featuring extensive lava flows, cinder cones, and lava tubes. Extensively used for rover traction testing, volcanic geology mapping, and planetary cave exploration training (ESA PANGAEA).',
  'Maritime island climate, oceanic air humidity, biological colonization, and weathering processes contrast with the arid, cold, low-pressure Martian environment.',
  'Maritime island climate, oceanic air humidity, biological colonization, and weathering processes contrast with the arid, cold, low-pressure Martian environment.'
),
(
  'meteor_crater', '3. Meteor Crater (Arizona, USA)', '3. Meteor Crater (Arizona, USA)', '🇺🇸 Meteor Crater', 'mars', false, false, false,
  35.027, -111.022, 14,
  -5.4, 137.8, 7, 'Gale Crater Rim (Mars)',
  'MARS (GALE CRATER)', 'MARS (GALE CRATER)',
  0.88, 'Impact-Brecciated Sandstone, Limestone, Shocked Minerals', 'Martian Impact Breccia, Basalt, Regolith',
  18.0, 15.0,
  285.0, 252.0,
  95.0, 0.6,
  'Best-preserved meteorite impact crater on Earth (~50,000 years old, 1.2 km diameter) formed in sedimentary rock. Historical training site for Apollo astronauts (Gene Shoemaker) and analog testbed for impact crater morphology and rover traverse navigation.',
  'Best-preserved meteorite impact crater on Earth (~50,000 years old, 1.2 km diameter) formed in sedimentary rock. Historical training site for Apollo astronauts (Gene Shoemaker) and analog testbed for impact crater morphology and rover traverse navigation.',
  'Dense terrestrial atmosphere, aeolian and fluvial weathering, 1g gravity, and target lithology (limestone/sandstone) differs from Martian basaltic crust.',
  'Dense terrestrial atmosphere, aeolian and fluvial weathering, 1g gravity, and target lithology (limestone/sandstone) differs from Martian basaltic crust.'
),
(
  'craters_moon', '4. Craters of the Moon (Idaho, USA)', '4. Craters of the Moon (Idaho, USA)', '🇺🇸 Craters of Moon', 'moon', false, false, false,
  43.371, -113.493, 12,
  26.1, 3.6, 7, 'Hadley Rille - Apollo 15 (Moon)',
  'MOON (HADLEY RILLE)', 'MOON (HADLEY RILLE)',
  0.91, 'Basalt, Picro-Basalt, Scoria, Volcanic Glass', 'Mare Basalt, Pyroxene, Olivine',
  10.0, 14.0,
  282.0, 253.0,
  80.0, 0.0,
  'Extensive Holocene basaltic lava field along the Great Rift of Idaho with pahoehoe and aa lava flows, spatter cones, and collapsed lava tube caves. Key analog for lunar mare volcanic features and basaltic morphology.',
  'Extensive Holocene basaltic lava field along the Great Rift of Idaho with pahoehoe and aa lava flows, spatter cones, and collapsed lava tube caves. Key analog for lunar mare volcanic features and basaltic morphology.',
  'Terrestrial subaerial lava emplacement with 1 atm air and meteoric water interaction; lunar lavas erupted in vacuum with much lower viscosity.',
  'Terrestrial subaerial lava emplacement with 1 atm air and meteoric water interaction; lunar lavas erupted in vacuum with much lower viscosity.'
),
(
  'lamayuru', '5. Lamayuru Valley (Ladakh, India)', '5. Lamayuru Valley (Ladakh, India)', '🇮🇳 Lamayuru', 'mars', false, false, false,
  34.28, 76.77, 12,
  -24.0, -33.3, 7, 'Eberswalde Crater (Mars)',
  'MARS (EBERSWALDE CRATER)', 'MARS (EBERSWALDE CRATER)',
  0.72, 'Sedimentary Rocks, Clay Minerals, Sulfates, Sandstone', 'Martian Basalt, Clay-Bearing Sediments',
  14.0, 15.0,
  280.0, 252.0,
  65.0, 0.6,
  'High-altitude cold desert "Moonland" paleolake basin in the Himalayas (~3,500 m elevation). Fine-grained clay lacustrine sediments and deeply dissected badlands landscape provide prime analog for ancient Martian deltaic and paleolake environments.',
  'High-altitude cold desert "Moonland" paleolake basin in the Himalayas (~3,500 m elevation). Fine-grained clay lacustrine sediments and deeply dissected badlands landscape provide prime analog for ancient Martian deltaic and paleolake environments.',
  'Tectonic uplift rates, higher terrestrial atmospheric density, and summer seasonal rainfall differ from hyperarid modern Mars.',
  'Tectonic uplift rates, higher terrestrial atmospheric density, and summer seasonal rainfall differ from hyperarid modern Mars.'
),
(
  'namib', '6. Moon Landscape (Namib Desert, Namibia)', '6. Moon Landscape (Namib Desert, Namibia)', '🇳🇦 Namib', 'mars', false, false, false,
  -22.68986, 14.79036, 11,
  -5.1, 137.8, 7, 'Bagnold Dunes - Gale (Mars)',
  'MARS (BAGNOLD DUNES)', 'MARS (BAGNOLD DUNES)',
  0.76, 'Weathered Bedrock, Quartz, Feldspar, Desert Sediments', 'Martian Regolith, Basalt, Iron Oxides',
  13.0, 15.0,
  291.0, 252.0,
  99.0, 0.6,
  'Hyperarid badlands canyon carved by the Swakop River into Precambrian schists and granites, combined with expansive coastal Namib sand seas. Exemplifies wind-dominated aeolian erosion and rover mobility terrain analogous to Martian dune fields.',
  'Hyperarid badlands canyon carved by the Swakop River into Precambrian schists and granites, combined with expansive coastal Namib sand seas. Exemplifies wind-dominated aeolian erosion and rover mobility terrain analogous to Martian dune fields.',
  'Presence of coastal fog humidity, oceanic moisture influence, terrestrial 1g gravity, and oxidizing Earth atmosphere.',
  'Presence of coastal fog humidity, oceanic moisture influence, terrestrial 1g gravity, and oxidizing Earth atmosphere.'
),
(
  'atacama', '⭐ 7. Valle de la Luna (Atacama Desert, Chile)', '⭐ 7. Valle de la Luna (Atacama Desert, Chile)', '⭐ Atacama', 'mars', false, true, false,
  -22.96, -68.28, 11,
  -0.2, -5.5, 7, 'Meridiani Planum (Mars)',
  'NASA MARS BASELINE (VALLE DE LA LUNA)', 'NASA MARS BASELINE (VALLE DE LA LUNA)',
  0.9, 'Evaporites, Sulfates, Chlorides, Clay Minerals', 'Martian Sulfates, Chlorides, Clay Minerals, Basalt',
  4.0, 2.5,
  289.0, 252.0,
  75.0, 0.65,
  'Hyperarid core of the Atacama Desert, one of the driest places on Earth. Extreme ultraviolet radiation, perchlorate-bearing soils, and negligible precipitation make it NASA\'s primary terrestrial baseline for Martian soil astrobiology and rover instrument calibration.',
  'Hyperarid core of the Atacama Desert, one of the driest places on Earth. Extreme ultraviolet radiation, perchlorate-bearing soils, and negligible precipitation make it NASA\'s primary terrestrial baseline for Martian soil astrobiology and rover instrument calibration.',
  'Atmospheric pressure (75 kPa) is still two orders of magnitude higher than Mars (0.6 kPa); 1g gravity and microbial presence in deep subsurfaces.',
  'Atmospheric pressure (75 kPa) is still two orders of magnitude higher than Mars (0.6 kPa); 1g gravity and microbial presence in deep subsurfaces.'
),
(
  'krafla', '⭐ 8. Krafla Volcanic Plateau (Iceland)', '⭐ 8. Krafla Volcanic Plateau (Iceland)', '⭐ Krafla', 'moon', false, true, false,
  65.715, -16.728, 11,
  20.19, 30.77, 7, 'Taurus-Littrow - Apollo 17 (Moon)',
  'NASA MOON BASELINE (KRAFLA PLATEAU)', 'NASA MOON BASELINE (KRAFLA PLATEAU)',
  0.86, 'Basalt, Picro-Basalt, Rhyolite, Andesite', 'Basalt, Pyroxene, Olivine, Clay Minerals',
  10.0, 11.0,
  277.0, 252.0,
  92.0, 0.0,
  'Active volcanic caldera along the Mid-Atlantic Ridge featuring fresh basaltic fissure eruptions, geothermal fields, and tephra deposits. NASA Apollo geology training site (1965-1967) and benchmark for lunar mare basalt petrology.',
  'Active volcanic caldera along the Mid-Atlantic Ridge featuring fresh basaltic fissure eruptions, geothermal fields, and tephra deposits. NASA Apollo geology training site (1965-1967) and benchmark for lunar mare basalt petrology.',
  'Abundant glacial water, hydrothermal steam vents, subglacial volcanism, and wet atmospheric interactions absent on the desiccated Moon.',
  'Abundant glacial water, hydrothermal steam vents, subglacial volcanism, and wet atmospheric interactions absent on the desiccated Moon.'
),
(
  'chott_djerid', '9. Chott el Djerid Salt Pan (Tunisia)', '9. Chott el Djerid Salt Pan (Tunisia)', '🇹🇳 Chott el Djerid', 'mars', false, false, false,
  33.7, 8.5, 10,
  -14.5, 175.4, 7, 'Gusev Crater Paleolake (Mars)',
  'MARS (GUSEV CRATER)', 'MARS (GUSEV CRATER)',
  0.89, 'Halite, Gypsum, Sulfates, Evaporites, Clay Minerals', 'Martian Sulfates, Chlorides, Evaporite Deposits',
  3.0, 7.0,
  296.0, 252.0,
  101.0, 0.6,
  'Massive endorheic salt lake (playa) in southern Tunisia rich in gypsum, halite, and clay minerals. Serves as an evaporite basin analog for ancient Martian chloride and sulfate deposits detected by Mars orbiters and rovers.',
  'Massive endorheic salt lake (playa) in southern Tunisia rich in gypsum, halite, and clay minerals. Serves as an evaporite basin analog for ancient Martian chloride and sulfate deposits detected by Mars orbiters and rovers.',
  'Seasonal flooding, shallow water table, and modern Earth atmospheric moisture contrast with long-desiccated Martian evaporite flats.',
  'Seasonal flooding, shallow water table, and modern Earth atmospheric moisture contrast with long-desiccated Martian evaporite flats.'
),
(
  'lonar', '10. Lonar Impact Crater (India)', '10. Lonar Impact Crater (India)', '🇮🇳 Lonar Crater', 'mars', false, false, false,
  19.9767, 76.5083, 14,
  18.38, 77.58, 7, 'Jezero Crater (Mars)',
  'MARS (JEZERO CRATER)', 'MARS (JEZERO CRATER)',
  0.93, 'Deccan Basalt, Impact Breccia, Saponite, Carbonates', 'Martian Basalt, Impact Breccia, Clay Minerals',
  20.5, 15.0,
  299.0, 252.0,
  96.0, 0.65,
  'Unique hypervelocity meteorite impact crater (~52,000 years old, 1.8 km diameter) carved entirely into Deccan Traps basaltic bedrock. One of only four known hypervelocity impact craters in basalt on Earth, providing critical baseline for Martian and lunar basalt shock metamorphism.',
  'Unique hypervelocity meteorite impact crater (~52,000 years old, 1.8 km diameter) carved entirely into Deccan Traps basaltic bedrock. One of only four known hypervelocity impact craters in basalt on Earth, providing critical baseline for Martian and lunar basalt shock metamorphism.',
  'Saline alkaline crater lake in the interior, tropical monsoon rainfall, dense vegetation, and biological ecosystem.',
  'Saline alkaline crater lake in the interior, tropical monsoon rainfall, dense vegetation, and biological ecosystem.'
),
(
  'kamchatka', '11. Kamchatka Volcanic Complex (Russia)', '11. Kamchatka Volcanic Complex (Russia)', '🇷🇺 Kamchatka', 'mars', false, false, false,
  56.056, 160.642, 10,
  32.1, 150.2, 7, 'Hecates Tholus (Mars)',
  'MARS (HECATES THOLUS)', 'MARS (HECATES THOLUS)',
  0.84, 'Basalt, Andesite, Pyroclastic Deposits, Volcanic Ash', 'Martian Basalt, Pyroxene, Olivine, Volcanic Deposits',
  15.0, 15.0,
  265.0, 252.0,
  55.0, 0.6,
  'Subarctic volcanic wilderness with over 30 active stratovolcanoes, basaltic scoria cones, and extensive tephra plains (Tolbachik). Highly relevant analog for cold-climate Martian volcanism and rover autonomous traverse over coarse volcanic ash.',
  'Subarctic volcanic wilderness with over 30 active stratovolcanoes, basaltic scoria cones, and extensive tephra plains (Tolbachik). Highly relevant analog for cold-climate Martian volcanism and rover autonomous traverse over coarse volcanic ash.',
  'Subduction-zone calc-alkaline magmatism, heavy winter snowfall, glacial ice interactions, and active terrestrial biosphere.',
  'Subduction-zone calc-alkaline magmatism, heavy winter snowfall, glacial ice interactions, and active terrestrial biosphere.'
),
(
  'badlands', '12. Badlands National Park (South Dakota, USA)', '12. Badlands National Park (South Dakota, USA)', '🇺🇸 Badlands', 'mars', false, false, false,
  43.834, -102.394, 11,
  -5.0, 137.5, 7, 'Mount Sharp Strata (Mars)',
  'MARS (MOUNT SHARP - GALE CRATER)', 'MARS (MOUNT SHARP - GALE CRATER)',
  0.74, 'Claystone, Siltstone, Sandstone, Volcanic Ash', 'Martian Sedimentary Rocks, Clay Minerals, Sulfates',
  12.0, 15.0,
  283.0, 252.0,
  94.0, 0.6,
  'Sharply eroded sedimentary pinnacles, gullies, and buttes featuring rhythmic alternating clay, siltstone, and volcanic ash paleosol layers. Directly analogous to layered sulfate and clay strata explored by the Curiosity rover at Mount Sharp, Mars.',
  'Sharply eroded sedimentary pinnacles, gullies, and buttes featuring rhythmic alternating clay, siltstone, and volcanic ash paleosol layers. Directly analogous to layered sulfate and clay strata explored by the Curiosity rover at Mount Sharp, Mars.',
  'Fluvial erosion driven by heavy continental rainstorms, seasonal freezing/thawing, and terrestrial vegetation.',
  'Fluvial erosion driven by heavy continental rainstorms, seasonal freezing/thawing, and terrestrial vegetation.'
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

-- 5. VERIFY SEEDED DATA
select id, name_en, body_type, mineral_score, earth_slope, earth_temp_k, earth_pressure_kpa, created_at from public.analog_sites order by created_at asc;
