import express from 'express';
import * as socketio from 'socket.io';
import { createServer } from 'http';
import * as dotenv from 'dotenv';

dotenv.config();

const app = express();
const server = createServer(app);
const io = new socketio.Server(server);

io.on('connection', (socket: socketio.Socket) => {
    console.info('Hello,', socket.id);
});

const port = process.env.PORT || 8080;

server.listen(port, () => {
    console.info("Server is running on", port);
});