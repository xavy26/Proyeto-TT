var express = require('express');
var router = express.Router();

const Controller = require("../controllers/candidate.controller");

/* GET home page. */
router.get('/', Controller.get_All_Candidates);
router.get('/:id', Controller.get_Candidate_By_Id);
router.get('/history/:id', Controller.candidate_History);
router.get('/exist/:id', Controller.candidate_Exists);
router.post('/', Controller.create_Candidate);

module.exports = router;
