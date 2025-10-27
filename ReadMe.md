# Starter CMS Kit


ตัวตั้งต้นสำหรับทำ project มี api , dashboard , mobiile app ให้แล้ว
* ใช้ Jwt ข้อควรระวังถ้าเอาไปทำฝั่งที่คนทั่วไปเข้าถึงด้วย frontend ของ web แนะนำให้ใช้ cookie
* TokenBlacklist ตอนนี้ใช้ db ถ้ามีงบประมาณ หรือถ้าคนใช้งานเกิน 30,000 คน ค่อนข้างถี่ แนะนำให้ย้ายไปใช้ Redis ดีกว่า 
* utils.py อาจจะดู over engineer นิดนึง แต่พยายามออกแบบให้สามารถสร้าง API ได้ง่าย 

## โครงสร้างโปรเจกต์
```
.
├── backendAPI/      # Backend API (Python Flask)
├── dashboard/       # Dashboard (Vue + Vite)
└── mobile_app/      # Mobile App (Flutter)
```

## การติดตั้ง

### 1. Backend API
```bash
cd backendAPI
python -m venv venv
source venv/bin/activate  # Mac/Linux
pip install -r requirements.txt
python app.py
```

### 2. Dashboard
```bash
cd dashboard
npm install
npm run dev
```

### 3. Mobile App
```bash
cd mobile_app
flutter pub get
flutter run
```

## Environment Variables

แต่ละส่วนต้องสร้างไฟล์ `.env` ตามตัวอย่าง `.env.example`


## License

MLT