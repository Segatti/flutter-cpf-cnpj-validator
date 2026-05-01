import 'dart:math';

class CNPJValidator {
  /// CNPJs inválidos por repetição (formato numérico legado).
  static const List<String> BLACKLIST = [
    "00000000000000",
    "11111111111111",
    "22222222222222",
    "33333333333333",
    "44444444444444",
    "55555555555555",
    "66666666666666",
    "77777777777777",
    "88888888888888",
    "99999999999999"
  ];

  /// Remove pontuação; mantém letras e dígitos (padrão alfanumérico IN RFB 2.229/2024).
  static const STRIP_REGEX = r'[^0-9A-Za-z]';

  /// Valor numérico para o módulo 11: código ASCII do caractere menos 48
  /// (0–9 inalterados; A=17 … Z=42). Letras minúsculas são tratadas como maiúsculas.
  static int _asciiMinus48(String char) {
    final c = char.toUpperCase();
    final code = c.codeUnitAt(0);
    if ((code >= 0x30 && code <= 0x39) || (code >= 0x41 && code <= 0x5A)) {
      return code - 48;
    }
    throw FormatException('Caractere inválido no CNPJ: $char');
  }

  // Cálculo do dígito verificador (módulo 11), conforme IN RFB 2.229/2024
  // (compatível com CNPJ exclusivamente numérico).
  static int _verifierDigit(String cnpjBase) {
    int index = 2;

    final reverse = cnpjBase
        .split('')
        .map((s) => _asciiMinus48(s))
        .toList()
        .reversed
        .toList();

    var sum = 0;

    for (final value in reverse) {
      sum += value * index;
      index = (index == 9 ? 2 : index + 1);
    }

    final mod = sum % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }

  static String format(String cnpj) {
    final s = strip(cnpj);
    final regExp = RegExp(r'^(.{2})(.{3})(.{3})(.{4})(.{2})$');

    return s.replaceAllMapped(
        regExp, (Match m) => '${m[1]}.${m[2]}.${m[3]}/${m[4]}-${m[5]}');
  }

  static String strip(String? cnpj) {
    final regex = RegExp(STRIP_REGEX);
    final raw = cnpj == null ? '' : cnpj;

    return raw.replaceAll(regex, '').toUpperCase();
  }

  /// [stripBeforeValidation] `true` (padrão): remove pontuação e normaliza maiúsculas.
  /// `false`: o valor deve ter exatamente 14 caracteres em [0-9A-Za-z] (sem remover nada).
  static bool isValid(String? cnpj, [bool stripBeforeValidation = true]) {
    if (stripBeforeValidation) {
      cnpj = strip(cnpj);
    } else {
      if (cnpj == null || cnpj.isEmpty) {
        return false;
      }
      if (cnpj.length != 14 ||
          !RegExp(r'^[0-9A-Za-z]{14}$').hasMatch(cnpj)) {
        return false;
      }
      cnpj = cnpj.toUpperCase();
    }

    if (cnpj.isEmpty) {
      return false;
    }

    if (cnpj.length != 14) {
      return false;
    }

    if (!RegExp(r'^[0-9A-Z]{12}[0-9]{2}$').hasMatch(cnpj)) {
      return false;
    }

    if (BLACKLIST.contains(cnpj)) {
      return false;
    }

    try {
      final base = cnpj.substring(0, 12);
      var withDv = base + _verifierDigit(base).toString();
      withDv += _verifierDigit(withDv).toString();

      return withDv.substring(withDv.length - 2) ==
          cnpj.substring(cnpj.length - 2);
    } on FormatException {
      return false;
    }
  }

  static String generate([bool useFormat = false]) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rnd = Random();
    var body = '';

    for (var i = 0; i < 12; i += 1) {
      body += chars[rnd.nextInt(chars.length)];
    }

    body += _verifierDigit(body).toString();
    body += _verifierDigit(body).toString();

    return useFormat ? format(body) : body;
  }
}
