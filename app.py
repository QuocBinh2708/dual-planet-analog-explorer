import io
import numpy as np
import pandas as pd
import streamlit as st
import plotly.graph_objects as go
import folium
from streamlit_folium import st_folium

st.set_page_config(
    page_title="Dual-Planet & Krông Nô Analog Explorer",
    page_icon="🚀",
    layout="wide"
)

# ==============================================================================
# DATASET DUAL-PLANET (Khớp chuẩn 100% tài liệu Code của du an.docx & Dữ liệu nasa.docx)
# ==============================================================================
DUAL_PLANET_SITES = [
    {
        "id": "chubluk",
        "name": "1. Chư Bluk (Việt Nam)",
        "target": "Mặt Trăng (Marius Hills)",
        "target_body": "MOON (MARIUS HILLS)",
        "body_type": "moon",
        "is_baseline": False,
        "earth_coords": [12.485, 107.902],
        "planet_coords": [14.0, -56.0],
        "earth": {"slope": 9.0, "temp_k": 296.6, "temp_c": 23.5, "pressure_kpa": 96.0, "mineral_s": 0.90, "mineral_text": "Bazan trẻ (FeO 12%)"},
        "planet": {"slope": 9.5, "temp_k": 253.0, "temp_c": -20.1, "pressure_kpa": 0.0, "mineral_s": 0.90, "mineral_text": "Bazan biển (FeO 17%)"},
        "geology": "Hệ thống hang động ống dung nham dài nhất Đông Nam Á (>25 km, >100 hang) trên nền đá bazan trẻ Pleistocen. Lý tưởng để thử nghiệm định vị SLAM không GPS, radar xuyên đất (GPR) và thiết kế căn cứ ngầm tránh bức xạ.",
        "limits": "Khí hậu nhiệt đới gió mùa gây thảm thực vật dày và phong hóa hóa học mạnh; chịu trọng lực 1g (gấp 6 lần Mặt Trăng) và có khí quyển."
    },
    {
        "id": "lonar",
        "name": "2. Hố Lonar (Ấn Độ)",
        "target": "Sao Hỏa (Hố Jezero)",
        "target_body": "MARS (JEZERO CRATER)",
        "body_type": "mars",
        "is_baseline": False,
        "earth_coords": [19.976, 76.508],
        "planet_coords": [18.38, 77.58],
        "earth": {"slope": 20.5, "temp_k": 300.1, "temp_c": 27.0, "pressure_kpa": 95.0, "mineral_s": 0.95, "mineral_text": "Bazan, Maskelynite, Smectite"},
        "planet": {"slope": 17.0, "temp_k": 218.1, "temp_c": -55.0, "pressure_kpa": 0.65, "mineral_s": 0.95, "mineral_text": "Bazan, Olivine, Smectite"},
        "geology": "Hố va chạm thiên thạch tốc độ siêu cao (đường kính 1,83 km) đào trực tiếp vào nền đá bazan Deccan. Chứa thủy tinh va chạm maskelynite, khoáng sét smectite và carbonat trùng khớp quan sát của tàu MRO CRISM và xe tự hành Perseverance.",
        "limits": "Đáy hố chứa hồ nước mặn siêu kiềm với hệ sinh thái vi sinh hoạt động và chịu ảnh hưởng mùa mưa nhiệt đới."
    },
    {
        "id": "qaidam",
        "name": "3. Bồn địa Qaidam (Trung Quốc)",
        "target": "Sao Hỏa (Hố Gale)",
        "target_body": "MARS (GALE CRATER)",
        "body_type": "mars",
        "is_baseline": False,
        "earth_coords": [37.500, 94.500],
        "planet_coords": [-5.4, 137.8],
        "earth": {"slope": 2.5, "temp_k": 276.1, "temp_c": 3.0, "pressure_kpa": 71.0, "mineral_s": 0.92, "mineral_text": "Halite, Gypsum, MgSO₄"},
        "planet": {"slope": 3.5, "temp_k": 223.1, "temp_c": -50.0, "pressure_kpa": 0.75, "mineral_s": 0.92, "mineral_text": "Gypsum, MgSO₄, Phyllosilicates"},
        "geology": "Hoang mạc độ cao lớn (~2.800 m) siêu khô hạn giàu muối bay hơi (halite, gypsum, magnesi sulfat) và đồi gió mòn yardangs lớn nhất Trái Đất. Giúp mô phỏng tốc độ xói mòn gió Sao Hỏa và thử nghiệm di chuyển xe rover trên đất bụi mịn.",
        "limits": "Áp suất khí quyển (~71 kPa) vẫn cao hơn >100 lần Sao Hỏa (~0,75 kPa), hàm lượng O₂ khí quyển cao gây cơ chế oxy hóa khác biệt."
    },
    {
        "id": "dallol",
        "name": "4. Địa nhiệt Dallol (Ethiopia)",
        "target": "Sao Hỏa (Columbia Hills - Gusev)",
        "target_body": "EARLY MARS (GUSEV CRATER)",
        "body_type": "mars",
        "is_baseline": False,
        "earth_coords": [14.242, 40.300],
        "planet_coords": [-14.5, 175.4],
        "earth": {"slope": 5.0, "temp_k": 307.7, "temp_c": 34.6, "pressure_kpa": 102.0, "mineral_s": 0.88, "mineral_text": "Jarosite, Fe-Salts, Lưu huỳnh"},
        "planet": {"slope": 7.0, "temp_k": 213.1, "temp_c": -60.0, "pressure_kpa": 0.62, "mineral_s": 0.88, "mineral_text": "Opaline Silica, Jarosite"},
        "geology": "Hệ thống thủy nhiệt núi lửa đa cực đoan (pH chạm 0,25, nước muối bão hòa >35%, kết tủa giàu sắt và lưu huỳnh) mô phỏng suối nước nóng Sao Hỏa thời kỳ Noachian (~3,5 tỷ năm trước).",
        "limits": "Nhiệt độ không khí trung bình năm cao nhất Trái Đất (+34,6°C / 307,7 K), tương phản hoàn toàn với nhiệt độ đóng băng lạnh giá của Sao Hỏa hiện nay (-60°C)."
    },
    {
        "id": "boulby",
        "name": "5. Hầm mỏ Boulby (Vương quốc Anh)",
        "target": "Sao Hỏa (Sườn Arsia Mons)",
        "target_body": "SUBSURFACE MARS & MOON",
        "body_type": "mars",
        "is_baseline": False,
        "earth_coords": [54.555, -0.825],
        "planet_coords": [-11.5, -121.0],
        "earth": {"slope": 3.5, "temp_k": 301.6, "temp_c": 28.5, "pressure_kpa": 112.0, "mineral_s": 0.89, "mineral_text": "Halite, Sylvite, Polyhalite"},
        "planet": {"slope": 5.5, "temp_k": 235.0, "temp_c": -38.1, "pressure_kpa": 0.50, "mineral_s": 0.89, "mineral_text": "Muối Sulfat & Clorua ngầm"},
        "geology": "Mỏ muối kỷ Permi sâu 1,1 km dưới lòng đất, nơi đặt cơ sở nghiên cứu MINAR của NASA/ESA. Môi trường tối hoàn toàn, không GPS, che chắn bức xạ vũ trụ tối đa để thử nghiệm robot tự hành dưới ngầm và thiết bị khoan sâu.",
        "limits": "Gradient địa nhiệt làm nhiệt độ môi trường tăng cao (~28,5°C) và áp suất tăng lên (~112 kPa), trái ngược với hang ngầm Sao Hỏa lạnh giá và áp suất thấp."
    },
    {
        "id": "atacama",
        "name": "⭐ 6. Sa mạc Atacama (Mốc chuẩn Sao Hỏa)",
        "target": "Sao Hỏa (Elysium Planitia)",
        "target_body": "MARS GOLD-STANDARD BASELINE",
        "body_type": "mars",
        "is_baseline": True,
        "earth_coords": [-24.095, -69.925],
        "planet_coords": [4.5, 135.6],
        "earth": {"slope": 4.0, "temp_k": 289.6, "temp_c": 16.5, "pressure_kpa": 90.0, "mineral_s": 0.94, "mineral_text": "Halite, Gypsum, Perchlorate"},
        "planet": {"slope": 2.5, "temp_k": 215.1, "temp_c": -58.0, "pressure_kpa": 0.65, "mineral_s": 0.94, "mineral_text": "Bazan khô, Sulfate, Perchlorate"},
        "geology": "MỐC CHUẨN KINH ĐIỂN CỦA NASA: Vùng lõi Yungay siêu khô hạn (<1 mm mưa/năm) giàu muối perchlorate và sinh khối vi sinh cực thấp, là bãi thử nghiệm chuẩn mực cho các nhiệm vụ Viking, Curiosity và Perseverance.",
        "limits": "Nằm ở độ cao ~1.000 m nên áp suất khí quyển (~90 kPa) vẫn cao và chu kỳ nhiệt độ bề mặt theo ngày kiểu Trái Đất."
    },
    {
        "id": "krafla",
        "name": "⭐ 7. Cánh đồng Krafla (Mốc chuẩn Mặt Trăng)",
        "target": "Mặt Trăng (Taurus-Littrow / Apollo 17)",
        "target_body": "MOON GOLD-STANDARD BASELINE",
        "body_type": "moon",
        "is_baseline": True,
        "earth_coords": [65.715, -16.755],
        "planet_coords": [20.19, 30.77],
        "earth": {"slope": 10.0, "temp_k": 274.6, "temp_c": 1.5, "pressure_kpa": 96.0, "mineral_s": 0.93, "mineral_text": "Bazan trẻ, Thủy tinh núi lửa"},
        "planet": {"slope": 11.0, "temp_k": 251.1, "temp_c": -22.0, "pressure_kpa": 0.0, "mineral_s": 0.93, "mineral_text": "Bazan biển, Ilmenite, Tro thủy tinh"},
        "geology": "MỐC CHUẨN KINH ĐIỂN CỦA NASA: Từng là nơi huấn luyện trực tiếp cho phi hành gia Apollo và bộ đồ du hành Artemis. Dòng dung nham tholeiitic trẻ không có thực vật, nón xỉ và tro núi lửa mài mòn tái hiện độ nhám bề mặt biển Mặt Trăng.",
        "limits": "Chịu tác động của chu kỳ băng tuyết theo mùa, phong hóa khí quyển Trái Đất và lực hấp dẫn 1g."
    }
]

