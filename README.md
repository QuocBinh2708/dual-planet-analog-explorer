# 🚀 Dual-Planet Analog Explorer
### Quantitative Terrestrial Planetary Analog Similarity Framework for the Moon and Mars
**NASA Space Apps Challenge 2024**

An interactive web platform and planetary analog similarity engine that quantitatively evaluates how closely 5 under-explored terrestrial analog environments and 2 gold-standard NASA baselines mimic conditions on the Moon and Mars using multi-source satellite and rover data.

---

## 🌟 Overview & Key Innovations

Instead of selecting analog testing grounds based purely on qualitative or visual resemblance, **Dual-Planet Analog Explorer** applies the mathematically rigorous **Earth Similarity Index (ESI)** (*Schulze-Makuch et al., 2011*) adapted for planetary exploration.

### 7 Key Analog Pairs in the System:
1. **Chư Bluk (Vietnam) ⟷ Marius Hills (Moon):** Southeast Asia's longest lava tube system (>25 km) hosted in young Pleistocene basalts — modeling subsurface radiation-shielded lunar habitats and GPS-denied SLAM navigation.
2. **Lonar Crater (India) ⟷ Jezero Crater (Mars):** Hypervelocity impact crater excavated into Deccan flood basalts with shock-metamorphosed maskelynite glass and smectite clays matching MRO CRISM data.
3. **Qaidam Basin (China) ⟷ Gale Crater (Mars):** High-altitude (2,800 m) hyper-arid evaporite desert (halite, gypsum, MgSO₄) featuring Earth's largest aerodynamic yardang field for aeolian erosion and rover mobility testing.
4. **Dallol Geothermal (Ethiopia) ⟷ Columbia Hills - Gusev (Mars):** Polyextreme hyper-acidic (pH 0.25) and hypersaline volcanic hydrothermal system modeling Noachian Mars (~3.5 Ga) hot springs.
5. **Boulby Mine (United Kingdom) ⟷ Arsia Mons Skylights (Mars):** 1.1 km deep subsurface Permian salt mine hosting the NASA/ESA MINAR facility for deep drilling and dark-zone robotic operations.
6. **⭐ NASA Mars Baseline — Atacama Desert (Chile) ⟷ Elysium Planitia (Mars):** Gold-standard benchmark for hyper-aridity (<1 mm/yr rainfall) and perchlorate chemistry.
7. **⭐ NASA Moon Baseline — Krafla Volcanic Field (Iceland) ⟷ Taurus-Littrow / Apollo 17 (Moon):** Gold-standard benchmark for young tholeiitic basalt terrain, used for Apollo and Artemis EVA training.

---

## 📐 Mathematical Framework: ESI Formulation

Each physical parameter $i$ is mapped to a dimensionless component similarity score $S_i \in [0, 1]$:

$$S_i = 1 - \left| \frac{X_{\text{Earth}, i} - X_{\text{Target}, i}}{X_{\text{Earth}, i} + X_{\text{Target}, i}} \right|$$

The composite **Weighted Analog ESI** is calculated via a weighted geometric mean across 4 mission-specific weights $w_i \in [0, 1]$:

$$ESI_{\text{Analog}} = \left( \prod_{i=1}^{4} \max(\epsilon, S_i)^{w_i} \right)^{\frac{1}{\sum_{i=1}^{4} w_i}} \times 100\%$$

* **Input Parameters:**
  * $S_1$ — **Mineralogy & Lithology:** Indicator mineral assemblages from near-infrared reflectance spectroscopy.
  * $S_2$ — **Topographic Slope (°):** Surface roughness and steepness from DEMs.
  * $S_3$ — **Mean Surface Temperature (K):** Absolute thermodynamic temperature in Kelvin.
  * $S_4$ — **Atmospheric Pressure (kPa):** Boundary control variable with floor threshold $\epsilon = 0.01$ for lunar vacuum comparisons.

---

## 🛰️ NASA & International Datasets Used

* **Earth Data:**
  * NASA POWER Climatology (T2M 2-meter air temperature & surface pressure PS)
  * NASA/METI ASTER GDEM v3 (Elevation and digital slope models)
  * NASA MODIS Terra Land Surface Temperature (LST) Day
  * USGS Macrostrat & EarthExplorer (Lithology and mineral assemblages)
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

## 💻 Deployment & How to Run

### Method 1: Instant Local Browser Run (No installation required)
Just open `index.html` directly in any web browser (Chrome, Edge, Firefox, Safari).

### Method 2: Deploy to GitHub Pages (Recommended for Submission)
1. Create a public repository on GitHub (e.g. `dual-planet-analog-explorer`).
2. Upload `index.html` and `README.md`.
3. In repository **Settings** → **Pages** → Source: **Deploy from a branch** → Branch: `main` → Save.
4. Your site will be live at: `https://[your-username].github.io/dual-planet-analog-explorer/`

### Method 3: Netlify Drop
Drag and drop this project folder into [app.netlify.com/drop](https://app.netlify.com/drop) for instant global deployment.

---

## 📊 Summary of Baseline Scores

| Analog Site (Earth ⟷ Target) | Mineralogy ($S_1$) | Slope ($S_2$) | Temp ($S_3$) | Pressure ($S_4$) | Default ESI |
|---|:---:|:---:|:---:|:---:|:---:|
| **1. Chư Bluk (VN) ⟷ Marius Hills (Moon)** | 90.0% | 97.3% | 92.1% | 0.0% | **93.3%** |
| **2. Lonar Crater (IN) ⟷ Jezero (Mars)** | 95.0% | 90.7% | 84.2% | 1.4% | **91.0%** |
| **3. Qaidam Basin (CN) ⟷ Gale (Mars)** | 92.0% | 83.3% | 89.4% | 2.1% | **87.9%** |
| **4. Dallol (ET) ⟷ Columbia Hills (Mars)** | 88.0% | 83.3% | 81.8% | 1.2% | **84.9%** |
| **5. Boulby Mine (UK) ⟷ Arsia Mons (Mars)** | 89.0% | 77.8% | 87.6% | 0.9% | **84.1%** |
| **⭐ 6. Atacama (CL) ⟷ Elysium (Mars)** | 94.0% | 76.9% | 85.2% | 1.4% | **85.1%** |
| **⭐ 7. Krafla (IS) ⟷ Taurus-Littrow (Moon)**| 93.0% | 95.2% | 95.5% | 0.0% | **94.4%** |

