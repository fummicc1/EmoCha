interface Player {
  id: string;
  name: string;
  opponentId: string | null;
  socketId: string;
}

export { Player };