def comp_esi(x_earth, x_target):
    if x_earth + x_target == 0:
        return 1.0
    return 1.0 - abs(x_earth - x_target) / (x_earth + x_target)

def calculate_site_metrics(site, w1, w2, w3, w4):
    s1 = site["earth"]["mineral_s"]
    s2 = comp_esi(site["earth"]["slope"], site["planet"]["slope"])
    s3 = comp_esi(site["earth"]["temp_k"], site["planet"]["temp_k"])
    s4 = comp_esi(site["earth"]["pressure_kpa"], site["planet"]["pressure_kpa"])
    
    sum_w = w1 + w2 + w3 + w4
    if sum_w <= 0:
        esi = 0.0
    else:
        # Ngưỡng sàn epsilon = 0.01 cho áp suất và các thành phần để tránh triệt tiêu ESI ở môi trường chân không Mặt Trăng
        prod = (max(0.01, s1) ** w1) * (max(0.01, s2) ** w2) * (max(0.01, s3) ** w3) * (max(0.01, s4) ** w4)
        esi = (prod ** (1.0 / sum_w)) * 100.0
    return {"s1": s1, "s2": s2, "s3": s3, "s4": s4, "esi": esi}

# ==============================================================================
# ĐIỀU HƯỚNG THANH BÊN (SIDEBAR)
# ==============================================================================
st.sidebar.title("🚀 NASA Space Apps 2024")
app_mode = st.sidebar.radio(
    "Chọn chế độ nghiên cứu:",
    [
        "🌐 Dual-Planet Analog Explorer (7 Cặp Địa Điểm NASA)",
        "🌑 Chuyên Sâu Hang Núi Lửa Krông Nô (Vi Khí Hậu & Địa Hóa 7 Tiêu Chí)"
    ]
)

