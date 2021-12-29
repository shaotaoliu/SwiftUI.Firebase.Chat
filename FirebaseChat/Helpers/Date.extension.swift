import Foundation

extension Date {

    func shortString() -> String {
        let now = Date()
        if self >= Calendar.current.startOfDay(for: now) {
            return shortTimeFormatter.string(from: self)
        }
            
        let days = daysBetween(from: self, to: Date())
        if days == 1 {
            return "Yesterday"
        }
        
        if days < 5 {
            let index = Calendar.current.component(.weekday, from: self) - 1
            return shortDateFormatter.weekdaySymbols[index]
        }
        
        return shortDateFormatter.string(from: self)
    }
    
    func longString(today: Bool = false) -> String {
        let now = Date()
        
        if self >= Calendar.current.startOfDay(for: now) {
            if today {
                return "Today " + shortTimeFormatter.string(from: self)
            }
            
            return shortTimeFormatter.string(from: self)
        }
            
        let days = daysBetween(from: self, to: Date())
        if days == 1 {
            return "Yesterday \(shortTimeFormatter.string(from: self))"
        }
        
        if days < 5 {
            let index = Calendar.current.component(.weekday, from: self) - 1
            return "\(shortDateFormatter.weekdaySymbols[index]) \(shortTimeFormatter.string(from: self))"
        }
        
        return "\(mediumDateFormatter.string(from: self)) \(shortTimeFormatter.string(from: self))"
    }
}

func daysBetween(from: Date, to: Date) -> Int {
    let from = Calendar.current.startOfDay(for: from)
    let to = Calendar.current.startOfDay(for: to)
    
    if let days = Calendar.current.dateComponents([.day], from: from, to: to).day {
        return days
    }
    
    return 0
}

func minutesBetween(from: Date, to: Date) -> Int {
    if let minutes = Calendar.current.dateComponents([.minute], from: from, to: to).minute {
        return minutes
    }
    
    return 0
}

let shortTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

let mediumDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
