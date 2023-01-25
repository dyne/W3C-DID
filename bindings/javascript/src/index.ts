import { readFileSync, promises as fsPromises } from 'fs';
import { join } from 'path';
import axios from 'axios';
import { zencode_exec } from 'zenroom';

const readFromFile = (
  pathToFile: string
) :string => {
  return readFileSync(join(__dirname, pathToFile), 'utf-8');
}

export const createKeyring = async (
    description: string
) :Promise<string> => {
  const contract = readFromFile('client/v1/create-keyring.zen');
  const data = JSON.stringify({ controller: description}); //maybe description.replace(/ /g,"_")
  const {result} = await zencode_exec(contract, {data, keys : "{}"});
  return result;
}

const preparePks = async (
  requestKeyring: string,
  requestDomain: string,
  signerDomain: string,
  additionalData: string
) :Promise<string> => {
  const contractPks = readFromFile('client/v1/create-identity-pubkeys.zen');
  const data = readFromFile(additionalData);
  let {result} = await zencode_exec(contractPks, {data, keys : requestKeyring});
  result = JSON.parse(result);
  result["did_spec"] = requestDomain;
  result["signer_did_spec"] = signerDomain;
  result["timestamp"] = new Date().getTime().toString();
  return JSON.stringify(result);
}

export const createRequest = async (
  requestKeyring: string,
  requestDomain: string,
  signerKeyring: string,
  signerDomain: string
) :Promise<string> => {
  const contractRequest = readFromFile('client/v1/pubkeys-request-signed.zen');
  const data = await preparePks(requestKeyring, requestDomain, signerDomain, 'client/v1/did-settings.json');
  const {result} = await zencode_exec(contractRequest, {data, keys : signerKeyring});
  return result;
}

export const createIfacerRequest = async (
  requestKeyring: string,
  requestDomain: string,
  requestIdentifier: string,
  signerKeyring: string,
  signerDomain: string
) :Promise<string> => {
  const contractRequest = readFromFile('client/v1/ifacer/pubkeys-request-signed.zen');
  let data = await preparePks(requestKeyring, requestDomain, signerDomain, 'client/v1/ifacer/did-settings.json');
  data = JSON.parse(data);
  data["identifier"] = requestIdentifier;
  data = JSON.stringify(data);
  const {result} = await zencode_exec(contractRequest, {data, keys : signerKeyring});
  return result;
}

export const deactivateRequest = async (
  requestKeyring: string,
  requestDomain: string,
  signerKeyring: string,
  signerDomain: string
) :Promise<string> => {
  const contractRequest = readFromFile('client/v1/pubkeys-deactivate.zen');
  const data = await preparePks(requestKeyring, requestDomain, signerDomain, 'client/v1/did-settings.json');
  const {result} = await zencode_exec(contractRequest, {data, keys : signerKeyring});
  return result;
}

export const sendRequest = async (
  endpoint: string,
  request: string
) :Promise<string> => {
  const res = await axios.post(
    `https://did.dyne.org/${endpoint}`,
    { data: JSON.parse(request), keys: "{}"}
  )
  return res.data;
}