import anyTest from "ava";
import bodyParser from "body-parser";
import express from "express";
import supertest from "supertest";

const test = anyTest;

process.env.ZENCODE_DIR = "../../contracts";
import zencode from "@restroom-mw/core";
import ethereum from "@restroom-mw/ethereum";

test.before(async (t) => {
  const app = express();
  app.use(bodyParser.json());
  app.use(ethereum.default);
  app.use("/*", zencode.default);
  t.context.app = supertest(app);
});

test.serial("Create a simple did document and verify it", async (t) => {
  const { app } = t.context;

  const res = await app.post("/sandbox/did-create");
  t.is(res.status, 200);
});
