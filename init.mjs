import {
    promises as fsp
} from 'fs';
import web3 from 'web3';
import fs from 'fs';
import path from 'path';
import dotenv from "dotenv";
import { zencode_exec } from "zenroom";

dotenv.config();

const PRIVATE_ZENCODE_DIR = process.env.PRIVATE_ZENCODE_DIR;
const ZENCODE_DIR = process.env.ZENCODE_DIR || "contracts";

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

// generate private keys
let keyring = {}
if(!fs.existsSync(path.join(ZENCODE_DIR, "keyring.json"))){
    const generatePrivateKeysScript = await fsp.readFile(path.join(PRIVATE_ZENCODE_DIR, "create_keys.zen"), 'utf8');
    const keys = await zen(generatePrivateKeysScript, null, null);
    if (!keys) {
	console.error("Error in generate private keys");
	process.exit(-1);
    }

    Object.assign(keyring, JSON.parse(keys.result));
    await fsp.writeFile(
	path.join(ZENCODE_DIR, "keyring.json"),
	JSON.stringify(keyring), {mode: 0o600});
}
else {
    keyring = await fsp.readFile(path.join(ZENCODE_DIR, "keyring.json"), 'utf8');
}

// generate public keys
const generatePublicKeysScript = await fsp.readFile(path.join(PRIVATE_ZENCODE_DIR, "create_pub_keys.zen"), 'utf8');
let publicKeys = {};
const pubKeys = await zen(generatePublicKeysScript, keyring, null);
if (!pubKeys) {
    console.error("Error in generate public keys");
    process.exit(-1);
}

// Ethereum address checksum
let result = JSON.parse(pubKeys.result);
result.Issuer.ethereum_address = web3.utils.toChecksumAddress(
    result.Issuer.ethereum_address).replace('0x', '');

try {
    await fsp.unlink(path.join(ZENCODE_DIR, "public_keys.json"));
} catch(e) {}
Object.assign(publicKeys, result);
await fsp.writeFile(
    path.join(ZENCODE_DIR, "public_keys.json"),
    JSON.stringify(publicKeys), {mode: 0o600});
