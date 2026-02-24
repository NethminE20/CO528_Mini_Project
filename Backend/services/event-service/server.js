require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const connectDB = require("./db");

connectDB();

const app = express();
app.use(express.json());

const Event = mongoose.model("Event", new mongoose.Schema({
    title: String,
    date: String,
    rsvps: [String]
}));

app.post("/", async (req, res) => {
    res.json(await Event.create(req.body));
});

app.post("/:id/rsvp", async (req, res) => {
    const event = await Event.findById(req.params.id);
    event.rsvps.push(req.body.userId);
    await event.save();
    res.json(event);
});

app.get("/", async (req, res) => {
    res.json(await Event.find());
});

app.listen(process.env.PORT || 5004);