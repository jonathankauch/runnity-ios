import Foundation

extension String {
    static func formatDateApi(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: date)
    }
    
    static func noDateShortTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: date)
    }
    
    static func mediumDateShortTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    static func mediumDateNoTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    static func shortDateNoTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
    
    static func fullDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
}

extension Date {
    static func from(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: string)
    }
}
