var MMDBReader = require('mmdb-reader');

// Load synchronously
var reader = new MMDBReader('./my-ip-data.mmdb');

console.log(reader.lookup('8.8.8.8'));
