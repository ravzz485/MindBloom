const express = require("express");
const cors = require("cors");
const selfcareRoutes = require("./modules/selfcare/selfcare.routes");

const app = express();

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());

app.get("/", (req, res) => {
  res.send("MindBloom API is running");
});

app.use("/api/selfcare", selfcareRoutes);

module.exports = app;