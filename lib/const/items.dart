class items {
  static Map<String, dynamic> userInfo = {'name': 'おさかな', 'userid': '12345', 'tasks': [], 'rooms': [], 'mail': ''};

  static Map<String, dynamic> friend = {
    '12345': {'name': 'おさかな', 'userTask': [], 'message': [], 'myroom': '1234', 'bool': false},
    '23456': {'name': 'せろり', 'userTask': [], 'message': [], 'myroom': '1234', 'bool': false},
    '67890': {'name': 'ニャリオット', 'userTask': [], 'message': [], 'myroom': '2345', 'bool': false}
  };

  // 画像リスト
  static Map taskMaid = {
    'move': ['assets/images/Maid_gif.gif'],
    'standing': [
      'assets/images/taskMaid_01.png', //とてもうれしい
      'assets/images/taskMaid_03.png', //びっくり
      'assets/images/taskMaid_04.png', //おろおろ
    ],
    'stamp': [
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp02.png',
      'assets/images/stamp/taskMaid_stamp03.png',
      'assets/images/stamp/taskMaid_stamp04.png',
      'assets/images/stamp/taskMaid_stamp05.png',
      'assets/images/stamp/taskMaid_stamp06.png',
      'assets/images/stamp/taskMaid_stamp07.png',
      'assets/images/stamp/taskMaid_stamp08.png',
    ],
  };
}
