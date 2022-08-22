import {
    promises as fsp
} from 'fs';
import path from 'path';
import dotenv from "dotenv";
import { zencode_exec } from "zenroom";

dotenv.config();

const PRIVATE_ZENCODE_DIR = process.env.PRIVATE_ZENCODE_DIR;
const ZENCODE_DIR = process.env.ZENCODE_DIR || "contracts";

// generate private keys
const generatePrivateKeysScript = await fsp.readFile(path.join(PRIVATE_ZENCODE_DIR, "create_keys.zen"), 'utf8')
let keyring = {};
let keys;
const params = {};
try {
    keys = await zencode_exec(generatePrivateKeysScript, params);
} catch (e) {
    console.log("Error from zencode_exec: ", e);
}

if (!keys) {
    console.error("Error in generate private keys");
    process.exit(-1)
}

Object.assign(keyring, JSON.parse(keys.result))
await fsp.writeFile(
    path.join(ZENCODE_DIR, "keyring.json"),
    JSON.stringify(keyring), {mode: 0o600})
