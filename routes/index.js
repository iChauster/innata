var express = require('express');
var router = express.Router();
var request = require('superagent');


 var apiKey = "afa1d15ae07d23d7b3c4e6443cabbf7d";

var bruh = {
  "code": 0,
  "message": "string",
  "objectCreated": {
    "_id": "string",
    "type": "Credit Card",
    "nickname": "string",
    "rewards": 0,
    "balance": 0,
    "account_number": "string",
    "customer_id": "string"
  }
}


var Config = (function() {
  function Config() { }
  Config.baseUrl = "http://api.reimaginebanking.com:80";

  Config.getApiKey = function() {
    return this.apiKey;
  };

  Config.setApiKey = function(key) {
    this.apiKey = key;
  };

  Config.request = request;

  return Config;
})();


var cmo = (function() {
  function cmo() {}

  cmo.urlWithEntity = function() {
    return Config.baseUrl + "/customers";
  };

  cmo.urlWithAcctEntity = function() {
    return Config.baseUrl + "/accounts";
  };

  cmo.apiKey = function() {
    return '?key=' + Config.apiKey;
  };

  cmo.initWithKey = function(key) {
    Config.setApiKey(key);
    return this;
  };

  cmo.postCustByAcctId = function(acctId, callback){
  	request
  	.post(Config.baseUrl + '/accounts' + acctId + '/customers' + this.apiKey())
  	.end(function(err, res) {
        if (err) {
          console.log(err.message);
          return;
        }
        callback(res.text);
      });
  };

  cmo.getByCustAcctId = function(acctId){
  	var accounts;
  	var request = $.ajax({ 
				url: this.urlWithCustomerEntity()+customerId+'/accounts',
				data: 'key='+this.apiKey(),
				async: false,
				dataType: 'json'
			});
  	request.complete(function(results) {
				accounts = results.responseJSON;
			});
  	return accounts;
  };
})();
var Purchase = (function() {
  function Purchase() {}

	Purchase.initWithKey = function(apiKey) {
		Config.setApiKey(apiKey);
		return this;
	};

	Purchase.urlWithEntity = function() {
		return Config.baseUrl+'/purchases/';
	};

	Purchase.urlWithAccountEntity = function() {
		return Config.baseUrl+'/accounts/';
	};

	Purchase.apiKey = function() {
		return '?key=' + Config.apiKey;
	};

	//Get the purchases from the acct
		Purchase.getAll = function(id, callback) {
		request.get(this.urlWithAccountEntity()+id+'/purchases' + this.apiKey())
      .end(function(err, res) {
        if (err) {
          console.log(err.message);
          return;
        }
        callback(JSON.parse(res.text));
      });
	};


//Post the purchases to the server
		Purchase.createPurchase = function(accID, json, callback) {
    request.post(this.urlWithAccountEntity()+accID+'/purchases'+this.apiKey())
      .set({'Content-Type': 'application/json'})
      .send(json)
      .end(function(err, res) {
        if (err) {
          console.log(err.message);
          return;
        }
        callback(res.statusCode);
      });
	};
})();
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.post('/postUser', function(req,res,next){
	if(req.body.id){
		var i = req.body.id;
		console.log(i);
		router.post("http://api.reimaginebanking.com/customers/"+id+"/accounts?key=afa1d15ae07d23d7b3c4e6443cabbf7d", function(req,res,next){
			console.log(res.status);
			console.log(res.body);
		});
	}
});
module.exports = router;
