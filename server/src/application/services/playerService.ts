import { container } from "tsyringe";
import { Player } from "../models/player";
import { PlayerRepositoryImpl } from "../repositories/playerRepository";

const setupUser = async (uid: string | null): Promise<Player> => {
  const playerRepository = container.resolve(PlayerRepositoryImpl);
  if (uid) {
    const player = await playerRepository.findWithUid(uid);
    if (player) {
      return player;
    }
  }
  const player = await playerRepository.create("Unknown");
  return player;
};

export { setupUser };
