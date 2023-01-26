import { readFileSync, promises as fsPromises } from 'fs';
import { join } from 'path';
import axios from 'axios';
import { zencode_exec } from 'zenroom';

const readFromFile = (
  pathToFile: string
) :string => {
  return readFileSync(join(__dirname, pathToFile), 'utf-8');
}

/**
 * create a keyring that contains the ecdh, eddsa, reflow, bitcoin and ethereum keys
 * @param description description that will appear in the did document
 * @returns JSON encoded as string with format
 * {"controller": "`description`", "`description`": {"keyring": { *...* }}}
 */
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
  additionalData: string
) :Promise<string> => {
  const contractPks = readFromFile('client/v1/create-identity-pubkeys.zen');
  const data = readFromFile(additionalData);
  let {result} = await zencode_exec(contractPks, {data, keys : requestKeyring});
  result = JSON.parse(result);
  result["did_spec"] = requestDomain;
  return JSON.stringify(result);
}

/**
 * create an unsigned request containig the did document of the type did:dyne:`requestDomain`
 * @param requestKeyring the keyring corresponding to the did document that will be created
 * @param requestDomain the did domain of the request
 * @returns JSON encoded as string contating the unsigned did document
 */
export const createRequest = async (
  requestKeyring: string,
  requestDomain: string
) :Promise<string> => {
  const contractRequest = readFromFile('client/v1/pubkeys-request-unsigned.zen');
  const data = await preparePks(requestKeyring, requestDomain, 'client/v1/did-settings.json');
  const {result} = await zencode_exec(contractRequest, {data, keys : "{}"});
  return result;
}

/**
 * create an unsigned request containig the did document of the type did:dyne:`requestDomain`
 * @param requestKeyring the keyring corresponding to the did document that will be created/updated
 * @param requestDomain the did domain of the request
 * @param requestIdentifier the ifacer identifier
 * @returns JSON encoded as string contating the unsigned did document
 */
export const createIfacerRequest = async (
  requestKeyring: string,
  requestDomain: string,
  requestIdentifier: string
) :Promise<string> => {
  const contractRequest = readFromFile('client/v1/ifacer/pubkeys-request-unsigned.zen');
  let data = await preparePks(requestKeyring, requestDomain, 'client/v1/ifacer/did-settings.json');
  data = JSON.parse(data);
  data["identifier"] = requestIdentifier;
  data = JSON.stringify(data);
  const {result} = await zencode_exec(contractRequest, {data, keys : "{}"});
  return result;
}

/**
 * sign with both the eddsa and the ecdh keys the request
 * @param request the request to be signed
 * @param signerKeyring the keyring of the signer
 * @param signerDomain the did domain of the signer
 * @returns signed request ready to be sent
 */
export const signRequest = async (
  request: string,
  signerKeyring: string,
  signerDomain: string
) :Promise<string> => {
  const contractSign = readFromFile('client/v1/pubkeys-sign.zen');
  request = JSON.parse(request);
  request["timestamp"] = new Date().getTime().toString();
  request["signer_did_spec"] = signerDomain;
  request = JSON.stringify(request);
  const {result} = await zencode_exec(contractSign, {data: request, keys : signerKeyring});
  return result;
}

/**
 * create and sign a did revocation request
 * @param requestKeyring the keyring corresponding to the did document that will be deactivated
 * @param requestDomain the did domain of the request
 * @param signerKeyring the keyring of the signer
 * @param signerDomain the did domain of the signer
 * @returns signed revokation request ready to be sent
 */
export const deactivateRequest = async (
  requestKeyring: string,
  requestDomain: string,
  signerKeyring: string,
  signerDomain: string
) :Promise<string> => {
  const contractRequest = readFromFile('client/v1/pubkeys-deactivate.zen');
  let data = await preparePks(requestKeyring, requestDomain, 'client/v1/did-settings.json');
  data = JSON.parse(data);
  data["signer_did_spec"] = signerDomain;
  data = JSON.stringify(data);
  const {result} = await zencode_exec(contractRequest, {data, keys : signerKeyring});
  return result;
}

/**
 * send the `request` to https://did.dyne.org/`endpoint`
 * @param endpoint api endpoint to send the request to
 * @param request the signed request to be sent
 * @returns the result of the request
 */
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