# PulseMate

<p align="center">
  <img src="assets/app_logo.png" alt="PulseMate Logo" width="200"/>
</p>

PulseMate is a modern dating application built with Flutter that helps users connect with potential matches based on shared interests and compatibility. The app features real-time chat functionality, profile customization, and an intuitive matching system.

---

## 📱 Features

- 🔐 **User Authentication**: Secure signup, login, and profile management  
- 🧑‍🎨 **Profile Customization**: Create and edit detailed profiles with personal information  
- 💞 **Smart Matching Algorithm**: Find compatible matches based on interests and preferences  
- 💬 **Real-time Chat**: Instant messaging with matches using WebSocket technology  
- 📍 **Location-based Matching**: Find potential matches in your area  
- 👈 **Swipe Interface**: Intuitive swipe mechanism for accepting or rejecting potential matches  

---

## 🛠️ Technologies Used

### 📲 Frontend

- **Flutter** – Cross-platform UI toolkit  
- **Dart** – Programming language for Flutter  

### 🔙 Backend

- **Node.js** – JavaScript runtime  
- **Express** – Web framework  
- **MongoDB** – NoSQL database  
- **WebSockets** – Real-time communication  
- **AWS** – Deployment and cloud storage  

---

## 📋 Prerequisites

- Flutter SDK 
- Dart 
- Node.js 
- MongoDB  
- AWS account (for deployment)  

---

## 🚀 Getting Started

### 🧩 Clone the Repository

```bash
git clone https://github.com/ezsarthak/pulse_mate.git
cd pulse_mate
```

---

### 📱 Frontend Setup

```bash
# Install Flutter dependencies
flutter pub get

# Run the app
flutter run
```

---

### 🌐 Backend Setup
[Pulse Mate Backend Server](https://github.com/ezsarthak/pulse_mate_server)

[Pulse Mate Websocket Server](https://github.com/ezsarthak/pulse_mate_websocket)

## 📸 Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/7ecd8e7b-3f70-40a3-8589-3531e9426218" alt="Welcome Screen" width="200"/>
  <img src="https://github.com/user-attachments/assets/c42ca23b-6b06-45c1-b663-88b79edaa46d" alt="SignUp Screen" width="200"/>
    <img src="https://github.com/user-attachments/assets/82354e81-8f6c-4231-bec2-836919887cd3" alt="Profile Screen" width="200"/>
  <img src="https://github.com/user-attachments/assets/eba8fed8-e6e6-4419-8207-fc2996e7db40" alt="Find Matches" width="200"/>
  <img src="https://github.com/user-attachments/assets/cc0754fd-6b50-40d8-8be3-5f133d804434" alt="Chat" width="200"/>
</p>

---

## 🏗️ Project Structure

```
pulse_mate/
├── android/            # Android-specific files
├── assets/             # App assets (images, icons, fonts, etc.)
├── lib/                # Dart source code
│   ├── core/           # API and business logic Layer
│   ├── data/           # Data Model Layer
│   ├── presentation/   # UI Layer
│   ├── widgets/        # Reusable UI Layer
│   └── main.dart       # App entry point
```

## 🚢 Deployment

The backend is deployed using AWS:

- **AWS EC2** – Node.js server hosting  
- **MongoDB Atlas** – Managed database  
---

## 🤝 Contributing

```bash
# 1. Fork the repository

# 2. Create your feature branch
git checkout -b feature/amazing-feature

# 3. Commit your changes
git commit -m "Add some amazing feature"

# 4. Push to the branch
git push origin feature/amazing-feature

# 5. Open a Pull Request
```


---

## 📞 Contact

Sarthak – [GitHub](https://github.com/ezsarthak)  
**Project Link:** [https://github.com/ezsarthak/pulse_mate](https://github.com/ezsarthak/pulse_mate)
