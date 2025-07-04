# Investment Advisor Project 💼📈🧠

This is a **Stock Portfolio Management System** developed as part of the "Real-Time Systems & Window Engineering" course
It combines a **Python GUI (PySide6)** frontend with a powerful **ASP.NET Core** backend – and smart integrations with cloud & AI services 🤖☁️

---

## How to Use 🎮

- 🔐 Log in securely as a user  
- 📈 Buy or Sell stocks through the GUI  
- 📊 View portfolio in graph or table mode  
- 🧠 Ask the built-in AI advisor for financial recommendations  
- 🖼️ Upload supporting files (e.g., charts) via Cloudinary  
- 🌍 Get real-time market data from Polygon.io

---

## Project Files 📁

### Backend (`backend/`) 🔙
- `Controllers/` – API endpoints  
- `Services/` – business logic  
- `Repositories/` – data access  
- `DTOs/`, `Requests/`, `Models/` – data structures  
- `appsettings.json` – configuration  
- `StockAdvisorBackend.sln` – solution file  

### Frontend (`frontend/`) 🖥️
- `Windows/` – all GUI windows  
- `Services/` – API integrations  
- `Constants/` – static values  
- `Pictures/` – UI icons and images  
- `mainWindow.py` – launcher for the app  

---

## Technologies Used 🧠

### Frontend
- Python 3.9+  
- PySide6 / Qt  
- QtCharts (for graphs)  

### Backend
- ASP.NET Core 6.0 / 8.0  
- MVC + CQRS + Event Sourcing  
- Hosted on `somee.com`  

### External Services ☁️
- [Polygon.io](https://polygon.io) – market data API  
- [Cloudinary](https://cloudinary.com) – image uploads  
- [Ollama](https://ollama.ai) – LLM agent via Docker  

---

## How to Run 🛠️

### Backend

```bash
# Open with Visual Studio
StockAdvisorBackend.sln

# Make sure appsettings.json is configured
# Press F5 to run the API locally
```

### Frontend

```bash
cd frontend
pip install PySide6
python Windows/mainWindow.py
```

---

## Made by Elyasaf Cohen ✨

GitHub: [@ElyasafCohen100](https://github.com/ElyasafCohen100)

---

> ⚡ If you like this project, please give it a ⭐ on GitHub! ✌️😎
