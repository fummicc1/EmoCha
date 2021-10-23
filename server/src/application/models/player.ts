interface Player {
  id: string;
  name: string;
  opponentId: string | null;
  socketId: string | null;
}

export { Player };
