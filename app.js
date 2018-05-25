var express = require('express');
var mysql = require('mysql');
var sConnection={host: 'localhost',port: 3306, user: 'root',password: 'root',database: 'dbcaseifici'};
var app = express();
app.use(express.static('.')); // Consente modalità "static"
app.use(require('body-parser').json());
app.use(require('body-parser').urlencoded({ extended: true }));

app.get('/',function(req, res) {
    res.redirect('login.html');
  });

app.post('/log',function(req, res) {
	connection = mysql.createConnection(sConnection);
  connection.connect(function(err){
    if(!err) {
      var sQuery="SELECT * FROM dbcaseifici.tblusers where username=? and pwd=?;";
      var data=[];
      console.log(req.body.username);
      data.push(req.body.username);
      data.push(req.body.password);
      connection.query(sQuery, data, function(err, rows, fields) {
        if (err) 
            res.sendStatus(500); //Internal Server Error
        else if (rows.length==0)
           res.sendStatus(401); //Unauthorized
        else    
          res.sendStatus(200);
      }); 
    } else {
      console.log("Error connecting database ... ");    
      res.sendStatus(500); //Internal Server Error
    }
  });
});
  
app.listen(3000);
