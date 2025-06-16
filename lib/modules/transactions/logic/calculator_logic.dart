class CalculatorLogic {
  static String processNumberInput(String currentAmount, String number) {
    if (currentAmount == '0') {
      return number;
    } else {
      return currentAmount + number;
    }
  }

  static String processOperatorInput(String currentAmount, String operator) {
    if (operator == '+' ||
        operator == '-' ||
        operator == 'x' ||
        operator == '÷') {
      if (!currentAmount.endsWith('+') &&
          !currentAmount.endsWith('-') &&
          !currentAmount.endsWith('x') &&
          !currentAmount.endsWith('÷')) {
        return currentAmount + operator;
      }
    } else if (operator == '.') {
      if (!currentAmount.contains('.')) {
        return '$currentAmount.';
      }
    }
    return currentAmount;
  }

  static String calculateResult(String expression) {
    try {
      String normalizedExpression =
          expression.replaceAll('x', '*').replaceAll('÷', '/');
      double result = _evaluateExpression(normalizedExpression);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  static String deleteLastDigit(String currentAmount) {
    if (currentAmount.length > 1) {
      return currentAmount.substring(0, currentAmount.length - 1);
    } else {
      return '0';
    }
  }

  static double _evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    return _evaluateTokens(tokens);
  }

  static List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String currentToken = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char == '+' || char == '-' || char == '*' || char == '/') {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
        }
        tokens.add(char);
      } else {
        currentToken += char;
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }
    return tokens;
  }

  static double _evaluateTokens(List<String> tokens) {
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);

      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '*':
          result *= operand;
          break;
        case '/':
          result /= operand;
          break;
      }
    }
    return result;
  }
}
