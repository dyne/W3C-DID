import fs from 'fs';
import path from 'path';
import readdirp from 'readdirp';
import express from "express";
import chalk from "chalk";
import bodyParser from "body-parser";
import zencode from "@restroom-mw/core";
import { validateSubdir } from "@restroom-mw/utils";
import ui from "@restroom-mw/ui";
import cors from "cors"
import process from 'node:process';

import http from "http";
import morgan from "morgan"
import dotenv from "dotenv";
dotenv.config();

const HTTP_PORT = parseInt(process.env.HTTP_PORT || "3000", 10);
const HOST = process.env.HOST || "0.0.0.0";
const ZENCODE_DIR = process.env.ZENCODE_DIR;
const FILES_DIR = process.env.FILES_DIR;
const OPENAPI = JSON.parse(process.env.OPENAPI || true);


const validatePath = validateSubdir(FILES_DIR);

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(morgan("dev"));
app.set("json spaces", 2);

app.use(cors())
if (OPENAPI) {
  app.use("/docs", ui.default({ path: ZENCODE_DIR }));
}
zencode.addMiddlewares("/api", app);


// Explorer apis
const DID_BEGIN = "did:dyne:"
const pathToDidId = (didPath) => {
  const folders = didPath.split(path.sep)
  if(folders.length == 3) {
    return `${DID_BEGIN}${folders[0]}.${folders.slice(1).join(':')}`;
  } else {
    return `${DID_BEGIN}${folders.join(':')}`;
  }
}
const didIdToPath = (didId) => {
  if(!didId.startsWith(DID_BEGIN)) {
    throw new Error(`Invalid did id "${didId}"`)
  }
  didId = didId.slice(DID_BEGIN.length)
  const didPath = didId.replace('.', path.sep).replace(':', path.sep)
  return didPath
}
app.get('/dids', (req, res) => {
  const offset = req.query.offset || 0;
  const limit = req.query.limit || 20;
  const search = req.query.search || '';
  let dids = []

  const stream = readdirp(path.join(FILES_DIR, 'data'), {fileFilter: '[^.]*'});
  stream.on('data', (entry) => {
    const didPath = entry.path
    if(didPath.includes(search)) {
      dids.push(pathToDidId(didPath))
    }
  })
  // Optionally call stream.destroy() in `warn()` in order to abort and cause 'close' to be emitted
    .on('warn', error => console.error('non-fatal error', error))
    .on('error', error => console.error('fatal error', error))
    .on('close', () => res.json({moreDids: dids.length > offset+limit, dids: dids.slice(offset, offset+limit)}));
})

app.get('/dids/:id', (req, res) => {
  const didPath = path.join(path.join(FILES_DIR, 'data'), didIdToPath(req.params.id))
  validatePath(didPath);
  fs.stat(didPath, (err, _) => {
    if(err) {
      res.status(400).send("The did doesn't exist");
    } else {
      res.writeHead(200, {
        "Content-Type": "application/json",
      });
      fs.createReadStream(didPath).pipe(res);
      return;
    }
  })

})
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

