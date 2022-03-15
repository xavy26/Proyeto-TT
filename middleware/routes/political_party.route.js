var express = require('express');
var router = express.Router();

const Controller = require("../controllers/political_party.controller");

/* GET home page. */
router.get('/', Controller.get_All_Political_Partys);
router.get('/:id', Controller.get_Political_Party_By_Id);
router.get('/history/:id', Controller.political_party_History);
router.get('/exist/:id', Controller.political_party_Exists);
router.post('/', Controller.create_Political_Party);

module.exports = router;
