import test from "ava";
import * as dotenv from "dotenv";
import { createKeyring, createRequest, signRequest, 
  sendRequest, createIfacerRequest, DidActions
} from "./index";
dotenv.config();

const sandboxTestAKeyring = JSON.parse(process.env.SANDBOX_TEST_ADMIN_KEYRING);
let acceptRequest: any = null;
let acceptSignedRequest: any = null;
let updateRequest: any = null;
let updateSignedRequest: any = null;
let deleteRequest: any = null;
let deleteSignedRequest: any = null;
let sandboxTestKeyring: any = null;
let ifacerTestKeyring: any = null;

test.serial("Create a sandbox keyring", async (t) => {
  sandboxTestKeyring = await createKeyring("sandbox_test_from_js");
  t.is(typeof sandboxTestKeyring, "object");
  t.is(sandboxTestKeyring["controller"], "sandbox_test_from_js");
  t.is(typeof sandboxTestKeyring["keyring"], "object");
  t.is(typeof sandboxTestKeyring["keyring"]["ecdh"], "string");
  t.is(typeof sandboxTestKeyring["keyring"]["eddsa"], "string");
  t.is(typeof sandboxTestKeyring["keyring"]["ethereum"], "string");
  t.is(typeof sandboxTestKeyring["keyring"]["bitcoin"], "string");
  t.is(typeof sandboxTestKeyring["keyring"]["reflow"], "string");
})

test.serial("Create an unsigned sandbox request", async (t) => {
  acceptRequest = await createRequest(sandboxTestKeyring, "sandbox.test", DidActions.CREATE);
  t.is(typeof acceptRequest, "object");
  t.is(typeof acceptRequest["did_document"]["@context"], "object");
  t.is(typeof acceptRequest["did_document"]["id"], "string");
  t.is(typeof acceptRequest["did_document"]["verificationMethod"], "object");
  t.is(acceptRequest["did_document"]["description"], "sandbox_test_from_js");
})

test.serial("Sign the sandbox accept request", async (t) => {
  acceptSignedRequest = await signRequest(
    acceptRequest, sandboxTestAKeyring, "sandbox.test_A");
  t.is(typeof acceptSignedRequest, "object");
  t.is(typeof acceptSignedRequest["did_document"]["@context"], "object");
  t.is(typeof acceptSignedRequest["did_document"]["id"], "string");
  t.is(typeof acceptSignedRequest["did_document"]["verificationMethod"], "object");
  t.is(acceptSignedRequest["did_document"]["description"], "sandbox_test_from_js");
  t.is(typeof acceptSignedRequest["ecdh_signature"], "object");
  t.is(typeof acceptSignedRequest["eddsa_signature"], "string");
  t.is(typeof acceptSignedRequest["timestamp"], "string");
  t.is(typeof acceptSignedRequest["id"], "string");
})

test.serial("Send the create request", async (t) => {
  const result = await sendRequest(
    "api/v1/sandbox/pubkeys-accept.chain",
    acceptSignedRequest
    );
  t.is(typeof result, "object");
  t.is(typeof result["result"], "object");
  t.is(typeof result["result"]["@context"], "string");
  t.is(typeof result["result"]["didDocument"], "object");
  t.is(typeof result["result"]["didDocumentMetadata"], "object");
  t.is(typeof result["result"]["didDocumentMetadata"]["created"], "string");
  t.is(result["result"]["didDocumentMetadata"]["deactivated"], "false");
})

test.serial("Create an unsigned update request", async (t) => {
  sandboxTestKeyring["controller"] = "sandbox_test_from_js_updated";
  updateRequest = await createRequest(sandboxTestKeyring, "sandbox.test", DidActions.UPDATE);
  t.is(typeof updateRequest, "object");
  t.is(typeof updateRequest["did_document"]["@context"], "object");
  t.is(typeof updateRequest["did_document"]["id"], "string");
  t.is(typeof updateRequest["did_document"]["verificationMethod"], "object");
  t.is(updateRequest["did_document"]["description"], "sandbox_test_from_js_updated");
})

