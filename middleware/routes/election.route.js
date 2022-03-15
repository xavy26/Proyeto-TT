var express = require('express');
var router = express.Router();

const Controller = require("../controllers/election.controller");

/* GET home page. */
router.get('/', Controller.get_All_Elections);
router.get('/:id', Controller.get_Election_By_Id);
router.get('/history/:id', Controller.election_History);
router.get('/exist/:id', Controller.election_Exists);
router.post('/', Controller.create_Election);

module.exports = router;
