require("dotenv").config();
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const connectDB = require("./db");

connectDB();

const app = express();
app.use(express.json());

const User = mongoose.model("User", new mongoose.Schema({
    name: String,
    email: { type: String, unique: true },
    password: String,
    role: { type: String, enum: ["student", "alumni", "admin"] }
}));

app.get("/", (req, res) => {
    res.send("User Service Running");
});

app.post("/register", async (req, res) => {
    try {
        const hashed = await bcrypt.hash(req.body.password, 10);
        const user = await User.create({ ...req.body, password: hashed });
        res.json(user);
    } catch (err) {
        if (err.code === 11000) {
            return res.status(400).json({ message: "Email already registered" });
        }
        res.status(500).json({ message: "Registration failed" });
    }
});

app.post("/login", async (req, res) => {
    const user = await User.findOne({ email: req.body.email });
    if (!user) return res.status(400).json({ message: "User not found" });
    const valid = await bcrypt.compare(req.body.password, user.password);
    if (!valid) return res.status(400).json({ message: "Incorrect password" });
    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET, { expiresIn: "1h" });
    res.json({ token, user: { name: user.name, email: user.email, role: user.role } });
});

app.listen(process.env.PORT, () => {
    console.log("User Service running on port", process.env.PORT);
});