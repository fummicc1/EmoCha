import { singleton } from "tsyringe";
import { generateRandomId } from "../../utils/randomId";
import { Player } from "../models/player";

interface PlayerRepository {
  create(name: string, socketId: string): Promise<Player>;
  update(player: Player): Promise<void>;
  findWithUid(uid: string): Promise<Player>;
  findAll(): Promise<Player[]>;
}

@singleton()
class PlayerRepositoryImpl implements PlayerRepository {
  players: Player[] = [];

  async create(name: string, socketId: string): Promise<Player> {
    const player: Player = {
      id: generateRandomId(32),
      name: name,
      opponentId: null,
      socketId: socketId,
    };
    this.players.push(player);
    return player;
  }

  async update(player: Player): Promise<void> {
    const index = this.players.findIndex((p) => p.id === player.id);
    this.players[index] = player;
  }

  async findWithUid(uid: string): Promise<Player> {
    const player = this.players.find((p) => p.id === uid);
    console.log(uid);
    if (player == null) {
      throw new Error("Not found");
    }
    return player;
  }
  async findAll(): Promise<Player[]> {
    return this.players;
  }
}

export { PlayerRepository, PlayerRepositoryImpl };
