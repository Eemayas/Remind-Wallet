class SubstitutionCipher {
  static const Map<String, String> _encryptionMap = {
    'a': 'q',
    'A': 'Q',
    'b': 'w',
    'B': 'W',
    'c': 'e',
    'C': 'E',
    'd': 'r',
    'D': 'R',
    'e': 't',
    'E': 'T',
    'f': 'y',
    'F': 'Y',
    'g': 'u',
    'G': 'U',
    'h': 'i',
    'H': 'I',
    'i': 'o',
    'I': 'O',
    'j': 'p',
    'J': 'P',
    'k': 'a',
    'K': 'A',
    'l': 's',
    'L': 'S',
    'm': 'd',
    'M': 'D',
    'n': 'f',
    'N': 'F',
    'o': 'g',
    'O': 'G',
    'p': 'h',
    'P': 'H',
    'q': 'j',
    'Q': 'J',
    'r': 'k',
    'R': 'K',
    's': 'l',
    'S': 'L',
    't': 'z',
    'T': 'Z',
    'u': 'x',
    'U': 'X',
    'v': 'c',
    'V': 'C',
    'w': 'v',
    'W': 'V',
    'x': 'b',
    'X': 'B',
    'y': 'n',
    'Y': 'N',
    'z': 'm',
    'Z': 'M',
    '0': '9',
    '1': '8',
    '2': '7',
    '3': '6',
    '4': '5',
    '5': '4',
    '6': '3',
    '7': '2',
    '8': '1',
    '9': '0',
    '!': '@',
    '@': '#',
    '#': '\$',
    '\$': '%',
    '%': '^',
    '^': '&',
    '&': '*',
    '*': '(',
    '(': ')',
    ')': '-',
    '-': '_',
    '_': '=',
    '=': '+',
    '+': '[',
    '[': ']',
    ']': '{',
    '{': '}',
    '}': '|',
    '|': ':',
    ':': ';',
    ';': '<',
    '<': '>',
    '>': ',',
    ',': '.',
    '.': '?',
    '?': '/',
  };

  static const Map<String, String> _decryptionMap = {
    'q': 'a',
    'Q': 'A',
    'w': 'b',
    'W': 'B',
    'e': 'c',
    'E': 'C',
    'r': 'd',
    'R': 'D',
    't': 'e',
    'T': 'E',
    'y': 'f',
    'Y': 'F',
    'u': 'g',
    'U': 'G',
    'i': 'h',
    'I': 'H',
    'o': 'i',
    'O': 'I',
    'p': 'j',
    'P': 'J',
    'a': 'k',
    'A': 'K',
    's': 'l',
    'S': 'L',
    'd': 'm',
    'D': 'M',
    'f': 'n',
    'F': 'N',
    'g': 'o',
    'G': 'O',
    'h': 'p',
    'H': 'P',
    'j': 'q',
    'J': 'Q',
    'k': 'r',
    'K': 'R',
    'l': 's',
    'L': 'S',
    'z': 't',
    'Z': 'T',
    'x': 'u',
    'X': 'U',
    'c': 'v',
    'C': 'V',
    'v': 'w',
    'V': 'W',
    'b': 'x',
    'B': 'X',
    'n': 'y',
    'N': 'Y',
    'm': 'z',
    'M': 'Z',
    '9': '0',
    '8': '1',
    '7': '2',
    '6': '3',
    '5': '4',
    '4': '5',
    '3': '6',
    '2': '7',
    '1': '8',
    '0': '9',
    '@': '!',
    '#': '@',
    '\$': '#',
    '%': '\$',
    '^': '%',
    '&': '^',
    '*': '&',
    '(': '*',
    ')': '(',
    '-': ')',
    '_': '-',
    '=': '_',
    '+': '=',
    '[': '+',
    ']': '[',
    '{': ']',
    '}': '{',
    '|': '}',
    ':': '|',
    ';': ':',
    '<': ';',
    '>': '<',
    ',': '>',
    '.': ',',
    '?': '.',
    '/': '?',
  };

  static String encrypt(String plaintext) {
    String encryptedText = '';
    for (int i = 0; i < plaintext.length; i++) {
      String char = plaintext[i];
      if (_encryptionMap.containsKey(char)) {
        encryptedText += _encryptionMap[char]!;
      } else {
        encryptedText += char;
      }
    }
    return encryptedText;
  }

  static String decrypt(String encryptedText) {
    String decryptedText = '';
    for (int i = 0; i < encryptedText.length; i++) {
      String char = encryptedText[i];
      if (_decryptionMap.containsKey(char)) {
        decryptedText += _decryptionMap[char]!;
      } else {
        decryptedText += char;
      }
    }
    return decryptedText;
  }
}

// void main() {
//   String originalText = 'Hello, World! 123';
//   String encryptedText = SubstitutionCipher.encrypt(originalText);
//   String decryptedText = SubstitutionCipher.decrypt(encryptedText);

//   print('Original Text: $originalText');
//   print('Encrypted Text: $encryptedText');
//   print('Decrypted Text: $decryptedText');
// }
