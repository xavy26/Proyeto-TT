import 'package:e_voting/src/models/candidate.model.dart';
import 'package:e_voting/src/models/voter.model.dart';

class Cosntants {

  static final String URL_BLOCKHAIN = '';
  static final String REQUIRED = 'Campo requerido.';

  static List<VoterModel> voters = [];
  static List<CandidateModel> candidates = [];
  static bool isLogin = false;
  static bool isAdmin = false;
  static bool vote = false;
}