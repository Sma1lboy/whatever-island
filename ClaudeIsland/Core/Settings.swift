//
//  Settings.swift
//  ClaudeIsland
//
//  App settings manager using UserDefaults
//

import Foundation

/// Available notch creatures
enum NotchCreature: String, CaseIterable {
    case crab = "Crab"
    case owl = "Owl"
    case cat = "Cat"
    case fox = "Fox"
    case octopus = "Octopus"

    /// Default color for this creature
    var defaultColor: (red: Double, green: Double, blue: Double) {
        switch self {
        case .crab:     return (0.85, 0.47, 0.34)  // Orange-red
        case .owl:      return (0.65, 0.55, 0.40)  // Brown
        case .cat:      return (0.80, 0.60, 0.30)  // Orange
        case .fox:      return (0.90, 0.50, 0.20)  // Warm orange
        case .octopus:  return (0.60, 0.40, 0.75)  // Purple
        }
    }
}

/// Available notification sounds
enum NotificationSound: String, CaseIterable {
    case none = "None"
    case pop = "Pop"
    case ping = "Ping"
    case tink = "Tink"
    case glass = "Glass"
    case blow = "Blow"
    case bottle = "Bottle"
    case frog = "Frog"
    case funk = "Funk"
    case hero = "Hero"
    case morse = "Morse"
    case purr = "Purr"
    case sosumi = "Sosumi"
    case submarine = "Submarine"
    case basso = "Basso"

    /// The system sound name to use with NSSound, or nil for no sound
    var soundName: String? {
        self == .none ? nil : rawValue
    }
}

enum AppSettings {
    private static let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Keys {
        static let notificationSound = "notificationSound"
        static let notchCreature = "notchCreature"
    }

    // MARK: - Notch Creature

    /// The creature displayed in the notch
    static var notchCreature: NotchCreature {
        get {
            guard let rawValue = defaults.string(forKey: Keys.notchCreature),
                  let creature = NotchCreature(rawValue: rawValue) else {
                return .crab
            }
            return creature
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.notchCreature)
        }
    }

    // MARK: - Notification Sound

    /// The sound to play when Claude finishes and is ready for input
    static var notificationSound: NotificationSound {
        get {
            guard let rawValue = defaults.string(forKey: Keys.notificationSound),
                  let sound = NotificationSound(rawValue: rawValue) else {
                return .pop // Default to Pop
            }
            return sound
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.notificationSound)
        }
    }
}
