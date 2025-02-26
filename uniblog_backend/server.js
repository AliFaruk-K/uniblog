require("dotenv").config();
const express = require("express");
const jwt = require("jsonwebtoken");
const cors = require("cors");
const fs = require("fs");

const app = express();
app.use(express.json());
app.use(cors());

const usersFile = "users.json";

// 📌 Kullanıcı adı, e-posta ve şifre doğrulama fonksiyonu
function validateUsername(username) {
    return /^[A-Za-z ]{3,}$/.test(username); // 🔹 Sadece harf ve boşluk, en az 3 karakter
}

function validateEmail(email) {
    return /^[0-9]{9}@ogrenci\.amasya\.edu\.tr$/.test(email); // 🔹 9 haneli sayı + sabit domain
}

function validatePassword(password) {
    return password.length >= 6 && password.length <= 13; // 🔹 6-13 karakter uzunluğu
}

// 📌 **Kullanıcı Kayıt API**
app.post("/api/register", (req, res) => {
    const { username, email, password } = req.body;

    // 🔹 Alanlar boş mu kontrolü
    if (!username || !email || !password) {
        return res.status(400).json({ message: "Lütfen tüm alanları doldurun!" });
    }

    // 🔹 Kullanıcı adı doğrulama
    if (!validateUsername(username)) {
        return res.status(400).json({ message: "Kullanıcı adı en az 3 harf içermeli ve özel karakter içeremez!" });
    }

    // 🔹 E-posta doğrulama
    if (!validateEmail(email)) {
        return res.status(400).json({ message: "E-posta yalnızca 9 rakamdan oluşmalı ve @ogrenci.amasya.edu.tr uzantısı olmalı!" });
    }

    // 🔹 Şifre doğrulama
    if (!validatePassword(password)) {
        return res.status(400).json({ message: "Şifre en az 6, en fazla 13 karakter olmalıdır!" });
    }

    // 🔹 Mevcut kullanıcıları oku
    let users = [];
    if (fs.existsSync(usersFile)) {
        const fileData = fs.readFileSync(usersFile, "utf-8");
        users = fileData ? JSON.parse(fileData) : [];
    }

    // 🔹 Eğer e-posta zaten kayıtlıysa hata ver
    if (users.some(user => user.email === email)) {
        return res.status(400).json({ message: "Bu e-posta zaten kayıtlı!" });
    }

    // 🔹 Yeni kullanıcıyı ekle
    users.push({ username, email, password });

    // 🔹 JSON dosyasına yaz
    fs.writeFileSync(usersFile, JSON.stringify(users, null, 2));

    res.status(201).json({ message: "Kayıt başarılı!" });
});

// 📌 **Giriş Yapma (Login)**
app.post("/api/login", async (req, res) => {
    const { email, password } = req.body;

    // 🔹 Kullanıcıları dosyadan oku
    let users = [];
    if (fs.existsSync(usersFile)) {
        const fileData = fs.readFileSync(usersFile, "utf-8");
        users = fileData ? JSON.parse(fileData) : [];
    }

    // 🔹 Kullanıcıyı bul
    const user = users.find(user => user.email === email && user.password === password);
    if (!user) {
        return res.status(400).json({ message: "E-mail veya şifre hatalı" });
    }

    // 🔹 JWT Token oluştur
    const token = jwt.sign(
        { username: user.username, email: user.email },
        process.env.JWT_SECRET || "secretKey",
        { expiresIn: "1h" }
    );

    res.json({ token, username: user.username });
});

// 📌 **Sunucuyu Başlatma**
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server http://localhost:${PORT} portunda çalışıyor 🚀`));
