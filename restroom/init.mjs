import {
    promises as fsp
} from 'fs';
import fs from 'fs';
import path from 'path';
import dotenv from "dotenv";
import { zencode_exec } from "zenroom";

dotenv.config();

const INIT_ZENCODE_DIR = process.env.INIT_ZENCODE_DIR;
const FILES_DIR = process.env.FILES_DIR;
const KEYS_PATH = "secrets/planetmint_client.json";
const DID_PATH = "data/dyne/planetmint.client"

const zen = async (zencode, keys, data) => {
    const params = {};
    if (keys !== undefined && keys !== null) {
        params.keys = typeof keys === 'string' ? keys : JSON.stringify(keys);
    }
    if (data !== undefined && data !== null) {
        params.data = typeof data === 'string' ? data : JSON.stringify(data);
    }
    try {
        return await zencode_exec(zencode, params);
    } catch (e) {
        console.log("Error from zencode_exec: ", e);
    }
}

// create private and public key
let keysJson = {}
const keysPath = path.join(FILES_DIR, KEYS_PATH)
const keysPathParsed = path.parse(keysPath)
if(!fs.existsSync(keysPath)){
    const createKeysScript = await fsp.readFile(path.join(INIT_ZENCODE_DIR, "keygen.zen"), 'utf8');
    const didSettings = await fsp.readFile(path.join(INIT_ZENCODE_DIR, "did-settings.json"), 'utf8');
    const controller = JSON.stringify({controller: "planetmint_client"})
    const keys = await zen(createKeysScript, controller, didSettings);
    if (!keys) {
	    console.error("Error in keys creation");
	    process.exit(-1);
    }

    Object.assign(keysJson, JSON.parse(keys.result));
    if (!fs.existsSync(keysPathParsed.dir)) fs.mkdirSync(keysPathParsed.dir,'0700', true);
    await fsp.writeFile(
	    keysPath,
	    JSON.stringify(keysJson), {mode: 0o600});
}
else {
    const keys = await fsp.readFile(path.join(FILES_DIR, KEYS_PATH), 'utf8');
    keysJson = JSON.parse(keys);
}

const EDDSA_PK = keysJson["eddsa_public_key"]

// create did doc
if(!fs.existsSync(path.join(FILES_DIR, DID_PATH, EDDSA_PK))){
    const createDidDocScript = await fsp.readFile(path.join(INIT_ZENCODE_DIR, "didgen.zen"), 'utf8');
    const timestamp = new Date().getTime().toString()
    const time = JSON.stringify({timestamp: timestamp})
    let didDocJson = {};
    const didDoc = await zen(createDidDocScript, JSON.stringify(keysJson), time);
    if (!didDoc) {
        console.error("Error in did doc creation");
        process.exit(-1);
    }
    fs.mkdirSync(path.join(FILES_DIR, DID_PATH), { recursive: true });
    Object.assign(didDocJson, JSON.parse(didDoc.result));
    await fsp.writeFile(
        path.join(FILES_DIR, DID_PATH, EDDSA_PK),
        JSON.stringify(didDocJson), {mode: 0o600});
}
