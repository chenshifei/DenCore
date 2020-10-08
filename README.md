# DenCore

DenCore is a swift library featuring the major functions of a virtual calculator. It is intented to be used together with the [Dentaku](https://github.com/chenshifei/Dentaku) app, though you can build your own app with it too.

## Main Functions

### Arithmetic

Elementry level calculation including add, substract, multiply, divison, sin and cos (Though sin and cos aren't really elementray level).
Currently DenCore only supports one operator at a time. There is no operator precedence. But later I would switch to RPN expressions to handle complicated equations.

### Reverse Geocoding

Parsing readable address from a coordination using the builtin `CoreLocation` functions.

### BTC Currency

Calcuate how much USD your bitcoin worth through the `coinbase` API.

## Usage

### Arithmetic

Create a `Processor` instance and then tap keys like you would do on a real calculator

    let processor = Processor() // Simulates a real processor in the calculator
    processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
    processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
    processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
    processor.operatorKeyPressed(key: DefaultKeys.Operator.substract)
    processor.numpadKeyPressed(key: .digit(underlyingValue: 4))
    let result = processor.functionKeyPressed(.equal)

    // result = -1

### Reverse Geocoding

Create an `AntennaDish` instance and call its `parseLocation()` function.

    let location = CLLocation(latitude: 59.31, longitude: 18.06)
    antennaDish.parseLocation(location) { (result, error) in
        // If success, result is a non-nil CLPlacemark object, otherwise error is a non-nil Error object
        if let placemark = result {
            print(placemark.administrativeArea) // "Stockholm"
        }
    }

### BTC Currency

Call `DefaultEndpoints.Currency.fetchExchangeRates()`.

    DefaultEndpoints.Currency.fetchExchangeRates { (result, error) in
        // If success, result is a non-nil ExchangeRates object, otherwise error is a non-nil Error object
        if let exchangeRates = result {
            print(exchangeRates.data.rates["USD"]) // "10600.2"
        }
    }
