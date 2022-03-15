var express = require('express');
var router = express.Router();

const Controller = require("../controllers/vote.controller");

/* GET home page. */
router.get('/', Controller.get_All_Votes);
router.get('/:id', Controller.get_Vote_By_Id);
router.get('/history/:id', Controller.vote_History);
router.get('/exist/:id', Controller.vote_Exists);
router.post('/', Controller.create_Vote);

module.exports = router;
