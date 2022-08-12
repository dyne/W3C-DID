import fs from 'fs';
import readdirp from 'readdirp';
import express from "express";
import chalk from "chalk";
import bodyParser from "body-parser";
import zencode from "@restroom-mw/core";
import db from "@restroom-mw/db";
import fabric from "@restroom-mw/fabric";
import rrhttp from "@restroom-mw/http";
import rrredis from "@restroom-mw/redis";
import sawroom from "@restroom-mw/sawroom";
import ethereum from "@restroom-mw/ethereum";
import planetmint from "@restroom-mw/planetmint";
import timestamp from "@restroom-mw/timestamp";
import ui from "@restroom-mw/ui";

import http from "http";
import morgan from "morgan"
import dotenv from "dotenv";

dotenv.config();

const HTTP_PORT = parseInt(process.env.HTTP_PORT || "3000", 10);
const HOST = process.env.HOST || "0.0.0.0";
const ZENCODE_DIR = process.env.ZENCODE_DIR;
const OPENAPI = JSON.parse(process.env.OPENAPI || true);

const app = express();

/* TODO: move in another file */
// const HTTP_PORT = parseInt(process.env.HTTP_PORT || "8000", 10);
const API_SERVICE_URL = process.env.API_SERVICE_URL;

// Utils
import { createProxyMiddleware } from 'http-proxy-middleware';
const START = 'W3C-DID-resolve-did?data='+encodeURIComponent('{"id":"')
const END = encodeURIComponent('"}')

// Proxy endpoints
function add_identity_proxy(app) {
  app.use('/1.0/identifiers', createProxyMiddleware({
    target: API_SERVICE_URL,
    changeOrigin: true,
    pathRewrite: async function (path, req) {
      const splitPath = path.split('/');
      const did = splitPath[splitPath.length - 1];
      const finalPath = START + did + END;
      return finalPath;
    }
  }));
}

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(morgan("dev"));
app.set("json spaces", 2);

add_identity_proxy(app)
app.use(db.default);
app.use(fabric.default);
app.use(rrhttp.default);
app.use(rrredis.default);
app.use(sawroom.default);
app.use(ethereum.default);
app.use(planetmint.default);
app.use(timestamp.default);
if (OPENAPI) {
  app.use("/docs", ui.default({ path: ZENCODE_DIR }));
}

app.use("/api/*", zencode.default);

const contracts = fs.readdirSync(ZENCODE_DIR);

if (contracts.length > 0) {
  const httpServer = http.createServer(app);
  httpServer.listen(HTTP_PORT, HOST, () => {
    console.log(`🚻 Restroom started on http://${chalk.bold.blue(HOST)}:${HTTP_PORT}`);
    console.log(`📁 the ZENCODE directory is: ${chalk.magenta.underline(ZENCODE_DIR)} \n`);

    if (OPENAPI) {
      console.log(`To see the OpenApi interface head your browser to: ${chalk.bold.blue.underline('http://' + HOST + ':' + HTTP_PORT + '/docs')}`);
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
} else {
  console.log(`🚨 The ${chalk.magenta.underline(ZENCODE_DIR)} folder is empty, please add some ZENCODE smart contract before running Restroom`);
}

