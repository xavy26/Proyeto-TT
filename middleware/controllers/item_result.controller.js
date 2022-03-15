const fabricNetwork = require('./fabricNetwork');
const Controller = {};
const ORG = process.env.ORG_ID || "org1";

Controller.get_Item_Result_By_Id = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetItem_ResultById', req.params.id.toString());
    let response = JSON.parse(result.toString());
    res.json({
      status: 'success',
      statusstr: 'OK - Transaction has been submitted',
      data: {
        result: response
      },
      error: null
    });
  } catch (error) {
    console.error('Failed to evaluate transaction:',  error);
    res.status(500).json({
      status: 'error',
      statusstr: 'FAIL - An error has occurred',
      data: null,
      error: error
    });
  }
};

Controller.get_All_Item_Results = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetAllItem_Results', "");
    let response = JSON.parse(result.toString());
    res.json({
      status: 'success',
      statusstr: 'OK - Transaction has been submitted',
      data: {
        result: response
      },
      error: null
    });
  } catch (error) {
    console.error('Failed to evaluate transaction:',  error);
    res.status(500).json({
      status: 'error',
      statusstr: 'FAIL - An error has occurred',
      data: null,
      error: error
    });
  }
};

Controller.item_result_Exists = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('Item_ResultExists', req.params.id.toString());
    let response = JSON.parse(result.toString());
    res.json({
      status: 'success',
      statusstr: 'OK - Transaction has been submitted',
      data: {
        result: response
      },
      error: null
    });
  } catch (error) {
    console.error('Failed to evaluate transaction:',  error);
    res.status(500).json({
      status: 'error',
      statusstr: 'FAIL - An error has occurred',
      data: null,
      error: error
    });
  }
};

Controller.item_result_History = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const history = JSON.parse((await contract.evaluateTransaction('Item_ResultHistory', req.params.id.toString())).toString());
    const actual = JSON.parse((await contract.evaluateTransaction('GetItem_ResultById', req.params.id.toString())).toString());
    history.unshift(actual);
    res.json({
      status: 'success',
      statusstr: 'OK - Transaction has been submitted',
      data: {
        result: history
      },
      error: null
    });
  } catch (error) {
    console.error('Failed to evaluate transaction:',  error);
    res.status(500).json({
      status: 'error',
      statusstr: 'FAIL - An error has occurred',
      data: null,
      error: error
    });
  }
};

module.exports = Controller;
