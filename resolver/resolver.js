const express = require('express');
const axios = require('axios').default;

const app = express();

const PORT = 12002;
const HOST = "localhost";

app.use('/1.0/identifiers/:did', function(req, res) {
    axios.get('http://localhost:12001/api/W3C-DID-resolve-did?data=%7B%22id%22%3A%22'+req.params.did+'%22%7D')
	.then(function (response) {
	    res.send(response.data['W3C-DID'] || response.data);
	});
});

// Start Proxy
app.listen(PORT, HOST, () => {
    console.log(`Starting Proxy at ${HOST}:${PORT}`);
});
