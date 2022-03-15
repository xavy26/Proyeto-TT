const fabricNetwork = require('./fabricNetwork');
const Controller = {};
const ORG = process.env.ORG_ID || "org1";

Controller.create_Candidate = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    let candidate = {
      candidateId: req.body.id,
      position: req.body.position,
      photo: req.body.photo,
      voterId: req.body.voterId
    };
    let tx = await contract.submitTransaction('CreateCandidate', JSON.stringify(candidate));
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

Controller.get_Candidate_By_Id = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetCandidateById', req.params.id.toString());
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

Controller.get_All_Candidates = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('GetAllCandidates', "");
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

Controller.candidate_Exists = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const result = await contract.evaluateTransaction('CandidateExists', req.params.id.toString());
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

Controller.candidate_History = async (req, res) => {
  try {
    const contract = await fabricNetwork.connectNetwork('connection-' + ORG + '.json', 'wallet/wallet-' + ORG);
    const history = JSON.parse((await contract.evaluateTransaction('CandidateHistory', req.params.id.toString())).toString());
    const actual = JSON.parse((await contract.evaluateTransaction('GetCandidateById', req.params.id.toString())).toString());
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
