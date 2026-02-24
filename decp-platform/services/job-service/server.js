require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const connectDB = require("./db");

connectDB();

const app = express();
app.use(express.json());

const Job = mongoose.model("Job", new mongoose.Schema({
    title: String,
    description: String,
    company: String
}));

app.post("/", async (req, res) => {
    res.json(await Job.create(req.body));
});

app.get("/", async (req, res) => {
    res.json(await Job.find());
});

app.listen(process.env.PORT || 5003);