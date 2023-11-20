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

const HTTP_PORT = parseInt(process.env.HTTP_PORT || "80", 10);
const HTTPS_PORT = parseInt(process.env.HTTPS_PORT || "443", 10);
const LOCAL_PORT = parseInt(process.env.LOCAL_PORT || "3000", 10);
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


const formatInput = (input) => {
    return { data: input }
}

// TODO: check existance of eddsa pk in Did document when jobId not found
// In case of error try to make it more easier to read

app.post('/create', async (req, res) => {
    const body = JSON.stringify(formatInput(req.body));
    var r;
    if (req.body.jobId) {
	r = await fetch('http://localhost:3000/api/create-2-sign.chain', {
	    method: "POST",
	    body: body,
	    headers: {
		"Accept": "application/json",
		"Content-Type": "application/json"
	    }
	});
    } else {
	r = await fetch('http://localhost:3000/api/create-1-checks.chain', {
	    method: "POST",
	    body: body,
	    headers: {
		"Accept": "application/json",
		"Content-Type": "application/json"
	    }
	});
    }
    const rr = await r.json();
    if (r.status == "500") res.send(rr.zenroom_errors)
    else res.send(rr);
})

// TODO: accept only setDidDocument or nil values for didDocumentOperation
app.post('/update', async (req, res) => {
    const body = JSON.stringify(formatInput(req.body));
    var r;
    if (req.body.jobId) {
	r = await fetch('http://localhost:3000/api/update-2-sign.chain', {
	    method: "POST",
	    body: body,
	    headers: {
		"Accept": "application/json",
		"Content-Type": "application/json"
	    }
	});
    } else {
	r = await fetch('http://localhost:3000/api/update-1-checks.chain', {
	    method: "POST",
	    body: body,
	    headers: {
		"Accept": "application/json",
		"Content-Type": "application/json"
	    }
	});
    }
    const rr = await r.json();
    if (r.status == "500") res.send(rr.zenroom_errors)
    else res.send(rr);
})

const contracts = fs.readdirSync(ZENCODE_DIR);

if (contracts.length > 0) {
  const httpServer = http.createServer(app);
  httpServer.listen(LOCAL_PORT, HOST, () => {
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
} else {
  console.log(`🚨 The ${chalk.magenta.underline(ZENCODE_DIR)} folder is empty, please add some ZENCODE smart contract before running Restroom`);
}

