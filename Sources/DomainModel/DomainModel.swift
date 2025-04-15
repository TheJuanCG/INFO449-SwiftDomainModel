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
            let usdAmount = currencyExchange["\(self.currency), USD"].self!(self.amount)
            //print("InC: \(currency), OldC: \(self.currency), oldAm: \(self.amount)")
            if (currency == "USD"){
                return Money(amount: usdAmount, currency: "USD")
            }
            
            
            let newAmount = currencyExchange["USD, \(currency)"].self!(usdAmount)
            
            let res = Money(amount: newAmount, currency: currency)
            return res
            
        }
        
        // Don't need to normalize, just from USD to new Value
        let newAmount = currencyExchange["\(self.currency), \(currency)"].self!(amount)
        
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
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        // Return money made in calendar year
        // Hourly == rate*2000
        // For hourly, 50 * hours worked per week
        switch type {
        case .Hourly(let double):
            return Int(round(double * Double(hours)))
        case .Salary(let uInt):
            return Int(uInt)
        }
    }
    
    func calculateIncome() -> Int {
        // Same as previous one but without hours input (assume 40 hours)
        switch type {
        case .Hourly(let double):
            return Int(round(double * 40.0 * 50.0))
        case .Salary(let uInt):
            return Int(uInt)
        }
    }
    
    func raise(byAmount: Int) {
        // This should be for salor
        switch type {
        case .Hourly(let double):
            return
        case .Salary(let uInt):
            type = JobType.Salary(uInt + UInt(byAmount))
        }
    }
    
    func raise(byAmount: Double) {
        // This should be for salor
        switch type {
        case .Hourly(let double):
            type = JobType.Hourly(double + byAmount)
        case .Salary(let uInt):
            return
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let double):
            type = JobType.Hourly(double * (1.0 + byPercent))
        case .Salary(let uInt):
            type = JobType.Salary(UInt(round(Double(uInt)*(1.0 + byPercent))))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    private var _job: Job?
    private var _spouse: Person?
    // if less than 16 can't have job
    
    var spouse: Person? {
        set {
            if spouse == nil && age > 15{
                _spouse = newValue
            }
        }
        get{
            return _spouse
        }
    }
    
    var job: Job? {
        get {return _job}
        
        set {
            if age > 15 {
                _job = newValue
            }
        }
    }
    
    
    
    init(firstName: String,
         lastName: String,
         age: Int,
         job: Job,
         spouse: Person) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    init(firstName: String,
         lastName: String,
         age: Int) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
    

}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    private var maxAgeSpouse: Int
    
    init(spouse1: Person, spouse2: Person) {
        self.members = [spouse1, spouse2]
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        
        maxAgeSpouse = max(spouse1.age, spouse2.age)
    }

    func haveChild(_ child: Person) -> Bool {
        // Return true if possible, false if not
        
        // Need to check age of at least 1 spouse be 21
        // Just iterate through household and check if anyone is above 21 and spouse != nil?
        // Or just have a saved variable when creating a family
        if maxAgeSpouse > 21 {
            members.append(child)
            return true
        }
        
        return false
    }
    
    func householdIncome() -> Int {
        var res = 0
        
        for member in members {
            if let income = member.job?.calculateIncome() {
                res += income
            }
        }
        print("Family Income: \(res)")
        return res
    }
}
