//
//  CreaturePickerRow.swift
//  ClaudeIsland
//
//  Creature selection picker for settings menu
//

import SwiftUI

struct CreaturePickerRow: View {
    @ObservedObject var creatureSelector: CreatureSelector
    @State private var isHovered = false

    private var isExpanded: Bool {
        creatureSelector.isPickerExpanded
    }

    private func setExpanded(_ value: Bool) {
        creatureSelector.isPickerExpanded = value
    }

    var body: some View {
        VStack(spacing: 0) {
            // Main row - shows current selection
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    setExpanded(!isExpanded)
                }
            } label: {
                HStack(spacing: 10) {
                    NotchCreatureIcon(creature: creatureSelector.selectedCreature, size: 12)
                        .frame(width: 16)

                    Text("Creature")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(textColor)

                    Spacer()

                    Text(creatureSelector.selectedCreature.rawValue)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                        .lineLimit(1)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isHovered ? Color.white.opacity(0.08) : Color.clear)
                )
            }
            .buttonStyle(.plain)
            .onHover { isHovered = $0 }

            // Expanded creature list
            if isExpanded {
                VStack(spacing: 2) {
                    ForEach(NotchCreature.allCases, id: \.self) { creature in
                        CreatureOptionRow(
                            creature: creature,
                            isSelected: creatureSelector.selectedCreature == creature
                        ) {
                            creatureSelector.select(creature)
                            collapseAfterDelay()
                        }
                    }
                }
                .padding(.leading, 28)
                .padding(.top, 4)
            }
        }
    }

    private var textColor: Color {
        .white.opacity(isHovered ? 1.0 : 0.7)
    }

    private func collapseAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
                setExpanded(false)
            }
        }
    }
}

// MARK: - Creature Option Row

private struct CreatureOptionRow: View {
    let creature: NotchCreature
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                NotchCreatureIcon(creature: creature, size: 10, animate: isHovered)

                Text(creature.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(isHovered ? 1.0 : 0.7))

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(TerminalColors.green)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isHovered ? Color.white.opacity(0.06) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
