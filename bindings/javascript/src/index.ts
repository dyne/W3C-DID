import { readFileSync, promises as fsPromises } from 'fs';
import { join } from 'path';
import axios from 'axios';
import { zencode_exec } from 'zenroom';

type Keyring = {
  eddsa: string,
  ecdh: string,
  ethereum: string,
  bitcoin?: string,
  reflow?: string,
  schnorr?: string
}
type ControllerKeyring = {
  controller: string,
  keyring: Keyring
}

type DidDocument = Record<string, any>

type DidDeactivate = {
  deactivate_id: string
}

type DidRequest = { did_document: DidDocument } | DidDeactivate

type SignedDidDocument = {
  did_document: DidDocument,
  eddsa_signature: string,
  ecdh_signature: {
    r: string,
    s: string
  },
  timestamp: string,
  id: string
}

type SignedDidDeactivate = {
  deactivate_id: string,
  ecdh_signature: {
    r: string,
    s: string
  },
  id: string
}

type SignedDidRequest = SignedDidDocument | SignedDidDeactivate

export enum DidActions {
  CREATE = "create",
  UPDATE = "update",
  DEACTIVATE = "deactivate"
}

const readFromFile = (
  pathToFile: string
) :string => {
  return readFileSync(join(__dirname, pathToFile), 'utf-8');
}

const prepareZencodeKeyring = (
  keyring: ControllerKeyring,
) :string => {
  return JSON.stringify({
    controller: keyring.controller,
    [keyring.controller]: {keyring: keyring.keyring}
  });
}

const preparePks = async (
  requestKeyring: ControllerKeyring,
  additionalData: string
) :Promise<string> => {
  const contractPks = readFromFile('client/v1/create-identity-pubkeys.zen');
  const data = readFromFile(additionalData);
  const keys = prepareZencodeKeyring(requestKeyring);
  let {result} = await zencode_exec(contractPks, {data, keys});
  return result;
}

const prepareRequest= async (
  requestDomain: string,
  requestType: string,
  data: string,
  contractPath: string
) :Promise<string> => {
  data = JSON.parse(data);
  data["did_spec"] = requestDomain;
  data = JSON.stringify(data);
  let res: string = null;
  if (requestType == DidActions.CREATE || requestType == DidActions.UPDATE) {
    const contractRequest = readFromFile(contractPath);
    const {result} = await zencode_exec(contractRequest, {data, keys : "{}"});
    res = result;
  } else if (requestType == DidActions.DEACTIVATE) {
    const id = `did:dyne:${requestDomain}:${JSON.parse(data)["eddsa_public_key"]}`;
    res = JSON.stringify({request: {deactivate_id: id}});
  } else {
    return Promise.reject("requestType must be: accept, update or deactivate")
  }
  return res;
}

/**
 * create a keyring that contains the ecdh, eddsa, reflow, bitcoin and ethereum keys
 * @param description description that will appear in the did document
 * @returns ControllerKeyring type
 */
export const createKeyring = async (
    description: string
) :Promise<ControllerKeyring> => {
  const contract = readFromFile('client/v1/create-keyring.zen');
  const data = JSON.stringify({ controller: description});
  const {result} = await zencode_exec(contract, {data});
  const res = JSON.parse(result);
  return {controller: res.controller, keyring: res[res.controller].keyring};
}

/**
 * create an unsigned request that will be used for the action specified in the `requestType`
 * @param requestKeyring the keyring of the user for wich the request is created
 * @param requestDomain the did domain of the request
 * @param requestType the type of request
 * @returns unsigned request
 */
export const createRequest = async (
  requestKeyring: ControllerKeyring,
  requestDomain: string,
  requestType: DidActions
) :Promise<DidRequest> => {
  const data = await preparePks(requestKeyring, "client/v1/did-settings.json");
  const result = await prepareRequest(requestDomain, requestType, data, "client/v1/pubkeys-request-unsigned.zen");
  return JSON.parse(result).request;
}

/**
 * create an unsigned request for ifacer domains that will be used for the action specified in the `requestType`
 * @param requestKeyring the keyring of the user for wich the request is created
 * @param requestDomain the did domain of the request
 * @param requestType the type of request
 * @param requestIdentifier the ifacer identifier
 * @returns unsigned request
 */
export const createIfacerRequest = async (
  requestKeyring: ControllerKeyring,
  requestDomain: string,
  requestType: DidActions,
  requestIdentifier: string,
) :Promise<DidRequest> => {
  let data = await preparePks(requestKeyring, "client/v1/ifacer/did-settings.json");
  const dataDict = JSON.parse(data);
  dataDict.identifier = requestIdentifier;
  data = JSON.stringify(dataDict);
  const result = await prepareRequest(requestDomain, requestType, data, "client/v1/ifacer/pubkeys-request-unsigned.zen");
  return JSON.parse(result).request;
}

/**
 * sign the request
 * @param request the request to be signed
 * @param signerKeyring the keyring of the signer
 * @param signerDomain the did domain of the signer
 * @returns signed request
 */
export const signRequest = async (
  request: DidRequest,
  signerKeyring: ControllerKeyring,
  signerDomain: string
) :Promise<SignedDidRequest> => {
  const contractSign = readFromFile('client/v1/pubkeys-sign.zen');
  const data = JSON.parse(`{"request": ${JSON.stringify(request)}}`);
  data.timestamp = new Date().getTime().toString();
  data.signer_did_spec = signerDomain;
  const keys = prepareZencodeKeyring(signerKeyring);
  const {result} = await zencode_exec(contractSign, {data:  JSON.stringify(data), keys});
  return JSON.parse(result);
}

/**
 * send the `request` to https://did.dyne.org/ `endpoint`
 * @param endpoint api endpoint to send the request to
 * @param request signed request
 * @returns the result of the request
 */
export const sendRequest = async (
  endpoint: string,
  request: SignedDidRequest
) :Promise<string> => {
  const res = await axios.post(
    `https://did.dyne.org/${endpoint}`,
    { data: request, keys: "{}"}
  )
  return res.data;
}