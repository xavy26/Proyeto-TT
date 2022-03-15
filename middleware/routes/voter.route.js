var express = require('express');
var router = express.Router();

const Controller = require("../controllers/voter.controller");

/* GET home page. */
router.get('/', Controller.get_All_Voters);
router.get('/:id', Controller.get_Voter_By_Id);
router.get('/history/:id', Controller.voter_History);
router.get('/exist/:id', Controller.voter_Exists);
router.post('/', Controller.create_Voter);

module.exports = router;
