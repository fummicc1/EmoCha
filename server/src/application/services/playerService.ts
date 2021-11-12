import { container } from "tsyringe";
import { Player } from "../models/player";
import { PlayerRepositoryImpl } from "../repositories/playerRepository";

const setupUser = async (
  uid: string | null,
  socketId: string
): Promise<Player> => {
  const playerRepository = container.resolve(PlayerRepositoryImpl);
  console.log(uid);
  console.log(typeof uid);
  let player: Player;
  if (uid == null) {
    player = await playerRepository.create("Unknown", socketId);
  } else {
    player = await playerRepository.findWithUid(uid);
  }
  return player;
};

export { setupUser };
