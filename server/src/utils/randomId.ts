import { randomBytes } from 'crypto';

const generateRandomId = (length: number): string => randomBytes(length).reduce((p, i) => p + (i % 32).toString(32), '');

export { generateRandomId };