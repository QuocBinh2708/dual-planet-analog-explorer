# 🚀 KRONOS-SIM: Krông Nô Lunar Analog Mission Control & Dual-Planet Explorer
### Quantitative Planetary Analog Similarity Engine & Mission Simulation Platform
**NASA Space Apps Challenge 2024**

[![GitHub Pages](https://img.shields.io/badge/Live_Demo-GitHub_Pages-38bdf8?style=for-the-badge&logo=github)](https://quocbinh2708.github.io/dual-planet-analog-explorer/)
[![Streamlit App](https://img.shields.io/badge/Python_App-Streamlit_Cloud-FF4B4B?style=for-the-badge&logo=streamlit)](https://mpxbhmbdmjtdaypluadtus.streamlit.app/)

**KRONOS-SIM** is an interactive, quantitative planetary analog mission control platform that evaluates terrestrial environments on Earth against targets on the **Moon** and **Mars** using the **Earth Similarity Index (ESI)** (*Schulze-Makuch et al., 2011*) powered by multi-source NASA satellite and rover datasets.

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

### 2. 🌐 Global Dual-Planet Benchmark (7 Scientific Pairs)
1. **Krông Nô – Chư Bluk (Vietnam) ⟷ Marius Hills (Moon):** [ESI: **93.3%**] Lava tube network for subsurface radiation shielding and GPS-denied SLAM navigation.
2. **Lonar Crater (India) ⟷ Jezero Crater (Mars):** [ESI: **91.0%**] Impact crater in flood basalt matching Perseverance clays and maskelynite shock-glass.
3. **Qaidam Basin (China) ⟷ Gale Crater (Mars):** [ESI: **87.9%**] Hyper-arid salt desert and yardangs for Curiosity rover mobility and wind erosion tests.
4. **Dallol Geothermal (Ethiopia) ⟷ Columbia Hills - Gusev (Mars):** [ESI: **84.9%**] Hyper-acidic (pH 0.25) hydrothermal brines mimicking Noachian Mars (~3.5 Ga) hot springs.
5. **Boulby Mine (United Kingdom) ⟷ Arsia Mons Caves (Mars):** [ESI: **84.1%**] 1.1 km deep salt mine hosting the NASA/ESA MINAR facility for deep drilling without GPS.
6. **⭐ NASA Mars Baseline — Atacama Desert (Chile) ⟷ Elysium Planitia (Mars):** [ESI: **85.1%**] Hyper-arid gold standard with perchlorate-rich soil chemistry.
7. **⭐ NASA Moon Baseline — Krafla Volcanic Field (Iceland) ⟷ Taurus-Littrow / Apollo 17 (Moon):** [ESI: **94.4%**] Young basalt flows used for Apollo astronaut and Artemis EVA suit training.

### 3. 🧑‍🎓 Student Research Sandbox (Custom Analog Site Builder)
Students, researchers, and citizen scientists can add their own analog sites directly into the engine:
* **Interactive Modal Form:** Input Earth coordinates, target planet (Moon/Mars), mineralogy score ($S_1$), slope ($S_2$), temperature ($S_3$), and pressure ($S_4$).
* **3 Quick Vietnam Research Presets:**
  * **Chư Đăng Ya Volcano (Gia Lai):** Cinder cone and scoria tephra matching Hadley Rille (Apollo 15).
  * **Mũi Né Red Sand Dunes (Bình Thuận):** Shifting iron-oxide coastal dunes matching Bagnold Dunes on Mars.
  * **Lý Sơn Volcanic Island (Quảng Ngãi):** Coastal basalt cliffs and tuff cone matching Aristarchus Plateau on the Moon.
* **Persistent Storage:** Custom sites are stored locally via `localStorage` and plotted dynamically with purple map flags.

---

## 📐 Mathematical Framework: ESI Formulation

Each physical parameter $i$ is converted into a dimensionless component score $S_i \in [0, 1]$:

$$S_i = 1 - \left| \frac{X_{\text{Earth}, i} - X_{\text{Target}, i}}{X_{\text{Earth}, i} + X_{\text{Target}, i}} \right|$$

The composite **Weighted Planetary Analog ESI** is calculated via weighted geometric mean:

$$ESI_{\text{Analog}} = \left( \prod_{i=1}^{4} \max(\epsilon, S_i)^{w_i} \right)^{\frac{1}{\sum_{i=1}^{4} w_i}} \times 100\%$$

* **Component Parameters:**
  * $S_1$ — **Mineralogy & Lithology:** Indicator mineral assemblages from infrared reflectance spectra.
  * $S_2$ — **Topographic Slope (°):** Mean slope and ruggedness from digital elevation models (DEMs).
  * $S_3$ — **Mean Surface Temperature (K):** Thermodynamic temperature in Kelvin ($T_K = T_{^\circ\text{C}} + 273.15$).
  * $S_4$ — **Atmospheric Pressure (kPa):** Controlled via boundary floor $\epsilon = 0.01$ to avoid zero-product collapse in lunar vacuum.

### Mission Weight Presets ($w_1, w_2, w_3, w_4$):
* **Surface & Geology (Default):** $w = [1.0, 1.0, 0.5, 0.0]$
* **Rover Mobility Test:** $w = [1.0, 0.9, 0.1, 0.0]$ (Prioritizes wheel traction & terrain slopes)
* **Full Environmental:** $w = [1.0, 0.3, 0.6, 0.2]$ (Incorporates atmospheric differences)

---

## 🛰️ NASA & International Datasets Used

* **Earth Data:**
  * NASA POWER Climatology (T2M 2-meter air temperature & surface pressure PS)
  * NASA/METI ASTER GDEM v3 (Elevation and digital slope models)
  * NASA MODIS Terra Land Surface Temperature (LST) Day
  * USGS Macrostrat Geological Database
* **Lunar Data:**
  * NASA Lunar Reconnaissance Orbiter (LRO) LOLA Altimeter & LROC WAC Global Mosaic
  * NASA Moon Trek WMTS Web Tile Services
  * Clementine UVVIS FeO & Moon Mineralogy Mapper (M³) datasets
* **Martian Data:**
  * NASA Mars Global Surveyor (MGS) MOLA Altimeter
  * NASA Mars Reconnaissance Orbiter (MRO) CRISM Spectral Library
  * NASA Mars Trek WMTS (Viking MDIM21 & MOLA/HRSC DEM Color Relief)
  * MSL Curiosity (CheMin/APXS) & Mars 2020 Perseverance (SHERLOC/PIXL) PDS Reports

---

## 💻 How to Run Locally

### Method 1: Web Version (`index.html`) — No installation required
Simply double-click `index.html` or open it with any web browser (Chrome, Edge, Safari, Firefox).

### Method 2: Python Dashboard (`app.py`)
```powershell
pip install -r requirements.txt
python -m streamlit run app.py
```
Open **http://localhost:8501** in your browser.

---

## 🌐 Live Deployments

* **Web Mission Control (GitHub Pages):** [https://quocbinh2708.github.io/dual-planet-analog-explorer/](https://quocbinh2708.github.io/dual-planet-analog-explorer/)
* **Python Analytical Engine (Streamlit Cloud):** [https://mpxbhmbdmjtdaypluadtus.streamlit.app/](https://mpxbhmbdmjtdaypluadtus.streamlit.app/)
