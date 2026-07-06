//
//  DateMarkManager.swift
//  LunarBarMac
//
//  Created by cyan on 2024/12/01.
//

import AppKit
import LunarBarKit

/**
 Manages date marks with persistence using UserDefaults.

 Provides CRUD operations and sends notifications when marks change.
 */
@MainActor
final class DateMarkManager {
  static let `default` = DateMarkManager()

  /// Notification sent when marks change, for views to refresh.
  static let didChangeNotification = Notification.Name("DateMarkManager.didChange")

  private var marks: [String: DateMark] {
    didSet {
      save()
      NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
  }

  private init() {
    self.marks = Self.load()
  }

  // MARK: - Public API

  func mark(for date: Date) -> DateMark? {
    marks[Self.dateKey(from: date)]
  }

  func setMark(_ mark: DateMark, for date: Date) {
    marks[Self.dateKey(from: date)] = mark
  }

  func removeMark(for date: Date) {
    marks.removeValue(forKey: Self.dateKey(from: date))
  }

  func updateNote(_ note: String?, for date: Date) {
    let key = Self.dateKey(from: date)
    guard let existing = marks[key] else {
      return
    }

    marks[key] = DateMark(colorIndex: existing.colorIndex, note: note)
  }
}

// MARK: - Private

private extension DateMarkManager {
  static let storageKey = "date-marks"

  static func dateKey(from date: Date) -> String {
    Constants.dateKeyFormatter.string(from: date)
  }

  static func load() -> [String: DateMark] {
    guard let data = UserDefaults.standard.data(forKey: storageKey) else {
      return [:]
    }

    return (try? JSONDecoder().decode([String: DateMark].self, from: data)) ?? [:]
  }

  func save() {
    guard let data = try? JSONEncoder().encode(marks) else {
      Logger.log(.error, "Failed to encode date marks")
      return
    }

    UserDefaults.standard.set(data, forKey: Self.storageKey)
  }

  enum Constants {
    static let dateKeyFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      return formatter
    }()
  }
}
