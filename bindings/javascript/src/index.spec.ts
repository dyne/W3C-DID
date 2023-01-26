import test from "ava";
import * as dotenv from "dotenv";
import { createKeyring, createRequest, signRequest, 
  sendRequest, createIfacerRequest
} from "./index";
dotenv.config();

const sandboxTestAKeyring = process.env.SANDBOX_TEST_ADMIN_KEYRING;
let acceptRequest: string = null;
let acceptSignedRequest: string = null;
let updateRequest: string = null;
let updateSignedRequest: string = null;
let deleteRequest: string = null;
let deleteSignedRequest: string = null;
let sandboxTestKeyring: string = null;
let ifacerTestKeyring: string = null;

test.serial("Create a sandbox keyring", async (t) => {
  sandboxTestKeyring = await createKeyring("sandbox_test_from_js");
  t.is(typeof sandboxTestKeyring, "string");
  const r = JSON.parse(sandboxTestKeyring);
  t.is(typeof r["sandbox_test_from_js"], "object");
  t.is(r["controller"], "sandbox_test_from_js");
  t.is(typeof r["sandbox_test_from_js"]["keyring"]["ecdh"], "string");
  t.is(typeof r["sandbox_test_from_js"]["keyring"]["eddsa"], "string");
  t.is(typeof r["sandbox_test_from_js"]["keyring"]["ethereum"], "string");
  t.is(typeof r["sandbox_test_from_js"]["keyring"]["bitcoin"], "string");
  t.is(typeof r["sandbox_test_from_js"]["keyring"]["reflow"], "string");
})

test.serial("Create an unsigned sandbox request", async (t) => {
  acceptRequest = await createRequest(sandboxTestKeyring, "sandbox.test", "create");
  t.is(typeof acceptRequest, "string");
  const r = JSON.parse(acceptRequest);
  t.is(typeof r["request"]["did_document"]["@context"], "object");
  t.is(typeof r["request"]["did_document"]["id"], "string");
  t.is(typeof r["request"]["did_document"]["verificationMethod"], "object");
  t.is(r["request"]["did_document"]["description"], "sandbox_test_from_js");
})

test.serial("Sign the sandbox accept request", async (t) => {
  acceptSignedRequest = await signRequest(
    acceptRequest, sandboxTestAKeyring, "sandbox.test_A");
  t.is(typeof acceptSignedRequest, "string");
  const r = JSON.parse(acceptSignedRequest);
  t.is(typeof r["did_document"]["@context"], "object");
  t.is(typeof r["did_document"]["id"], "string");
  t.is(typeof r["did_document"]["verificationMethod"], "object");
  t.is(r["did_document"]["description"], "sandbox_test_from_js");
  t.is(typeof r["ecdh_signature"], "object");
  t.is(typeof r["eddsa_signature"], "string");
  t.is(typeof r["timestamp"], "string");
  t.is(typeof r["id"], "string");
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
  let updateDescription = JSON.parse(sandboxTestKeyring)
  updateDescription["controller"] = "sandbox_test_from_js_updated";
  updateDescription["sandbox_test_from_js_updated"] = updateDescription["sandbox_test_from_js"];
  delete updateDescription["sandbox_test_from_js"];
  sandboxTestKeyring = JSON.stringify(updateDescription);
  updateRequest = await createRequest(sandboxTestKeyring, "sandbox.test", "update");
  t.is(typeof updateRequest, "string");
  const r = JSON.parse(updateRequest);
  t.is(typeof r["request"]["did_document"]["@context"], "object");
  t.is(typeof r["request"]["did_document"]["id"], "string");
  t.is(typeof r["request"]["did_document"]["verificationMethod"], "object");
  t.is(r["request"]["did_document"]["description"], "sandbox_test_from_js_updated");
})

test.serial("Sign the sandbox update request", async (t) => {
  updateSignedRequest = await signRequest(
    updateRequest, sandboxTestAKeyring, "sandbox.test_A");
  t.is(typeof updateSignedRequest, "string");
  const r = JSON.parse(updateSignedRequest);
  t.is(typeof r["did_document"]["@context"], "object");
  t.is(typeof r["did_document"]["id"], "string");
  t.is(typeof r["did_document"]["verificationMethod"], "object");
  t.is(r["did_document"]["description"], "sandbox_test_from_js_updated");
  t.is(typeof r["ecdh_signature"], "object");
  t.is(typeof r["eddsa_signature"], "string");
  t.is(typeof r["timestamp"], "string");
  t.is(typeof r["id"], "string");
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
  deleteRequest = await createRequest(sandboxTestKeyring, "sandbox.test", "deactivate");
  t.is(typeof deleteRequest, "string");
  const r = JSON.parse(deleteRequest);
  t.is(typeof r["request"]["deactivate_id"], "string");
})

test.serial("Sign the sandbox delete request", async (t) => {
  deleteSignedRequest = await signRequest(
    deleteRequest, sandboxTestAKeyring, "sandbox.test_A");
  t.is(typeof deleteSignedRequest, "string");
  const r = JSON.parse(deleteSignedRequest);
  t.is(typeof r["id"], "string");
  t.is(typeof r["deactivate_id"], "string");
  t.is(typeof r["ecdh_signature"], "object");
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
  t.is(typeof ifacerTestKeyring, "string");
  const r = JSON.parse(ifacerTestKeyring);
  t.is(typeof r["ifacer_test_from_js"], "object");
  t.is(r["controller"], "ifacer_test_from_js");
  t.is(typeof r["ifacer_test_from_js"]["keyring"]["ecdh"], "string");
  t.is(typeof r["ifacer_test_from_js"]["keyring"]["eddsa"], "string");
  t.is(typeof r["ifacer_test_from_js"]["keyring"]["ethereum"], "string");
  t.is(typeof r["ifacer_test_from_js"]["keyring"]["bitcoin"], "string");
  t.is(typeof r["ifacer_test_from_js"]["keyring"]["reflow"], "string");
})

test.serial("Create a ifacer unsigned request", async (t) => {
  const ifacerAcceptRequest = await createIfacerRequest(
    ifacerTestKeyring, "ifacer.test", "create", "061FKNW40X4CAEEAFSW8NZRCWG");
  t.is(typeof ifacerAcceptRequest, "string");
  const r = JSON.parse(ifacerAcceptRequest);
  t.is(typeof r["request"]["did_document"]["@context"], "object");
  t.true(r["request"]["did_document"]["@context"].map(a=>a.identifier).includes("https://schema.org/identifier"));
  t.is(typeof r["request"]["did_document"]["id"], "string");
  t.is(typeof r["request"]["did_document"]["verificationMethod"], "object");
  t.is(r["request"]["did_document"]["identifier"], "061FKNW40X4CAEEAFSW8NZRCWG");
  t.is(r["request"]["did_document"]["description"], "ifacer_test_from_js");
})