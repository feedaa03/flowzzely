import Foundation

struct FlowerPuzzlePiece: Identifiable, Equatable {
    let id: String
    let imageName: String
    let correctIndex: Int

    static func == (lhs: FlowerPuzzlePiece, rhs: FlowerPuzzlePiece) -> Bool {
        lhs.id == rhs.id
    }
}

extension FlowerType {
    var title: String {
        rawValue.capitalized
    }

    var pieces: [FlowerPuzzlePiece] {
        makePieces()
    }

    // positions:
    // 0 = يسار فوق
    // 1 = يمين فوق
    // 2 = يسار تحت
    // 3 = يمين تحت

    fileprivate func makePieces() -> [FlowerPuzzlePiece] {
        // كل tuple: (رقم الصورة, الـ position الصحيح)
        let order: [(Int, Int)] = {
            switch self {
            case .lily:
                // ٣ يسار فوق، ٤ يمين فوق، ١ يسار تحت، ٢ يمين تحت
                return [(3,0), (4,1), (1,2), (2,3)]

            case .orchid:
                // ١ يسار فوق، ٢ يمين فوق، ٤ يسار تحت، ٣ يمين تحت
                return [(1,0), (2,1), (4,2), (3,3)]

            case .rose:
                // ٤ يسار فوق، ٣ يمين فوق، ٢ يسار تحت، ١ يمين تحت
                return [(4,0), (3,1), (2,2), (1,3)]

            case .sunflower:
                // ١ يسار فوق، ٤ يمين فوق، ٣ يسار تحت، ٢ يمين تحت
                return [(1,0), (4,1), (3,2), (2,3)]

            case .tulip:
                // ٢ يسار فوق، ١ يمين فوق، ٤ يسار تحت، ٣ يمين تحت
                return [(2,0), (1,1), (4,2), (3,3)]

            case .lavender:
                // ٤ يسار فوق، ١ يمين فوق، ٢ يسار تحت، ٣ يمين تحت
                return [(4,0), (1,1), (2,2), (3,3)]
            }
        }()

        return order.map { (number, correctIndex) in
            FlowerPuzzlePiece(
                id: "\(rawValue)\(number)",
                imageName: "\(rawValue)\(number)",
                correctIndex: correctIndex
            )
        }
    }
}
