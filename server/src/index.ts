import express from "express";
import * as socketio from "socket.io";
import { createServer } from "http";
import * as dotenv from "dotenv";
import "reflect-metadata";
import {
  onCreateRoomEvent,
  onJoinRoomEvent,
  onSetupUserEvent,
} from "./routes/eventHandler";
import {
  SetupUserEvent,
  SetupUserEventData,
} from "./routes/events/setupUserEvent";

dotenv.config();

const app = express();
const server = createServer(app);
const io = new socketio.Server(server);

const port = process.env.PORT || 8080;

app.get("/test", (req, res) => {
  res.send("Hello, this is test page.");
});

io.on("connection", (socket: socketio.Socket) => {
  console.info("Hello,", socket.id);
});

server.listen(port, () => {
  console.info("Server is running on", port);
});
