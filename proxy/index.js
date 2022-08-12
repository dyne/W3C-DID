const express = require('express')
const { createProxyMiddleware } = require('http-proxy-middleware')

// Create Express Server
const app = express();

// Configuration
const PORT = 443;
const HOST = "localhost";
const API_SERVICE_URL = "https://did.dyne.org:443/api";

// Utils
const START = 'W3C-DID-resolve-did?data='+encodeURIComponent('{"id":"')
const END = encodeURIComponent('"}')

// Proxy endpoints
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

// Start Proxy
app.listen(PORT, HOST, () => {
    console.log(`Starting Proxy at ${HOST}:${PORT}`);
});
