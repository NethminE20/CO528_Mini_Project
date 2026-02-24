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

app.put("/:id", async (req, res) => {
    const job = await Job.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!job) return res.status(404).json({ msg: "Job not found" });
    res.json(job);
});

app.delete("/:id", async (req, res) => {
    const job = await Job.findByIdAndDelete(req.params.id);
    if (!job) return res.status(404).json({ msg: "Job not found" });
    res.json({ msg: "Job deleted" });
});

app.listen(process.env.PORT || 5003);