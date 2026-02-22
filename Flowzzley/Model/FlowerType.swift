import Foundation

enum FlowerType: String, CaseIterable, Identifiable {
    case lily
    case rose
    case tulip
    case sunflower
    case lavender
    case orchid

    var id: String { rawValue }

    var order: Int {
        FlowerType.allCases.firstIndex(of: self) ?? 0
    }

    var displayTitle: String {
        switch self {
        case .lily: return "It's a Lily!"
        case .rose: return "It's a Rose!"
        case .tulip: return "It's a Tulip!"
        case .sunflower: return "It's a Sunflower!"
        case .lavender: return "It's Lavender!"
        case .orchid: return "It's an Orchid!"
        }
    }

    var description: String {
        switch self {
        case .lily:
            return "Lilies are majestic flowers known for their large, fragrant blooms. They symbolize purity and have been revered in cultures worldwide for thousands of years."
        case .rose:
            return "The red rose is the ultimate symbol of romantic love and passion. Its deep crimson petals have inspired poets and lovers for centuries."
        case .tulip:
            return "As one of the world’s most recognisable flowers, the simple yet beautiful tulip can be found in many people’s homes and gardens. While not too big, too small or too bright, the tulip flower is just right! "
        case .sunflower:
            return "Sunflowers symbolize loyalty and adoration, inspired by the myth of Clytie and Apollo, and are known as cheerful summer blooms that brighten anyone’s mood."
        case .lavender:
            return "Lavender is a fragrant herb prized for its calming scent and delicate purple flowers. Used for centuries in aromatherapy, it represents serenity and grace."
        case .orchid:
            return "Orchids are exotic blooms representing luxury and refinement. With over 25,000 species, they're one of the largest families of flowering plants."
        }
    }

    var occasions: [String] {
        switch self {
        case .lily:
            return ["Weddings", "Mother’s Day", "Sympathy", "Graduations"]
        case .rose:
            return ["Valentine’s Day", "Anniversaries", "Romantic Gestures", "Weddings"]
        case .tulip:
            return ["New Beginnings", "Spring  Celebrations", "Apologies", "Declarations Of Love"]
        case .sunflower:
            return ["Birthdays", "Get Well Soon", "Summer Celebrations", "Friendship", "Thank You"]
        case .lavender:
            return ["Relaxation gifts", "Self Care", "Thank You" , "Housewarming"]
        case .orchid:
            return ["corporate events", "Luxury Occasions", "Housewarming", "Long-lasting gestures", "Congratulations"]
        }
    }

    var imageName: String {
        rawValue
    }
}
