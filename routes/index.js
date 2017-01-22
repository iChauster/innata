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
var customerDude = {
  "code": 201,
  "message": "Customer created",
  "objectCreated": {
    "first_name": "pill",
    "last_name": "wark",
    "address": {
      "street_number": "10",
      "street_name": "Street",
      "city": "Skillman",
      "state": "NJ",
      "zip": "08558"
    },
    "_id": "5883ea8d1756fc834d8ebeae"
  }

}
var acctDude = {
  "code": 201,
  "message": "Account created",
  "objectCreated": {
    "type": "Checking",
    "nickname": "bho",
    "rewards": 0,
    "balance": 1000,
    "account_number": "1738173817381738",
    "customer_id": "5883ea8d1756fc834d8ebeae",
    "_id": "5883ecd91756fc834d8ebeaf"
  }
}
var whereMerch = {
  "message": "Created merchant",
  "code": 201,
  "objectCreated": {
    "name": "google",
    "category": [
      "tech"
    ],
    "address": {
      "street_number": "49",
      "street_name": "InfiniteLoop",
      "city": "Cupertino",
      "state": "CA",
      "zip": "08502"
    },
    "geocode": {
      "lat": 36,
      "lng": 30
    },
    "creation_date": "2017-01-21",
    "_id": "5883ef201756fc834d8ebeb0"
  }
}

var Config = (function() {
  function Config(){}
    Config.baseUrl = "http://api.reimaginebanking.com";

  Config.getApiKey = function() {
    return this.apiKey;
  };

  Config.setApiKey = function(key) {
    this.apiKey = key;
  };

  Config.request = request;

  return Config;
})();
Config.setApiKey(apiKey)

var cmo = (function() {
  function cmo(){}
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

  cmo.postCustByAcctId = function(acctId,acct,callback){
    console.log(Config.baseUrl+ '/customers/' + acctId + '/accounts' + this.apiKey());
  	request.post(Config.baseUrl + '/customers/' + acctId + '/accounts' + this.apiKey())
    .set({"Content-Type" : "application/json"})
    .send(acct)
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
  return cmo;
})();
var Merchant = (function() {
  function Merchant() {}

    Merchant.initWithKey = function(apiKey) {
        Config.setApiKey(apiKey);
        return this;
    }

    Merchant.urlWithEntity = function() {
        console.log(Config.baseUrl+'/merchants');
        return Config.baseUrl+'/merchants';
    }

    Merchant.apiKey = function() {
        return '?key=' + Config.apiKey;
    }
    Merchant.getMerchant = function(id, callback) {
    request.get(this.urlWithEntity() + '/' + id + this.apiKey())
      .end(function(err, res) {
        if (err) {
          console.log(err.message);
          return;
        }
        callback(JSON.parse(res.text));
      });
    }
    Merchant.createMerchant = function(merchant, callback) {
        console.log('go');
        console.log(merchant)
        console.log(this.urlWithEntity() + this.apiKey());
    request.post(this.urlWithEntity() + this.apiKey())
      .set({'Content-Type': 'application/json'})
      .send(merchant)
      .end(function(err, res) {
        if (err) {
          console.log(err.message);
          return;
        }
        /*
           {
               "name": "string",
               "address": {
                   "street_number": "string",
                   "street_name": "string",
                   "city": "string",
                   "state": "string",
                   "zip": "string",
           },
               "geocode": {
                   "lat": 0,
                   "lng": 0,
               }
           }
           */
        callback(res);

      });
    
}


    return Merchant;

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
  return Purchase;
})();
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});
router.post('/getPurchases', function(req,res,next){
  if(req.body.id){
    Purchase.getAll(req.body.id, function(text){
      var i = 0;
      var loop = function(text){
        console.log(text[i]);
        var merch = text[i]["merchant_id"];
        Merchant.getMerchant(merch,function(ayy){
          var name = ayy.name;
          console.log(name);
          var geocodePair = ayy.geocode
          text[i]["merchant_name"] = name;
          text[i]["geocode"] = geocodePair
          i++;
          console.log('iteration: ' + i + " length: " + text.length);
          if(i < text.length){
            loop(text);
          }else{
            end(text)
          }
        });
      }
      loop(text);
      //}
    });
    var end = function(text){
      res.send(JSON.stringify(text));
    }
  }
});
router.post('/makePurchase', function(req,res,next){
  if (req.body.id && req.body.merchant && req.body.date && req.body.amount && req.body.description) {
    acct = {
    "merchant_id": req.body.merchant,
    "medium": "balance",
    "purchase_date": req.body.date,
    "amount": req.body.amount,
    "description": req.body.description,
    };
    Purchase.createPurchase(req.body.id, acct, function(status){
      console.log(status);
    })
    }
  });
router.post('/accounts', function(req,res,next){
  if(req.body.id){
    acct = {

    }
    cmo.postCustByAcctId(req.body.id, function(text){
      console.log(text);
      console.log("Successful");
    })
  }
});
router.post('/postUser', function(req,res,next){
	if(req.body.id){
		var id = req.body.id;
		console.log(i);
		router.post("http://api.reimaginebanking.com/customers/"+id+"/accounts?key=afa1d15ae07d23d7b3c4e6443cabbf7d", function(req,res,next){
			console.log(res.status);
			console.log(res.body);
		});
	}
});
module.exports = router;