test.serial("Sign the sandbox update request", async (t) => {
  updateSignedRequest = await signRequest(
    updateRequest, sandboxTestAKeyring, "sandbox.test_A");
  t.is(typeof updateSignedRequest, "object");
  t.is(typeof updateSignedRequest["did_document"]["@context"], "object");
  t.is(typeof updateSignedRequest["did_document"]["id"], "string");
  t.is(typeof updateSignedRequest["did_document"]["verificationMethod"], "object");
  t.is(updateSignedRequest["did_document"]["description"], "sandbox_test_from_js_updated");
  t.is(typeof updateSignedRequest["ecdh_signature"], "object");
  t.is(typeof updateSignedRequest["eddsa_signature"], "string");
  t.is(typeof updateSignedRequest["timestamp"], "string");
  t.is(typeof updateSignedRequest["id"], "string");
})

test.serial("Send the update request", async (t) => {
  const result = await sendRequest(
    "api/v1/sandbox/pubkeys-update.chain",
    updateSignedRequest
    );
  t.is(typeof result, "object");
  t.is(typeof result["result"], "object");
  t.is(typeof result["result"]["@context"], "string");
  t.is(typeof result["result"]["didDocument"], "object");
  t.is(typeof result["result"]["didDocumentMetadata"], "object");
  t.is(typeof result["result"]["didDocumentMetadata"]["updated"], "string");
  t.is(result["result"]["didDocumentMetadata"]["deactivated"], "false");
})

test.serial("Create an unsigned delete request", async (t) => {
  deleteRequest = await createRequest(sandboxTestKeyring, "sandbox.test", DidActions.DEACTIVATE);
  t.is(typeof deleteRequest, "object");
  t.is(typeof deleteRequest["deactivate_id"], "string");
})

test.serial("Sign the sandbox delete request", async (t) => {
  deleteSignedRequest = await signRequest(
    deleteRequest, sandboxTestAKeyring, "sandbox.test_A");
  t.is(typeof deleteSignedRequest, "object");
  t.is(typeof deleteSignedRequest["id"], "string");
  t.is(typeof deleteSignedRequest["deactivate_id"], "string");
  t.is(typeof deleteSignedRequest["ecdh_signature"], "object");
})

test.serial("Send the delete request", async (t) => {
  const result = await sendRequest(
    "api/v1/sandbox/pubkeys-deactivate.chain",
    deleteSignedRequest
    );
  t.is(typeof result, "object");
  t.is(typeof result["request_data"], "object");
  t.is(typeof result["request_data"]["@context"], "string");
  t.is(typeof result["request_data"]["didDocument"], "object");
  t.is(typeof result["request_data"]["didDocumentMetadata"], "object");
  t.is(result["request_data"]["didDocumentMetadata"]["deactivated"], "true");
})

test.serial("Create a ifacer keyring", async (t) => {
  ifacerTestKeyring = await createKeyring("ifacer_test_from_js");
  t.is(typeof ifacerTestKeyring, "object");
  t.is(ifacerTestKeyring["controller"], "ifacer_test_from_js");
  t.is(typeof ifacerTestKeyring["keyring"], "object");
  t.is(typeof ifacerTestKeyring["keyring"]["ecdh"], "string");
  t.is(typeof ifacerTestKeyring["keyring"]["eddsa"], "string");
  t.is(typeof ifacerTestKeyring["keyring"]["ethereum"], "string");
  t.is(typeof ifacerTestKeyring["keyring"]["bitcoin"], "string");
  t.is(typeof ifacerTestKeyring["keyring"]["reflow"], "string");
})

test.serial("Create a ifacer unsigned request", async (t) => {
  const ifacerAcceptRequest = await createIfacerRequest(
    ifacerTestKeyring, "ifacer.test", DidActions.CREATE, "061FKNW40X4CAEEAFSW8NZRCWG");
  t.is(typeof ifacerAcceptRequest, "object");
  t.is(typeof ifacerAcceptRequest["did_document"]["@context"], "object");
  t.true(ifacerAcceptRequest["did_document"]["@context"].map(a=>a.identifier).includes("https://schema.org/identifier"));
  t.is(typeof ifacerAcceptRequest["did_document"]["id"], "string");
  t.is(typeof ifacerAcceptRequest["did_document"]["verificationMethod"], "object");
  t.is(ifacerAcceptRequest["did_document"]["identifier"], "061FKNW40X4CAEEAFSW8NZRCWG");
  t.is(ifacerAcceptRequest["did_document"]["description"], "ifacer_test_from_js");
})