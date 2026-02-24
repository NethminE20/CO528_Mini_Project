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

app.put("/:id", async (req, res) => {
    const post = await Post.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!post) return res.status(404).json({ msg: "Post not found" });
    res.json(post);
});

app.delete("/:id", async (req, res) => {
    const post = await Post.findByIdAndDelete(req.params.id);
    if (!post) return res.status(404).json({ msg: "Post not found" });
    res.json({ msg: "Post deleted" });
});

app.listen(process.env.PORT);