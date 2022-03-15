var express = require('express');
var router = express.Router();

const Controller = require("../controllers/result.controller");

/* GET home page. */
router.get('/', Controller.get_All_Results);
router.get('/:id', Controller.get_Result_By_Id);
router.get('/history/:id', Controller.result_History);
router.get('/exist/:id', Controller.result_Exists);

module.exports = router;
