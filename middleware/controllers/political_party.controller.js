const fabricNetwork = require('./fabricNetwork');
const Controller = {};
const ORG = process.env.ORG_ID || "org1";

Controller.create_Political_Party = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    let political_party = {
      political_partyId: req.body.id,
      name: req.body.name,
      description: req.body.description,
      logo: req.body.logo,
      candidatesId: req.body.candidatesId
    };
    let tx = await contract.submitTransaction('CreatePolitical_Party', JSON.stringify(political_party));
    res.json({
      status: 'success',
      statusstr: 'OK - Transaction has been submitted',
      data: {
        txid: tx.toString()
      },
      error: null
    });
  } catch (error) {
    console.error('Failed to evaluate transaction:', error);
    res.status(500).json({
      status: 'error',
      statusstr: 'FAIL - An error has occurred',
      data: null,
      error: error
    });
  }
};

Controller.get_Political_Party_By_Id = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetPolitical_PartyById', req.params.id.toString());
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

Controller.get_All_Political_Partys = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetAllPolitical_Partys', "");
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

Controller.political_party_Exists = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('Political_PartyExists', req.params.id.toString());
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

Controller.political_party_History = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const history = JSON.parse((await contract.evaluateTransaction('Political_PartyHistory', req.params.id.toString())).toString());
    const actual = JSON.parse((await contract.evaluateTransaction('GetPolitical_PartyById', req.params.id.toString())).toString());
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
