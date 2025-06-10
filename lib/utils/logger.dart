void logInfo({required String functionName, required String message}) {
  print("LOGS - 🔵 [$functionName] Info: $message");
}

void logStarting({required String functionName, required String message}) {
  print("LOGS - 🟠 [$functionName] Starting: $message");
}

void logOngoing({required String functionName, required String message}) {
  print("LOGS - 🟡 [$functionName] Ongoing: $message");
}

void logSuccess(
    {required String functionName, required String message, int? code}) {
  print(
      "LOGS - 🟢 [$functionName] ${code != null ? "Code $code" : ""} Success: $message");
}

void logFailure({required String functionName, required String message}) {
  print("LOGS - ❌ [$functionName] Failure: $message");
}

void logError(
    {required String functionName,
    required String message,
    required int? errorCode}) {
  print("LOGS - 🔴 [$functionName] Error (Code: $errorCode): $message");
}

void logProcessing({required String functionName, required String message}) {
  print("LOGS - 🔄 [$functionName] Processing: $message");
}
