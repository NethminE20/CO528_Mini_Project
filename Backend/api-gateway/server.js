const express = require("express");
const cors = require("cors");
const { createProxyMiddleware } = require("http-proxy-middleware");

const app = express();

app.use(cors());

// Root route
app.get("/", (req, res) => {
    res.send("DECP API Gateway Running 🚀");
});

// Health check
app.get("/health", (req, res) => {
    res.json({ status: "OK" });
});

// Proxies
app.use("/users", createProxyMiddleware({
    target: "http://user-service:5001",
    changeOrigin: true,
    pathRewrite: { "^/users": "" }
}));

app.use("/posts", createProxyMiddleware({
    target: "http://post-service:5002",
    changeOrigin: true,
    pathRewrite: { "^/posts": "" }
}));

app.use("/jobs", createProxyMiddleware({
    target: "http://job-service:5003",
    changeOrigin: true,
    pathRewrite: { "^/jobs": "" }
}));

app.use("/events", createProxyMiddleware({
    target: "http://event-service:5004",
    changeOrigin: true,
    pathRewrite: { "^/events": "" }
}));

app.use("/analytics", createProxyMiddleware({
    target: "http://analytics-service:5007",
    changeOrigin: true,
    pathRewrite: { "^/analytics": "" }
}));

app.listen(5000, () => {
    console.log("API Gateway running on port 5000");
});