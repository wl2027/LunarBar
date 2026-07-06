//
//  DateMark.swift
//  LunarBarMac
//
//  Created by cyan on 2024/12/01.
//

import AppKit

/**
 Data model for a date mark, including a color index and an optional note.
 */
struct DateMark: Codable, Equatable {
  let colorIndex: Int
  let note: String?

  init(colorIndex: Int, note: String? = nil) {
    self.colorIndex = colorIndex
    self.note = note
  }
}

// MARK: - Preset Colors

extension DateMark {
  static let presetColors: [(name: String, color: NSColor)] = [
    (Localized.DateMark.colorRed, .systemRed),
    (Localized.DateMark.colorOrange, .systemOrange),
    (Localized.DateMark.colorYellow, .systemYellow),
    (Localized.DateMark.colorGreen, .systemGreen),
    (Localized.DateMark.colorBlue, .systemBlue),
    (Localized.DateMark.colorPurple, .systemPurple),
    (Localized.DateMark.colorPink, .systemPink),
    (Localized.DateMark.colorBrown, .systemBrown),
  ]

  var color: NSColor {
    let index = max(0, min(colorIndex, Self.presetColors.count - 1))
    return Self.presetColors[index].color
  }
}
