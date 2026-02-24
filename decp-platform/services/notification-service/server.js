const express = require("express");
const app = express();
app.use(express.json());

let notifications = [];

app.post("/", (req, res) => {
    notifications.push(req.body);
    res.json({ msg: "Stored" });
});

app.get("/", (req, res) => {
    res.json(notifications);
});

app.listen(5006);