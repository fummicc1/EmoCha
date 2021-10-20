import { joinRoom } from "../application/services/matchingService";
import { JoinRoomEvent, JoinRoomEventData } from "./events/joinRoomEvent";

const onMatchingEvent = async (event: JoinRoomEvent) => {
    const socket = event.client;
    const data: JoinRoomEventData = event.data;
    const service = await joinRoom(socket, data.roomName);
}