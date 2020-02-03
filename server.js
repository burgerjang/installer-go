//const request = require('request');

//const url = "https://golang.org/dl/";

request(url, (error, response, body) => {
  if (error) throw error;

  console.log(body);
});
