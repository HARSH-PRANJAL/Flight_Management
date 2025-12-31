import Foundation

func formatDateTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy HH:mm"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter.string(from: date)
}
