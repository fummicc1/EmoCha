import { MatchingEvent, MatchingEventData } from "./matchingEvent";

const onMatchingEvent = (event: MatchingEvent) => {
    const socketId = event.client.id;
    const data: MatchingEventData = event.data;
}