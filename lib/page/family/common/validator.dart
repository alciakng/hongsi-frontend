/* --------------------------------------------------
이   름 : ValidDelegate
기   능 : email로 회원가입시 form Validation 체크를 진행한다. 
참고사항 : 1) 
수정이력 : 1) 2022/06/28  [김종환]  최초 작성
----------------------------------------------------- */

class ValidDelegate {
  // [] Validation 변수
  bool? _nameValid;
  bool? _dateValid;

  String? _nameErrorText;
  String? _dateErrorText;

  bool? get nameValid => _nameValid;
  bool? get dateValid => _dateValid;
  // 기념일 이름과 날짜 모두 유효한지 체크
  bool get anniversaryValid => (_nameValid ?? false) &  (_dateValid ?? false);

  String? get nameErrorText => _nameErrorText;
  String? get dateErrorText => _dateErrorText;

  set nameValid(val) => _nameValid = val;
  set dateValid(val) => _dateValid = val;

  set nameErrorText(val) {
    _nameErrorText = val;
    // 에러 텍스트가 없으면 유효
    nameValid = (val == null) ? true : false;
  }

  set dateErrorText(val) {
    _dateErrorText = val;
    dateValid = (val == null) ? true : false;
  }

  void clearVariable() {
    _nameValid = null;
    _dateValid = null;

    _nameErrorText = null;
    _dateErrorText = null;
  }

  void nameValidator(String? value) {
    if (value == '') {
      nameErrorText = '기념일명을 입력해주세요';
    } else {
      nameErrorText = null;
    }
  }

  void dateValidator(DateTime? value) {
    if (value == null) {
      dateErrorText = '날짜를 선택해주세요';
    } else {
      dateErrorText = null;
    }
  }
}
