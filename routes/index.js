var express = require('express');
var router = express.Router();
//afa1d15ae07d23d7b3c4e6443cabbf7d
/* GET home page. */
 var apiKey = "afa1d15ae07d23d7b3c4e6443cabbf7d";

router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.post('/postUser', function(req,res,next){
	if(req.body.id){
		var i = req.body.id;
		console.log(i);
		router.post("http://api.reimaginebanking.com/customers/"+id+"/accounts?key=your_key", function(req,res,next){
			console.log(res.status);
			console.log(res.body);
		});
	}
});
module.exports = router;
