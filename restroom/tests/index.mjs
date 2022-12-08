import anyTest from "ava";
import bodyParser from "body-parser";
import express from "express";
import supertest from "supertest";

const test = anyTest;

process.env.ZENCODE_DIR = "../../contracts";
import zencode from "@restroom-mw/core";
import timestamp from "@restroom-mw/timestamp";

test.before(async (t) => {
  const app = express();
  app.use(bodyParser.json());
  app.use(timestamp.default);
  app.use("/*", zencode.default);
  t.context.app = supertest(app);
});

test.serial("Create a simple did document and verify it", async (t) => {
  const { app } = t.context;
  const didkeys = {
	"bitcoin_public_key": "24FWY6sMx2MvH1EEoncuWr4dh4NJ7Pmo5WDNst4oztg7s",
	"ecdh_public_key": "SJ3uY8Y5cKYsMqqvW3rZaX7h4s1ms5NpAYeHUi16A7jHMVtwSF3Gdzafh9XmvGz6uNksBnaU5fvarDw1mZF2Nkjz",
	"eddsa_public_key": "2s5wmQjZeYtpckyHakLiP5ujWKDL1M2b8CiP6vwajNrK",
	"ethereum_address": "2d7VjFP8URbrYFqXYWkUNW9gbiaS",
	"reflow_public_key": "3LfL2v8qz2cmgy8LRqLPL4H12mt2rW3p7hrwJ6q1gqpHKyXWovkCutsJRsLxkrgHwQ233gouwWFmzshS5EnK9dah92855jzaqV4fD53svqLBrxdV2nt44aEMuWoXYSwA4dmTwHXpgsyQuCsn6uNewbF5VLcesqJubzHf4XvVF9249F1HVLmMR7oCKVBnCw3pTB2HrcmSJaSdKu88rJbzELTvdMLbXXyEcCvYDT3HhzGXNv9BBTo9ZXQGw1CSCCyDrCNMYe"
  }

  const did = await app.post("/sandbox/did-document-create")
    .send({ keys: {}, data: didkeys });
  t.is(did.status, 200);
  const res = await app.post("/sandbox/did-create")
    .send({ keys: {}, data: did.body })
  t.is(res.status, 200);
});
