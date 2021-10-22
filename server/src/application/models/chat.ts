interface Chat {
  id: string;
  messages: Message[];
}

interface Message {
  id: string;
  sender: string;
  text: string;
}

export { Chat, Message };
