import express from "express";
import * as socketio from "socket.io";
import { createServer } from "http";
import * as dotenv from "dotenv";
import "reflect-metadata";
import {
  JoinRoomEvent,
  JoinRoomEventData,
} from "./routes/events/joinRoomEvent";
import {
  onCreateRoomEvent,
  onJoinRoomEvent,
  onSetupUserEvent,
} from "./routes/eventHandler";
import {
  CreateRoomEvent,
  CreateRoomEventData,
} from "./routes/events/createRoomEvent";
import {
  SetupUserEvent,
  SetupUserEventData,
} from "./routes/events/setupUserEvent";

dotenv.config();

const app = express();
const server = createServer(app);
const io = new socketio.Server(server);

const port = process.env.PORT || 80;

app.get("/test", (req, res) => {
  res.send("Hello, this is test page.");
});

io.on("connection", (socket: socketio.Socket) => {
  console.info("Hello,", socket.id);
  socket.on("join-room", (data: JoinRoomEventData) => {
    const event: JoinRoomEvent = new JoinRoomEvent(socket, data);
    onJoinRoomEvent(event);
  });
  socket.on("create-room", (data: CreateRoomEventData) => {
    const event = new CreateRoomEvent(socket, data);
    onCreateRoomEvent(event);
  });
  socket.on("setup-user", (data: SetupUserEventData) => {
    const event = new SetupUserEvent(socket, data);
    console.log(event);
    onSetupUserEvent(event);
  });
});

server.listen(port, () => {
  console.info("Server is running on", port);
});
