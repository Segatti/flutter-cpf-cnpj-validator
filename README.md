
# CPF/CNPJ Validator
  
A Flutter plugin to validate CPF/CNPJ numbers from Brazil.  

[![pub package](https://img.shields.io/pub/v/cpf_cnpj_validator.svg)](https://pub.dev/packages/cpf_cnpj_validator_new)
  
## Installation  
Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  cpf_cnpj_validator: 2.1.0
```
  
## Usage CPF  
  
``` dart  
// Import package  
import 'package:cpf_cnpj_validator/cpf_validator.dart';  
  
CPFValidator.isValid("334.616.710-02") // true
CPFValidator.isValid("334.616.710-01") // false
CPFValidator.isValid("35999906032") // true
CPFValidator.isValid("35999906031") // false
CPFValidator.isValid("033461671002") // false

// If you dont want the validation method to strip the values
// Just use false in the second argument
CPFValidator.isValid("334.616.710-02", false) // false
CPFValidator.isValid("35999906032@mail", false) // false


// Other utility methods
CPFValidator.format("33461671002") // Result: 334.616.710-02
CPFValidator.strip("334.616.710-02") // Result: 33461671002

// Generate a raw CPF number, without format
CPFValidator.generate() // Result: 33461671002

// Generate a formatted CPF number
CPFValidator.generate(true) // Result: 334.616.710-02 
```  

## Usage CNPJ

Supports the **numeric** CNPJ (legacy) and the **alphanumeric** CNPJ (IN RFB 2.229/2024): 14 positions, first 12 are `0-9` / `A-Z`, last 2 are check digits. Numeric-only CNPJs keep working as before.

```dart
// Import package
import 'package:cpf_cnpj_validator_new/cnpj_validator.dart';

// Numeric CNPJ (unchanged)
CNPJValidator.isValid("12.175.094/0001-19") // true
CNPJValidator.isValid("12.175.094/0001-18") // false
CNPJValidator.isValid("17942159000128") // true
CNPJValidator.isValid("17942159000127") // false
CNPJValidator.isValid("017942159000128") // false

// Alphanumeric CNPJ (strip normalizes to uppercase)
CNPJValidator.isValid("AA345678000114") // true
CNPJValidator.isValid("AA.345.678/000A-29") // true
CNPJValidator.isValid("12.345.678/000A-08") // true
CNPJValidator.isValid("aa345678000114") // true (lowercase accepted)

// If you dont want the validation method to strip the values,
// use false in the second argument (exactly 14 chars [0-9A-Za-z])
CNPJValidator.isValid("12.175.094/0001-19", false) // false
CNPJValidator.isValid("17942159000128@mail", false) // false
CNPJValidator.isValid("AA345678000114", false) // true

// Other utility methods
CNPJValidator.format("85137090000110") // Result: 85.137.090/0001-10
CNPJValidator.format("AA345678000114") // Result: AA.345.678/0001-14
CNPJValidator.strip("85.137.090/0001-10") // Result: 85137090000110
CNPJValidator.strip("AA.345.678/0001-14") // Result: AA345678000114

// Generate a random CNPJ (12 alphanumeric chars + 2 check digits; always 14 chars)
CNPJValidator.generate() // 14 chars: may be all digits or letters A-Z in the base
CNPJValidator.generate(true) // same, with mask XX.XXX.XXX/XXXX-XX
```

## Credits

This library was updated based on the library below.

[https://github.com/leonardocaldas/flutter-cpf-cnpj-validator](flutter-cpf-cnpj-validator)

## Contributing

If you wish to contribute to this project, I encourage you to open a pull request.