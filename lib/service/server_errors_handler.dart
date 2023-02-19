import 'package:covid19_assistant/model/errors_model.dart';

class ServerErrors {
  factory ServerErrors() {
    return _instance;
  }

  ServerErrors._internal();

  static final ServerErrors _instance = ServerErrors._internal();

  static ServerErrors get instance => _instance;

  getError(ErrorsItem error) {
    switch (error.statusCode) {
      case 401:
        return ErrorsItem(message: 'wrong_credential');
      case 410:
        return ErrorsItem(message: 'already_replied');
      case 411:
        return ErrorsItem(message: 'phone_num_used');
      case 412:
        return ErrorsItem(message: 'wrong_credential');
      case 413:
        return ErrorsItem(message: 'username_used');
      case 415:
        return ErrorsItem(message: 'constraint_failed');
      case 422:
        {
          if (error.message.contains('username'))
            return ErrorsItem(message: 'username_exists');
          else if (error.message.contains('email')) return ErrorsItem(message: 'email_exists');
          break;
        }
      case 454:
        {
          if (error.message.contains('phonenumber'))
            return ErrorsItem(message: 'phone_num_used');
          else if (error.message.contains('email')) return ErrorsItem(message: 'email_exists');
          break;
        }
      case 404:
      case 450:
        return ErrorsItem(message: 'not_found');
      case 464:
        return ErrorsItem(message: 'student_already_exist');

      default:
        return ErrorsItem(message: 'something_went_wrong');
    }
  }

}
