import fs from 'fs';
import readdirp from 'readdirp';
import express from "express";
import chalk from "chalk";
import bodyParser from "body-parser";
import zencode from "@restroom-mw/core";
import timestamp from "@restroom-mw/timestamp";
import git from "@restroom-mw/git";
import db from "@restroom-mw/db";
import files from "@restroom-mw/files";
import rrredis from "@restroom-mw/redis";
import rrhttp from "@restroom-mw/http";
import fabric from "@restroom-mw/fabric";
import ethereum from "@restroom-mw/ethereum";
import logger from "@restroom-mw/logger";
import ui from "@restroom-mw/ui";

import http from "http";
import morgan from "morgan"
import dotenv from "dotenv";
dotenv.config();

const LOCAL_PORT = parseInt(process.env.LOCAL_PORT || "5000", 10);
const HOST = process.env.HOST || "0.0.0.0";
const ZENCODE_DIR = process.env.ZENCODE_DIR;
const OPENAPI = JSON.parse(process.env.OPENAPI || true);

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(morgan("dev"));
app.set("json spaces", 2);

app.use(db.default);
app.use(fabric.default);
app.use(files.default);
app.use(logger.default);
app.use(rrhttp.default);
app.use(rrredis.default);
app.use(ethereum.default);
app.use(timestamp.default);
app.use(git.default);
if (OPENAPI) {
  app.use("/docs", ui.default({ path: ZENCODE_DIR }));
}

app.use("/api/*", zencode.default);

const contracts = fs.readdirSync(ZENCODE_DIR);

const httpServer = http.createServer(app);
httpServer.listen(LOCAL_PORT, "0.0.0.0", () => {
  console.log(`🚻 Restroom started on http://${chalk.bold.blue(HOST)}:${LOCAL_PORT}`);
  console.log(`📁 the ZENCODE directory is: ${chalk.magenta.underline(ZENCODE_DIR)} \n`);

  if (OPENAPI) {
    console.log(`To see the OpenApi interface head your browser to: ${chalk.bold.blue.underline('http://' + HOST + ':' + LOCAL_PORT + '/docs')}`);
    console.log(`To disable OpenApi, run ${chalk.bold('OPENAPI=0 yarn start')}`);
  } else {
    console.log(`⚠️ The OpenApi is not enabled! NO UI IS SERVED. To enable it run run ${chalk.bold('OPENAPI=1 yarn start')}`);
  }

  console.log("\nExposing");
  readdirp(ZENCODE_DIR, { fileFilter: '*.zen|*.yaml|*.yml' }).on('data', (c) => {
    const endpoint = `/api/${c.path.replace('.zen', '')}`
    console.log(`\t${chalk.bold.green(endpoint)}`);
  });
});

