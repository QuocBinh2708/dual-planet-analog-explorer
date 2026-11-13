@echo off
title Dual-Planet Analog Explorer (Streamlit)
cd /d "%~dp0"
echo Starting Dual-Planet Analog Explorer on http://localhost:8501...
"C:\Users\Dell\AppData\Local\Programs\Python\Python311\python.exe" -m streamlit run app.py --server.port 8501
pause

