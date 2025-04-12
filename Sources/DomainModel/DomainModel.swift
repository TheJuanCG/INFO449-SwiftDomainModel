import math_h

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//


public struct Money {
    var amount: Int
    var currency: String
    private var currencyExchange: [String : (Int) -> Int]
    // Probably best to keep conversion string outside a specif function
    // will be using it for multiple
    // Maybe can use a dict where its key are two currencies
    // (oldCur, newCur) -> (Int) -> Int
    // String gets a func that takes in an int as parameter
    // this will be the current amount that will be converted
    // maybe will want to return double and then just round up to int
//    enum CurrencyError: Error {
//        case invalidCurrency(String)
//    }
    
    // Could throw error or make it optional
    // but seems to cause some problems
    // POSSIBLE QUESTION
    init(amount: Int, currency: String) {
        guard ["USD", "GBP", "EUR", "CAN"].contains(currency) else {
            self.amount = 0
            self.currency = ""
            self.currencyExchange = [:]
            return
        }
        
        self.amount = amount
        self.currency = currency
        self.currencyExchange = [:]
        
        currencyExchange["USD, GBP"] = { (curAmount: Int) -> Int in return Int(round(Double(curAmount)/2.0)) }
        currencyExchange["USD, EUR"] = { (curAmount: Int) -> Int in return Int(round(Double(curAmount)*1.5)) }
        currencyExchange["USD, CAN"] = { (curAmount: Int) -> Int in return Int(round(Double(curAmount)*1.25)) }
        
        currencyExchange["CAN, USD"] = { (curAmount: Int) -> Int in return Int(round(Double(curAmount)*0.8)) }
        currencyExchange["EUR, USD"] = { (curAmount: Int) -> Int in return Int(round(Double(curAmount)*(2.0/3.0))) }
        currencyExchange["GBP, USD"] = { (curAmount: Int) -> Int in return Int(round(Double(curAmount)*2.0)) }
        
        
    }
    
    func convert(_ currency: String) -> Money {
        // No edge cases taken care of current
        // Normalizing to USD
        if self.currency != "USD" {
            // need to convert to usd and then get the new value
            var usdAmount = currencyExchange["\(self.currency), USD"].self!(self.amount)
            
            var newAmount = currencyExchange["USD, \(currency)"].self!(usdAmount)
            
            let res = Money(amount: newAmount, currency: currency)
            return res
            
        }
        
        // Don't need to normalize, just from USD to new Value
        var newAmount = currencyExchange["\(self.currency), \(currency)"].self!(amount)
        
        let res = Money(amount: newAmount, currency: currency)
        return res
        
        
    }
    
    func add(_ other: Money) -> Money {
        // Case where they are the same currency and don't need to convert
        if self.currency == other.currency {
            return Money(amount: self.amount + other.amount, currency: self.currency)
        }
        
        // the return currency is whatever the money coming in is
        let convertedMoney = self.convert(other.currency)
        
        return Money(amount: other.amount + convertedMoney.amount, currency: other.currency)
        
        
    }
    
    func subtract(_ other: Money) -> Money {
        // Case where they are the same currency and don't need to convert
        if self.currency == other.currency {
            return Money(amount: self.amount - other.amount, currency: self.currency)
        }
        
        // the return currency is whatever the money coming in is
        let convertedMoney = self.convert(other.currency)
        
        return Money(amount: convertedMoney.amount - other.amount, currency: other.currency)
        
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
