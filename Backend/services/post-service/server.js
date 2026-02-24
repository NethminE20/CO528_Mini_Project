require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const connectDB = require("./db");

connectDB();

const app = express();
app.use(express.json());

const Post = mongoose.model("Post", new mongoose.Schema({
    userId: String,
    content: String,
    likes: { type: Number, default: 0 }
}));

app.post("/", async (req, res) => {
    res.json(await Post.create(req.body));
});

app.get("/", async (req, res) => {
    res.json(await Post.find());
});

app.listen(process.env.PORT);