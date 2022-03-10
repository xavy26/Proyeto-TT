const fabricNetwork = require('./fabricNetwork');
const Controller = {};
const ORG = process.env.ORG_ID || "org1";

Controller.create_Voter = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    let voter = {
      voterId: req.body.id,
      name: req.body.name,
      last_name: req.body.last_name,
      dni: req.body.dni,
      email: req.body.email,
      function: req.body.function
    };
    let tx = await contract.submitTransaction('CreateVoter', JSON.stringify(voter));
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

Controller.get_Voter_By_Id = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetVoterById', req.params.id.toString());
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

Controller.get_All_Voters = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetAllVoters', "");
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

Controller.voter_Exists = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('VoterExists', req.params.id.toString());
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

Controller.voter_History = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const history = JSON.parse((await contract.evaluateTransaction('VoterHistory', req.params.id.toString())).toString());
    const actual = JSON.parse((await contract.evaluateTransaction('GetVoterById', req.params.id.toString())).toString());
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
