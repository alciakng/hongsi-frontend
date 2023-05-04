/* --------------------------------------------------
이   름 : ValidDelegate
기   능 : email로 회원가입시 form Validation 체크를 진행한다. 
참고사항 : 1) 
수정이력 : 1) 2022/06/28  [김종환]  최초 작성
----------------------------------------------------- */

class ValidDelegate {
  // [] Validation 변수
  bool? _emailValid;
  bool? _passwordValid;
  bool? _confirmPasswordValid;
  bool? _nicknameValid;
  bool? _rolenameValid;

  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  String? _nicknameErrorText;
  String? _rolenameErrorText;

  bool? get emailValid => _emailValid;
  bool? get passwordValid => _passwordValid;
  bool? get confirmPasswordValid => _confirmPasswordValid;
  bool? get nicknameValid => _nicknameValid;
  bool? get rolenameValid => _rolenameValid;
  // [] 패스워드 폼에서 두개의 폼이 모두 유효한지 체크
  bool? get passwordCheckValid =>
      (_passwordValid ?? false) & (_confirmPasswordValid ?? false);

  bool? get nameCheckValid =>
      (_nicknameValid ?? false) & (_rolenameValid ?? false);

  String? get emailErrorText => _emailErrorText;
  String? get passwordErrorText => _passwordErrorText;
  String? get confirmPasswordErrorText => _confirmPasswordErrorText;
  String? get nicknameErrorText => _nicknameErrorText;
  String? get rolenameErrorText => _rolenameErrorText;

  set emailValid(val) => _emailValid = val;
  set paaswordValid(val) => _passwordValid = val;
  set confirmPasswordValid(val) => _confirmPasswordValid = val;
  set nicknameValid(val) => _nicknameValid = val;
  set rolenameValid(val) => _rolenameValid = val;

  set emailErrorText(val) {
    _emailErrorText = val;
    //에러 텍스트가 없으면 유효
    emailValid = (val == null) ? true : false;
  }

  set passwordErrorText(val) {
    _passwordErrorText = val;
    paaswordValid = (val == null) ? true : false;
  }

  set confirmPasswordErrorText(val) {
    _confirmPasswordErrorText = val;
    confirmPasswordValid = (val == null) ? true : false;
  }

  set nicknameErrorText(val) {
    _nicknameErrorText = val;
    _nicknameValid = (val == null) ? true : false;
  }

  set rolenameErrorText(val) {
    _rolenameErrorText = val;
    _rolenameValid = (val == null) ? true : false;
  }

  void clearVariable() {
    _emailValid = null;
    _passwordValid = null;
    _confirmPasswordValid = null;
    _nicknameValid = null;
    _rolenameValid = null;

    _emailErrorText = null;
    _passwordErrorText = null;
    _confirmPasswordErrorText = null;
    _nicknameErrorText = null;
    _rolenameErrorText = null;
  }

  void emailValidator(String value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    var status = regExp.hasMatch(value);

    if (value.isEmpty) {
      emailErrorText = '이메일을 입력해주세요.';
      return;
    }

    if (!status) {
      emailErrorText = '올바른 이메일주소를 입력해주세요';
      return;
    }
  }

  void passwordValidator(String value) {
    String p = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\w\W]{8,}$';

    RegExp regExp = RegExp(p);

    var status = regExp.hasMatch(value);

    if (!status) {
      passwordErrorText = '패스워드는 영어 소문자, 숫자를 포함하여 8~15자리여야 합니다.';
    } else {
      passwordErrorText = null;
    }
  }

  void confirmPasswordValidator(String password, String confirmPassword) {
    bool status = (password == confirmPassword);

    if (!status) {
      passwordErrorText = '패스워드가 일치하지 않습니다';
    } else {
      passwordErrorText = null;
    }
  }

  void nicknameValidator(String nickname) {
    if (nickname.length > 10) {
      nicknameErrorText = '닉네임은 10자 이내여야 합니다.';
      return;
    }

    if (nickname.isEmpty) {
      nicknameErrorText = '닉네임을 입력해주세요.';
      return;
    }

    nicknameErrorText = null;
  }

  void rolenameValidator(String rolename) {
    if (rolename.length > 10) {
      rolenameErrorText = '역할은 10자 이내여야 합니다.';
      return;
    }

    if (rolename.isEmpty) {
      rolenameErrorText = '역할을 입력해주세요.';
      return;
    }

    rolenameErrorText = null;
  }
}
