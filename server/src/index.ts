import express from "express";
import * as socketio from "socket.io";
import { createServer } from "http";
import * as dotenv from "dotenv";
import "reflect-metadata";
import { SetupUserRequestData } from "./routes/rest/requests/setupUserRequest";
import { JoinRoomRequestData } from "./routes/rest/requests/joinRoomRequest";
import {
  onJoinRoomRequest,
  onSetupUserRequest,
} from "./routes/rest/requestHandler";
import { generateRandomId } from "./utils/randomId";

dotenv.config();

const app = express();
const server = createServer(app);
const io = new socketio.Server(server);

const port = process.env.PORT || 8080;

const errorMiddleware = (
  err: Error,
  req: express.Request,
  res: express.Response,
  next: express.NextFunction
) => {
  res.status(500);
  res.send({ error: err });
};

app.use(errorMiddleware);
app.use(express.json());

let sockets: Map<string, socketio.Socket> = new Map();

io.on("connection", (socket: socketio.Socket) => {
  console.info("Hello,", socket.id);
  sockets.set(socket.id, socket);
});

app.get("/", (req, res) => {
  res.send("Hello!");
});

app.post("/users/setup", async (req, res, next) => {
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
  try {
    await onSetupUserRequest(data);
    res.status(201).send({
      message: "OK",
    });
  } catch (err) {
    next(err);
  }
});

app.post("/rooms/join", async (req, res, next) => {
  const socketId: string = req.body.socketId ?? null;
  if (!socketId) {
    res.status(400).send("Invalid parameter: socketId is missing");
    return;
  }
  const roomCode: string = req.body.roomCode ?? generateRandomId(6);
  const data: JoinRoomRequestData = {
    socketId: socketId,
    roomCode: roomCode,
    allSockets: sockets,
  };
  try {
    await onJoinRoomRequest(data);
    res.status(201).send({
      message: "OK",
    });
  } catch (err) {
    next(err);
  }
});

server.listen(port, () => {
  console.info("Server is running on", port);
});
