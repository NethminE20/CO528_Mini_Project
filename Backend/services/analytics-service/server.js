require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const connectDB = require("./db");

connectDB();

const app = express();

const Post = mongoose.model("Post", new mongoose.Schema({
    userId: String,
    content: String,
    likes: Number
}));

app.get("/", async (req, res) => {
    const totalPosts = await Post.countDocuments();
    const totalLikes = await Post.aggregate([{ $group: { _id: null, total: { $sum: "$likes" } } }]);
    res.json({
        totalPosts,
        totalLikes: totalLikes[0]?.total || 0
    });
});

app.listen(process.env.PORT || 5007);