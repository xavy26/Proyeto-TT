var express = require('express');
var router = express.Router();

const Controller = require("../controllers/item_result.controller");

/* GET home page. */
router.get('/', Controller.get_All_Item_Results);
router.get('/:id', Controller.get_Item_Result_By_Id);
router.get('/history/:id', Controller.item_result_History);
router.get('/exist/:id', Controller.item_result_Exists);

module.exports = router;