# ==============================================================================
# CHẾ ĐỘ 1: DUAL-PLANET ANALOG EXPLORER (KHỚP HOÀN TOÀN TÀI LIỆU MỚI)
# ==============================================================================
if app_mode.startswith("🌐 Dual-Planet"):
    st.title("🌐 Dual-Planet Analog Explorer")
    st.caption("Nền tảng Định lượng Tương đồng Môi trường Mô phỏng Trái Đất – Mặt Trăng & Sao Hỏa (Schulze-Makuch et al., 2011)")
    
    # Bộ thiết lập trọng số (Mission Presets)
    st.sidebar.markdown("### 🎛️ Bộ trọng số nhiệm vụ")
    preset = st.sidebar.selectbox(
        "Kịch bản thử nghiệm:",
        ["Mặc định: Địa chất & Bề mặt", "Thử nghiệm Rover & Độ dốc", "Môi trường toàn diện (Kèm Áp suất)", "Tùy chỉnh"]
    )
    
    if preset == "Mặc định: Địa chất & Bề mặt":
        w1_def, w2_def, w3_def, w4_def = 1.0, 1.0, 0.5, 0.0
    elif preset == "Thử nghiệm Rover & Độ dốc":
        w1_def, w2_def, w3_def, w4_def = 1.0, 0.9, 0.1, 0.0
    elif preset == "Môi trường toàn diện (Kèm Áp suất)":
        w1_def, w2_def, w3_def, w4_def = 1.0, 0.3, 0.6, 0.2
    else:
        w1_def, w2_def, w3_def, w4_def = 1.0, 1.0, 0.5, 0.0

    is_custom = (preset == "Tùy chỉnh")
    w1 = st.sidebar.slider("w₁: Khoáng vật & Thạch học", 0.0, 1.0, float(w1_def), 0.1, disabled=not is_custom)
    w2 = st.sidebar.slider("w₂: Độ dốc địa hình (Slope)", 0.0, 1.0, float(w2_def), 0.1, disabled=not is_custom)
    w3 = st.sidebar.slider("w₃: Nhiệt độ bề mặt (Kelvin)", 0.0, 1.0, float(w3_def), 0.1, disabled=not is_custom)
    w4 = st.sidebar.slider("w₄: Áp suất khí quyển (kPa)", 0.0, 1.0, float(w4_def), 0.1, disabled=not is_custom)
    
    st.sidebar.info("💡 **Ghi chú NASA:** Áp suất khí quyển mặc định $w_4 = 0$ khi thử nghiệm địa chất / xe rover; khi so sánh môi trường toàn diện sử dụng ngưỡng sàn $\\epsilon = 0.01$ để tránh sụp đổ tích ở chân không Mặt Trăng.")

    # Chọn địa điểm
    site_names = [s["name"] for s in DUAL_PLANET_SITES]
    selected_name = st.selectbox("🎯 Chọn địa điểm phân tích chi tiết:", site_names, index=0)
    cur_site = next(s for s in DUAL_PLANET_SITES if s["name"] == selected_name)
    cur_metrics = calculate_site_metrics(cur_site, w1, w2, w3, w4)

    # Hiển thị Scorecard
    col_score1, col_score2, col_score3, col_score4 = st.columns(4)
    col_score1.metric("🎯 Điểm ESI Tổng hợp", f"{cur_metrics['esi']:.1f}%")
    col_score2.metric("Hành tinh đích", cur_site["target"])
    col_score3.metric("Phân loại", "⭐ NASA Baseline" if cur_site["is_baseline"] else "Khám phá tiềm năng")
    col_score4.metric("Loại thiên thể", "Mặt Trăng 🌑" if cur_site["body_type"] == "moon" else "Sao Hỏa 🔴")

    tab_overview, tab_all_table, tab_charts, tab_map_view = st.tabs(
        ["📋 Chi tiết Cặp Đối Chiếu", "📊 Bảng Tổng Hợp 7 Địa Điểm", "📈 Biểu Đồ Radar & Xếp Hạng", "🗺️ Bản Đồ Vệ Tinh NASA"]
    )

    with tab_overview:
        c_left, c_right = st.columns([1.2, 1])
        with c_left:
            st.markdown(f"### {cur_site['name']}")
            st.markdown(f"**Mục tiêu đối chiếu:** `{cur_site['target_body']}`")
            
            # Bảng thông số định lượng
            df_params = pd.DataFrame({
                "Thông số": ["Khoáng vật & Thạch học", "Độ dốc địa hình trung bình", "Nhiệt độ bề mặt", "Áp suất khí quyển"],
                "Trái Đất (NASA/USGS)": [
                    cur_site["earth"]["mineral_text"],
                    f"{cur_site['earth']['slope']}°",
                    f"{cur_site['earth']['temp_k']} K ({cur_site['earth']['temp_c']}°C)",
                    f"{cur_site['earth']['pressure_kpa']} kPa"
                ],
                "Hành tinh đích (NASA PDS)": [
                    cur_site["planet"]["mineral_text"],
                    f"{cur_site['planet']['slope']}°",
                    f"{cur_site['planet']['temp_k']} K ({cur_site['planet']['temp_c']}°C)",
                    f"{cur_site['planet']['pressure_kpa']} kPa"
                ],
                "Điểm thành phần (Sᵢ)": [
                    f"{cur_metrics['s1']*100:.1f}%",
                    f"{cur_metrics['s2']*100:.1f}%",
                    f"{cur_metrics['s3']*100:.1f}%",
                    f"{cur_metrics['s4']*100:.1f}%"
                ]
            })
            st.dataframe(df_params, hide_index=True, use_container_width=True)
            
            st.markdown("#### 🚀 Ý nghĩa địa chất & Khả năng thử nghiệm nhiệm vụ")
            st.info(cur_site["geology"])
            
            st.markdown("#### ⚠️ Giới hạn địa chất trên Trái Đất (Key Discrepancies)")
            st.warning(cur_site["limits"])

        with c_right:
            st.markdown("### 🕸️ Hồ sơ ESI đa chiều")
            fig_radar = go.Figure()
            radar_labels = ["Khoáng vật", "Độ dốc", "Nhiệt độ", "Áp suất"]
            radar_vals = [cur_metrics["s1"], cur_metrics["s2"], cur_metrics["s3"], cur_metrics["s4"]]
            # Khép kín đường radar
            radar_labels_closed = radar_labels + [radar_labels[0]]
            radar_vals_closed = radar_vals + [radar_vals[0]]
            
            trace_color = "#f59e0b" if cur_site["is_baseline"] else "#38bdf8"
            fig_radar.add_trace(go.Scatterpolar(
                r=radar_vals_closed,
                theta=radar_labels_closed,
                fill="toself",
                name=cur_site["name"],
                line=dict(color=trace_color, width=2.5),
                fillcolor="rgba(56, 189, 248, 0.25)" if not cur_site["is_baseline"] else "rgba(245, 158, 11, 0.25)"
            ))
            fig_radar.update_layout(
                polar=dict(
                    radialaxis=dict(visible=True, range=[0, 1], tickfont=dict(size=10)),
                    angularaxis=dict(tickfont=dict(size=12, color="#cbd5e1"))
                ),
                height=380,
                margin=dict(l=40, r=40, t=30, b=30),
                paper_bgcolor="rgba(0,0,0,0)",
                plot_bgcolor="rgba(0,0,0,0)"
            )
            st.plotly_chart(fig_radar, use_container_width=True)

    with tab_all_table:
        st.subheader("📊 Bảng dữ liệu định lượng và Điểm ESI của cả 7 địa điểm")
        rows = []
        for s in DUAL_PLANET_SITES:
            m = calculate_site_metrics(s, w1, w2, w3, w4)
            rows.append({
                "Địa điểm Trái Đất": s["name"],
                "Hành tinh đích": s["target"],
                "Khoáng vật S₁": f"{m['s1']*100:.1f}%",
                "Độ dốc S₂": f"{m['s2']*100:.1f}%",
                "Nhiệt độ S₃": f"{m['s3']*100:.1f}%",
                "Áp suất S₄": f"{m['s4']*100:.1f}%",
                "ESI Tổng hợp": f"{m['esi']:.1f}%",
                "Phân loại": "⭐ NASA Baseline" if s["is_baseline"] else "Ứng viên mới"
            })
        st.dataframe(pd.DataFrame(rows), hide_index=True, use_container_width=True)
        st.caption("Công thức Schulze-Makuch (2011): Sᵢ = 1 − |X_Earth − X_Target| / (X_Earth + X_Target); ESI = [ Π max(0.01, Sᵢ)^wᵢ ]^(1 / Σwᵢ)")

    with tab_charts:
        st.subheader("📈 So sánh Xếp hạng ESI giữa các địa điểm")
        all_metrics = [calculate_site_metrics(s, w1, w2, w3, w4)["esi"] for s in DUAL_PLANET_SITES]
        site_labels = [s["name"] for s in DUAL_PLANET_SITES]
        colors = ["#f59e0b" if s["is_baseline"] else "#38bdf8" for s in DUAL_PLANET_SITES]
        
        fig_bar = go.Figure(go.Bar(
            x=site_labels,
            y=all_metrics,
            marker_color=colors,
            text=[f"{v:.1f}%" for v in all_metrics],
            textposition="auto"
        ))
        fig_bar.update_layout(
            yaxis_title="Weighted ESI (%)",
            yaxis_range=[0, 100],
            height=420,
            margin=dict(l=20, r=20, t=30, b=80)
        )
        st.plotly_chart(fig_bar, use_container_width=True)
        st.info("Màu vàng (⭐) đại diện cho 2 mốc chuẩn kinh điển của NASA (Atacama cho Sao Hỏa và Krafla cho Mặt Trăng). Màu xanh là 5 địa điểm tiềm năng đang được định lượng.")

    with tab_map_view:
        st.subheader(f"🗺️ Tọa độ thực địa: {cur_site['name']} & {cur_site['target']}")
        c_map1, c_map2 = st.columns(2)
        with c_map1:
            st.markdown(f"#### 🌍 Vị trí trên Trái Đất: {cur_site['name']}")
            m_earth = folium.Map(location=cur_site["earth_coords"], zoom_start=11, tiles=None)
            folium.TileLayer("https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                             attr="Esri World Imagery", name="Ảnh vệ tinh").add_to(m_earth)
            folium.Marker(cur_site["earth_coords"], tooltip=cur_site["name"], icon=folium.Icon(color="blue", icon="info-sign")).add_to(m_earth)
            st_folium(m_earth, width=540, height=380, key=f"map_earth_{cur_site['id']}")

        with c_map2:
            st.markdown(f"#### 🌑/🔴 Vị trí trên {cur_site['target']}")
            m_planet = folium.Map(location=cur_site["planet_coords"], zoom_start=4, tiles=None, crs="EPSG4326")
            if cur_site["body_type"] == "moon":
                folium.TileLayer(
                    "https://trek.nasa.gov/tiles/Moon/EQ/LRO_WAC_Mosaic_Global_303ppd_v02/1.0.0/default/default028mm/{z}/{y}/{x}.jpg",
                    attr="NASA Moon Trek (LRO WAC)", name="LRO WAC", max_zoom=7
                ).add_to(m_planet)
            else:
                folium.TileLayer(
                    "https://trek.nasa.gov/tiles/Mars/EQ/Mars_Viking_MDIM21_ClrMosaic_global_232m/1.0.0/default/default028mm/{z}/{y}/{x}.jpg",
                    attr="NASA Mars Trek (Viking MDIM21)", name="Mars Viking", max_zoom=7
                ).add_to(m_planet)
            folium.Marker(cur_site["planet_coords"], tooltip=cur_site["target"], icon=folium.Icon(color="red", icon="flag")).add_to(m_planet)
            st_folium(m_planet, width=540, height=380, key=f"map_planet_{cur_site['id']}")

# ==============================================================================
# CHẾ ĐỘ 2: CHUYÊN SÂU HANG KRÔNG NÔ (GIỮ NGUYÊN BẢN GỐC & CẢI TIẾN TRÁNH CRASH)
# ==============================================================================
else:
    st.title("🌑 Krông Nô Planetary Analog Explorer (Chuyên Sâu)")
    st.markdown("Đánh giá định lượng mức tương đồng giữa **Hang C7, Hang A1 (Krông Nô)** và hố sụt **Mare Tranquillitatis** bằng Weighted ESI trên 7 tiêu chí.")

    CRITERIA = ["SiO₂ (%)", "FeO (%)", "TiO₂ (%)", "Mật độ đá (g/cm³)",
                "Hiệu suất đệm nhiệt (%)", "Độ dày trần (m)", "Gia tốc trọng trường (m/s²)"]
    SITE_NAMES = ["Hang C7", "Hang A1", "Hawaii (tùy chọn)"]
    SITE_COLORS = ["#1f77b4", "#2ca02c", "#ff7f0e"]

    PROFILES = {
        "Cân bằng (mặc định)": [1.0, 1.0, 0.8, 1.0, 1.2, 0.8, 1.0],
        "Ưu tiên vi khí hậu": [0.5, 0.5, 0.5, 0.5, 2.0, 1.0, 1.0],
        "Ưu tiên kết cấu & GPR": [1.0, 1.5, 1.5, 1.5, 0.5, 1.0, 1.0],
        "Đều (wᵢ = 1)": [1.0] * 7,
    }

    STATUS_OPTIONS = ["Minh họa", "Ước tính / mô hình", "Đã xác minh", "Hằng số"]

    DEFAULT_DATA = pd.DataFrame({
        "Thông số": ["SiO₂", "FeO", "TiO₂", "Mật độ đá", "Độ dày trần hang", "Gia tốc trọng trường",
                     "Biên độ nhiệt trong hang", "Biên độ nhiệt bề mặt"],
        "Đơn vị": ["%", "%", "%", "g/cm³", "m", "m/s²", "°C", "°C"],
        "Mặt Trăng": [42.0, 16.5, 7.5, 3.10, 35.0, 1.62, 2.0, 330.0],
        "Hang C7": [48.5, 11.2, 2.1, 2.85, 10.0, 9.81, 0.8, 11.5],
        "Hang A1": [48.8, 11.0, 2.0, 2.82, 8.5, 9.81, 1.2, 11.5],
        "Hawaii (tùy chọn)": [49.2, 11.5, 2.4, 2.90, 12.0, 9.81, 1.0, 12.0],
        "Nguồn / ghi chú": [
            "Mặt Trăng: Lunar Sample Compendium. Krông Nô: báo cáo khảo sát",
            "Như trên",
            "Mặt Trăng: bản đồ TiO₂ + mẫu Apollo. Krông Nô: phân tích địa hóa",
            "Mẫu Apollo; đo mẫu đá Krông Nô",
            "Mặt Trăng: chưa có nguồn cho 35 m",
            "Hằng số vật lý chuẩn",
            "Mặt Trăng: giả định (nguồn chỉ nói dao động nhẹ quanh ~17 °C)",
            "Krông Nô: tự tính từ CSV NASA POWER (T2M_RANGE). Mặt Trăng: ~ −180 → +150 °C",
        ],
        "Trạng thái": ["Minh họa"] * 5 + ["Hằng số"] + ["Minh họa"] * 2,
    })

    def parse_power(raw: bytes) -> pd.DataFrame:
        lines = raw.decode("utf-8", errors="ignore").splitlines()
        skip = next((i + 1 for i, l in enumerate(lines) if "END HEADER" in l), 0)
        df_pw = pd.read_csv(io.StringIO("\n".join(lines[skip:])))
        df_pw = df_pw.replace(-999, np.nan).replace(-999.0, np.nan)
        return df_pw

    def similarity(moon, earth):
        return 1.0 - np.abs(moon[:, None] - earth) / (moon[:, None] + earth)

    def esi_calc(S, w):
        w = np.asarray(w, dtype=float)
        if w.sum() == 0:
            return np.zeros(S.shape[1])
        return np.exp((w[:, None] * np.log(np.clip(S, 1e-9, None))).sum(axis=0) / w.sum())

    st.sidebar.header("⚙️ Trọng số sứ mệnh Krông Nô")
    profile = st.sidebar.selectbox("Mục tiêu sứ mệnh", list(PROFILES.keys()) + ["Tùy chỉnh"])
    base_w = PROFILES.get(profile, PROFILES["Đều (wᵢ = 1)"])
    custom = profile == "Tùy chỉnh"
    weights = [st.sidebar.slider(c, 0.0, 2.0, float(base_w[i]), 0.1, disabled=not custom, key=f"w_kno_{profile}_{i}")
               for i, c in enumerate(CRITERIA)]
    show_hw = st.sidebar.checkbox("So sánh với Hawaii (số liệu tùy chọn)", value=False)
    st.sidebar.caption("Biên độ nhiệt trong hang không chấm riêng: dùng để tính hiệu suất đệm nhiệt.")

    tab_data, tab_res, tab_sens, tab_micro, tab_map = st.tabs(
        ["📥 Dữ liệu", "📊 Kết quả", "🎚️ Độ nhạy", "🌡️ Vi khí hậu & thang đo", "🗺️ Bản đồ"]
    )

    with tab_data:
        st.subheader("Nhập số liệu (sửa trực tiếp trong bảng)")
        df = st.data_editor(
            DEFAULT_DATA, hide_index=True, use_container_width=True, num_rows="fixed",
            disabled=["Thông số", "Đơn vị"], key="data_editor_kno",
            column_config={"Trạng thái": st.column_config.SelectboxColumn(options=STATUS_OPTIONS)},
        )
        n_demo = int((df["Trạng thái"] == "Minh họa").sum())
        if n_demo:
            st.warning(f"⚠️ {n_demo} dòng còn ở mức **Minh họa** (chưa có nguồn).")
        else:
            st.success("Tất cả dòng đã có trạng thái khác 'Minh họa'.")

        st.markdown("#### Tải file CSV NASA POWER (tùy chọn)")
        up = st.file_uploader("File POWER_Point_Daily_...csv", type=["csv"], key="csv_power_up")
        csv_mean = None
        if up is not None:
            try:
                pw = parse_power(up.getvalue())
                if "T2M_RANGE" not in pw.columns:
                    st.error("Không tìm thấy cột T2M_RANGE trong file.")
                else:
                    s = pw["T2M_RANGE"].dropna()
                    csv_mean = float(s.mean())
                    c1, c2, c3 = st.columns(3)
                    c1.metric("T2M_RANGE trung bình (°C)", f"{csv_mean:.2f}")
                    c2.metric("Số ngày hợp lệ", f"{len(s)}")
                    c3.metric("Ngày thiếu dữ liệu (-999)", f"{int(pw['T2M_RANGE'].isna().sum())}")
                    fig = go.Figure(go.Scatter(y=pw["T2M_RANGE"], mode="lines", line=dict(color="#d62728")))
                    fig.update_layout(height=260, xaxis_title="Ngày thứ", yaxis_title="T2M_RANGE (°C)",
                                      margin=dict(l=10, r=10, t=10, b=10))
                    st.plotly_chart(fig, use_container_width=True)
            except Exception as e:
                st.error(f"Không đọc được file: {e}")
        use_csv = st.checkbox("Dùng giá trị trung bình này làm biên độ nhiệt bề mặt của Hang C7 và A1",
                              value=False, disabled=csv_mean is None)

    # Tính toán an toàn với pd.to_numeric để tránh crash khi nhập chuỗi
    def row_kno(name):
        try:
            sub = df.loc[df["Thông số"] == name, ["Mặt Trăng", "Hang C7", "Hang A1", "Hawaii (tùy chọn)"]].iloc[0]
            return pd.to_numeric(sub, errors='coerce').to_numpy(dtype=float)
        except Exception:
            return np.full(4, np.nan)

    amp_cave, amp_surf = row_kno("Biên độ nhiệt trong hang"), row_kno("Biên độ nhiệt bề mặt").copy()
    if use_csv and csv_mean is not None:
        amp_surf[1] = amp_surf[2] = csv_mean
    M = np.vstack([row_kno("SiO₂"), row_kno("FeO"), row_kno("TiO₂"), row_kno("Mật độ đá"),
                   np.where(amp_surf > 0, (amp_surf - amp_cave) / amp_surf * 100, np.nan),
                   row_kno("Độ dày trần hang"), row_kno("Gia tốc trọng trường")])

    if not np.isfinite(M).all() or (M <= 0).any():
        st.error("Có ô trống, bằng 0 hoặc âm trong bảng dữ liệu. Hãy kiểm tra lại tab Dữ liệu.")
        st.stop()

    S = similarity(M[:, 0], M[:, 1:])
    idx = [0, 1] + ([2] if show_hw else [])
    names = [SITE_NAMES[i] for i in idx]
    ESI = esi_calc(S, weights)
    ESI_nograv = esi_calc(S[:6], weights[:6])

    with tab_res:
        st.subheader(f"Weighted ESI — {profile}")
        cols = st.columns(len(idx))
        for c, i in zip(cols, idx):
            c.metric(SITE_NAMES[i], f"{ESI[i]*100:.1f}%", f"bỏ trọng lực: {ESI_nograv[i]*100:.1f}%", delta_color="off")
        st.caption("Điểm bị kéo xuống chủ yếu bởi trọng lực (Sᵢ = 0,283 cho mọi địa điểm Trái Đất), TiO₂ và độ dày trần.")

        left, right = st.columns(2)
        with left:
            fig = go.Figure()
            for i in idx:
                fig.add_trace(go.Scatterpolar(r=S[:, i], theta=CRITERIA, fill="toself", name=SITE_NAMES[i], line_color=SITE_COLORS[i]))
            fig.update_layout(polar=dict(radialaxis=dict(visible=True, range=[0, 1])), height=460, title="Điểm tương đồng thành phần Sᵢ")
            st.plotly_chart(fig, use_container_width=True)
        with right:
            tbl = pd.DataFrame({"Tiêu chí": CRITERIA, "wᵢ": weights})
            for i in idx:
                tbl[f"Sᵢ {SITE_NAMES[i]}"] = np.round(S[:, i], 3)
            st.dataframe(tbl, hide_index=True, use_container_width=True)

    with tab_sens:
        st.subheader("Điểm ESI phụ thuộc vào cách chọn trọng số")
        prof_res = {p: esi_calc(S, w) for p, w in PROFILES.items()}
        fig = go.Figure()
        for i in idx:
            fig.add_trace(go.Bar(name=SITE_NAMES[i], x=list(prof_res.keys()), y=[v[i] * 100 for v in prof_res.values()],
                                 marker_color=SITE_COLORS[i]))
        fig.update_layout(barmode="group", yaxis_title="Weighted ESI (%)", yaxis_range=[0, 100], height=380)
        st.plotly_chart(fig, use_container_width=True)
        rng = pd.DataFrame({"Địa điểm": names,
                            "Nhỏ nhất (%)": [min(v[i] for v in prof_res.values()) * 100 for i in idx],
                            "Lớn nhất (%)": [max(v[i] for v in prof_res.values()) * 100 for i in idx]}).round(1)
        st.dataframe(rng, hide_index=True, use_container_width=True)

    with tab_micro:
        st.subheader("Đệm nhiệt: biên độ ngoài bề mặt so với trong hang")
        labels = ["Mặt Trăng", "Hang C7", "Hang A1"] + (["Hawaii"] if show_hw else [])
        sel = [0] + [i + 1 for i in idx]
        fig = go.Figure()
        fig.add_trace(go.Bar(name="Biên độ bề mặt (°C)", x=labels, y=[amp_surf[i] for i in sel], marker_color="#d62728"))
        fig.add_trace(go.Bar(name="Biên độ trong hang (°C)", x=labels, y=[amp_cave[i] for i in sel], marker_color="#1f77b4"))
        fig.update_layout(barmode="group", yaxis_type="log", yaxis_title="°C (thang log)", height=340)
        st.plotly_chart(fig, use_container_width=True)
        st.dataframe(pd.DataFrame({"Địa điểm": labels, "Hiệu suất đệm nhiệt (%)": np.round([M[4, i] for i in sel], 1)}),
                     hide_index=True, use_container_width=True)

    with tab_map:
        st.subheader("Vị trí khu vực nghiên cứu")
        c1, c2 = st.columns(2)
        with c1:
            st.markdown("#### 🌍 Krông Nô, Đắk Nông")
            m1 = folium.Map(location=[12.5105, 107.9068], zoom_start=15, tiles=None)
            folium.TileLayer("https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                             attr="Esri World Imagery", name="Ảnh vệ tinh").add_to(m1)
            folium.TileLayer("https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png", attr="OpenTopoMap", name="Địa hình").add_to(m1)
            folium.Marker([12.5120, 107.9055], tooltip="Hang C7", icon=folium.Icon(color="blue")).add_to(m1)
            folium.Marker([12.5090, 107.9080], tooltip="Hang A1", icon=folium.Icon(color="green")).add_to(m1)
            folium.LayerControl().add_to(m1)
            st_folium(m1, width=520, height=380, key="earth_map_kno")
        with c2:
            st.markdown("#### 🌑 Mare Tranquillitatis Pit")
            m2 = folium.Map(location=[8.335, 33.222], zoom_start=3, tiles=None, crs="EPSG4326")
            folium.TileLayer("https://trek.nasa.gov/tiles/Moon/EQ/LRO_WAC_Mosaic_Global_303ppd_v02/1.0.0/default/default028mm/{z}/{y}/{x}.jpg",
                             attr="NASA/GSFC/ASU LRO WAC", name="LRO WAC", max_zoom=7).add_to(m2)
            folium.Marker([8.335, 33.222], tooltip="Mare Tranquillitatis Pit").add_to(m2)
            st_folium(m2, width=520, height=380, key="moon_map_kno")
