require("dotenv").config();
const express = require("express");
const jwt = require("jsonwebtoken");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// Kullanıcı bilgileri (şimdilik sabit)
const fixedUser = {
    username: "admin",
    email: "adminn",
    password: "123456",
};

// 📌 **Giriş Yapma (Login)**
app.post("/api/login", async (req, res) => {
    const { email, password } = req.body;

    if (email !== fixedUser.email) {
        return res.status(400).json({ message: "Kullanıcı bulunamadı" });
    }

    app.post("/api/login", async (req, res) => {
        const { email, password } = req.body;
      
        if (email !== fixedUser.email || password !== fixedUser.password) {
          return res.status(400).json({ message: "E-mail veya şifre hatalı" });
        }
      
        const token = jwt.sign({ username: fixedUser.username }, process.env.JWT_SECRET || "secretKey", { expiresIn: "1h" });
      
        res.json({ token, username: fixedUser.username });
      });
      
          

    const token = jwt.sign({ username: fixedUser.username }, process.env.JWT_SECRET, { expiresIn: "1h" });

    res.json({ token, username: fixedUser.username });
});

// 📌 **Sunucuyu Başlatma**
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server http://localhost:${PORT} portunda çalışıyor 🚀`));
