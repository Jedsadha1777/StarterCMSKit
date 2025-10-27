# Flask Admin Panel (Vue 3)

Admin Panel สำหรับจัดการ Flask API ด้วย Vue 3 + Vite

##  Project Structure

```
admin-panel/
├── src/
│   ├── views/              # หน้าต่างๆ
│   │   ├── Login.vue       # หน้า Login
│   │   ├── Dashboard.vue   # Dashboard
│   │   ├── Articles.vue    # รายการ Articles
│   │   ├── ArticleForm.vue # Form สร้าง/แก้ไข Article
│   │   ├── Users.vue       # รายการ Users
│   │   ├── UserForm.vue    # Form สร้าง/แก้ไข User
│   │   └── Profile.vue     # Profile & Change Password
│   │
│   ├── components/
│   │   └── Navbar.vue      # Navigation bar
│   │
│   ├── api.js              # API calls & axios config
│   ├── router.js           # Vue Router config
│   ├── App.vue             # Root component
│   └── main.js             # Entry point
│
├── index.html
├── vite.config.js
├── package.json
└── README.md
```