import { singleton } from "tsyringe";
import { generateRandomId } from "../../utils/randomId";
import { Player } from "../models/player";

interface PlayerRepository {
  create(name: string): Promise<Player>;
  findWithUid(uid: string): Promise<Player>;
  findAll(): Promise<Player[]>;
}

@singleton()
class PlayerRepositoryImpl implements PlayerRepository {
  players: Player[] = [];

  async create(name: string): Promise<Player> {
    const player: Player = {
      id: generateRandomId(32),
      name: name,
      opponentId: null,
    };
    this.players.push(player);
    return player;
  }
  async findWithUid(uid: string): Promise<Player> {
    const player = this.players.find((p) => p.id === uid);
    if (!player) {
      throw new Error("Not found");
    }
    return player;
  }
  async findAll(): Promise<Player[]> {
    return this.players;
  }
}

export { PlayerRepository, PlayerRepositoryImpl };
