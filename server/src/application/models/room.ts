interface Room {
    id: string
    code: string
    name: string
    players: Player[]
    chat: Chat
    state: RoomState
}

type RoomState = 'Vacant' | 'Fulfill';

const maxPlayerCount = 2;

export { Room, RoomState, maxPlayerCount }