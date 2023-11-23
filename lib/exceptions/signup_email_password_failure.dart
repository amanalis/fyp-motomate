/*

class SignUpWithEmailAndPasswordFailure {
  final String message;

  SignUpWithEmailAndPasswordFailure([this.message = "An Unknown error occured."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure('Please enter a stronger password');
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure("Email is not vaild or badly formatted.");
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure("An account already exists for that email.");
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure("Operation is not allowedd. Please contact support.");
      case 'user-disable':
        return SignUpWithEmailAndPasswordFailure("This user has been disabled. Please contact support for help.");
      default:
        return SignUpWithEmailAndPasswordFailure();
    }
  }
}*/
