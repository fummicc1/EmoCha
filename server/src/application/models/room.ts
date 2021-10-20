interface Room {
    id: string
    name: string
    players: Player[]
    chat: Chat
}

type RoomState = 'Vacant' | 'Fulfill';

const maxPlayerCount = 2;

export { Room, RoomState, maxPlayerCount }