# 🚀 KRONOS-SIM: Krông Nô Lunar Analog Mission Control & Dual-Planet Explorer
### Quantitative Planetary Analog Similarity Engine & Mission Simulation Platform
**NASA Space Apps Challenge 2024**

[![GitHub Pages](https://img.shields.io/badge/Live_Demo-GitHub_Pages-38bdf8?style=for-the-badge&logo=github)](https://quocbinh2708.github.io/dual-planet-analog-explorer/)
[![Streamlit App](https://img.shields.io/badge/Python_App-Streamlit_Cloud-FF4B4B?style=for-the-badge&logo=streamlit)](https://mpxbhmbdmjtdaypluadtus.streamlit.app/)

**KRONOS-SIM** is an interactive, quantitative planetary analog mission control platform that evaluates terrestrial environments on Earth against targets on the **Moon** and **Mars** using the **Earth Similarity Index (ESI)** (*Schulze-Makuch et al., 2011*) powered by multi-source NASA satellite and rover datasets, integrated with **Supabase Cloud Database**.

---

## 🌟 Key Capabilities & Architecture

### 1. 🇻🇳 Krông Nô Volcanic Cave Network (Vietnam Primary Focus)
* **The Longest Lava Tube System in Southeast Asia:** Over 25 km of subterranean tubes in the Dak Nong UNESCO Global Geopark erupted from the Chư Bluk volcano.
* **Specialized Cave Explorer Mode:**
  * **Hang C7 (1,266.5 m):** Longest volcanic cave in SE Asia; massive basalt ceiling and collapsed skylight directly analogous to the Marius Hills pit on the Moon. Tested for inflatable habitat deployment and radiation shielding.
  * **Hang A1 (456.7 m):** High vertical skylight drop; ideal for testing autonomous drone descent and tethered robotic rappelling.
  * **Hang C3 (594.4 m):** Complex multi-level lava branching; tests multi-agent swarm exploration in GPS-denied environments.
  * **Hang C8 (~320 m):** Thick ceiling insulation maintaining steady microclimate temperatures (~24°C year-round).
  * **Chư Bluk Volcano (Source):** Vent morphology analogous to lunar volcanic domes and rilles.

### 2. 🌐 Global Dual-Planet Benchmark (12 Scientific Pairs)
1. **🇻🇳 Krông Nô – Chư Bluk (Vietnam) ⟷ Marius Hills (Moon):** Subsurface lava tube system for radiation shielding and GPS-denied SLAM robotics.
2. **🇪🇸 Đảo Lanzarote (Spain) ⟷ Arsia Mons Skylights (Mars):** Young volcanic terrain and lava tubes (ESA PANGEA analog).
3. **🇺🇸 Meteor Crater (Arizona, USA) ⟷ Gale Crater Rim (Mars):** Impact crater in sedimentary rock preserving shock-metamorphism ejecta.
4. **🇺🇸 Craters of the Moon (Idaho, USA) ⟷ Hadley Rille - Apollo 15 (Moon):** Extensive basaltic lava flows and fissure eruptions.
5. **🇮🇳 Thung lũng Lamayuru (Ladakh, India) ⟷ Eberswalde Crater (Mars):** High-altitude hyper-arid paleolake sedimentary strata ("Moonland").
6. **🇳🇦 Moon Landscape (Namib Desert, Namibia) ⟷ Bagnold Dunes - Gale (Mars):** Aeolian sand dunes and deeply eroded badlands.
7. **⭐ 🇨🇱 Valle de la Luna (Atacama, Chile) ⟷ Meridiani Planum (Mars):** NASA standard Mars hyper-arid evaporite and rover mobility benchmark.
8. **⭐ 🇮🇸 Cao nguyên Krafla (Iceland) ⟷ Taurus-Littrow - Apollo 17 (Moon):** NASA standard Moon basalt flow benchmark used for Apollo and Artemis EVA training.
9. **🇹🇳 Chott el Djerid (Tunisia) ⟷ Gusev Crater Paleolake (Mars):** Large saline playa with evaporite minerals and sulfate crusts.
10. **🇮🇳 Miệng núi lửa Lonar (India) ⟷ Jezero Crater (Mars):** Impact crater in Deccan flood basalt matching Jezero clay & impact breccia.
11. **🇷🇺 Vùng núi lửa Kamchatka (Russia) ⟷ Hecates Tholus (Mars):** Stratovolcano complex and cryovolcanic volcanic/ice interactions.
12. **🇺🇸 Badlands National Park (USA) ⟷ Mount Sharp Strata - Gale (Mars):** Layered clay-rich sedimentary formations and rover stratigraphic testing.

---

## 🗄️ Project Structure & Organization

```
dual-planet-analog-explorer/
├── index.html               # Main Web Mission Control & Interactive Simulator
├── supabase_setup.sql       # PostgreSQL / Supabase Schema & 12 Sites Seed SQL
├── app.py                   # Python Streamlit Mission Control Application
├── requirements.txt         # Python Dependencies for Streamlit App
├── run_app.bat              # One-click Windows Runner for Streamlit App
├── README.md                # Project Documentation
├── .gitignore               # Git Ignore Rules
├── docs/                    # Research, NASA Methodology & Data Collection Guides
│   ├── Cam_nang_Thu_thap_Xu_ly_du_lieu_NASA_Space_Apps.docx
│   ├── Code_va_thuyet_trinh.docx
│   ├── Du_lieu_nasa.docx
│   ├── Huong_Dan_Sinh_Vien_Thu_Thap_Du_Lieu_KRONOS_SIM.docx
│   ├── Krong_No_ESI_Tinh_Diem.xlsx
│   ├── Thuyet_minh_de_tai.docx
│   └── Thuyet_minh_phuong_phap_NASA.txt
└── archive/                 # Historical Version Backups & Legacy HTML
    ├── index-v2.html
    ├── index_v1_backup.html
    ├── index_pre_redesign.html
    └── kronos_sim_kr_ng_n_lunar_analog_mission_control.html
```

---

## 📐 Mathematical Framework: ESI Formulation

Each parameter $i$ is converted into a dimensionless component score $S_i \in [0, 1]$:

$$S_i = 1 - \left| \frac{X_{\text{Earth}, i} - X_{\text{Target}, i}}{X_{\text{Earth}, i} + X_{\text{Target}, i}} \right|$$

The composite **Weighted Planetary Analog ESI** is calculated via weighted geometric mean:

$$ESI_{\text{Analog}} = \left( \prod_{i=1}^{n} \max(\epsilon, S_i)^{w_i} \right)^{\frac{1}{\sum_{i=1}^{n} w_i}} \times 100\%$$

* **Evaluated Criteria (4 Quantitative NASA Parameters):**
  1. $w_1$ — **Mineralogy & Lithology:** Indicator mineral assemblages from infrared reflectance spectra & petrology.
  2. $w_2$ — **Topographic Slope (°):** Mean slope and ruggedness from digital elevation models (DEMs).
  3. $w_3$ — **Mean Surface Temperature (K):** Thermodynamic temperature in Kelvin ($T_K = T_{^\circ\text{C}} + 273.15$).
  4. $w_4$ — **Atmospheric Pressure (kPa):** Controlled via boundary floor $\epsilon = 0.01$ to avoid zero-product collapse in vacuum.

### Mission Weight Presets ($w_1, w_2, w_3, w_4$):
* **Surface & Geology (Default):** $w = [1.0, 1.0, 0.5, 0.0]$
* **Rover Mobility Test:** $w = [1.0, 0.9, 0.1, 0.0]$
* **Full Environmental (Incl. Pressure):** $w = [1.0, 0.3, 0.6, 0.2]$

---

## ☁️ Supabase Cloud Integration

* **Project URL:** `https://prhngciivgzoarwoburu.supabase.co`
* **Real-time Sync:** Supports bidirectional real-time synchronization between the web client and PostgreSQL database via Supabase JS v2.
* **Setup SQL:** Simply copy and run `supabase_setup.sql` in the Supabase SQL Editor to initialize tables, enable RLS policies, and populate all 12 analog sites.

---

## 💻 How to Run Locally

### Method 1: Web Version (`index.html`) — No installation required
Simply double-click `index.html` or open it with any web browser (Chrome, Edge, Firefox, Safari).

### Method 2: Python Dashboard (`app.py`)
```powershell
pip install -r requirements.txt
python -m streamlit run app.py
```
Open **http://localhost:8501** in your browser.
