const express = require('express');
const axios = require('axios').default;

dotenv.config();

const RESOLVER_PORT = parseInt(process.env.RESOLVER_HTTP_PORT || "3000", 10);;
const RESOLVER_HOST = process.env.RESOLVER_HOST || "0.0.0.0";
const DID_PORT = parseInt(process.env.HTTP_PORT || "3000", 10);

const app = express();

app.use('/1.0/identifiers/:did', function(req, res) {
    axios.get('http://localhost:'+DID_PORT+'/api/W3C-DID-resolve-did?data=%7B%22id%22%3A%22'+req.params.did+'%22%7D')
	.then(function (response) {
	    res.send(response.data['W3C-DID'] || response.data);
	});
});

// Start Proxy
app.listen(RESOLVER_PORT, RESOLVER_HOST, () => {
    console.log(`Starting Proxy at ${HOST}:${PORT}`);
});
