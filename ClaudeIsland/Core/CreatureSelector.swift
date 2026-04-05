//
//  CreatureSelector.swift
//  ClaudeIsland
//
//  Manages creature selection state for the settings menu
//

import Combine
import Foundation

@MainActor
class CreatureSelector: ObservableObject {
    static let shared = CreatureSelector()

    // MARK: - Published State

    @Published var isPickerExpanded: Bool = false
    @Published var selectedCreature: NotchCreature

    private init() {
        self.selectedCreature = AppSettings.notchCreature
    }

    // MARK: - Public API

    func select(_ creature: NotchCreature) {
        selectedCreature = creature
        AppSettings.notchCreature = creature
    }
}
