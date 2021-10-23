import express from "express";
import * as socketio from "socket.io";
import { createServer } from "http";
import * as dotenv from "dotenv";
import "reflect-metadata";
import { SetupUserRequestData } from "./routes/rest/requests/setupUserRequest";
import { onSetupUserRequest } from "./routes/rest/requestHandler";

dotenv.config();

const app = express();
const server = createServer(app);
const io = new socketio.Server(server);

const port = process.env.PORT || 8080;

app.use(express.json());

let sockets: Map<string, socketio.Socket> = new Map();

io.on("connection", (socket: socketio.Socket) => {
  console.info("Hello,", socket.id);
  sockets.set(socket.id, socket);
});

app.post("/users/setup", (req, res) => {
  const socketId: string = req.body.socketId;
  const uid: string | null = req.body.uid;
  if (!socketId) {
    res.status(400).send("Invalid parameter: socketId is missing");
    return;
  }
  const data: SetupUserRequestData = {
    socketId: socketId,
    uid: uid,
    allSockets: sockets,
  };
  onSetupUserRequest(data);
});

server.listen(port, () => {
  console.info("Server is running on", port);
});
