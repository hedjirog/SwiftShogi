/// A shogi board used to map `Square`s to `Piece`s.
public struct Board {
    private var pieceBitboards: [Piece: Bitboard]

    /// Creates a shogi board.
    public init() {
        let piecesAndBitboards = Piece.allCases.map { ($0, Bitboard(rawValue: 0)) }
        pieceBitboards = Dictionary(uniqueKeysWithValues: piecesAndBitboards)
    }
}

extension Board {
    
    /// Gets and sets a piece at `square`.
    public subscript(square: Square) -> Piece? {
        get {
            allPieces.first { exists($0, at: square) }
        }
        set(piece) {
            allPieces.forEach { remove($0, at: square) }
            if let piece = piece {
                insert(piece, at: square)
            }
        }
    }

    private var allPieces: [Piece] { Array(pieceBitboards.keys) }

    private func exists(_ piece: Piece, at square: Square) -> Bool {
        return pieceBitboards[piece]![square]
    }

    private mutating func insert(_ piece: Piece, at square: Square) {
        pieceBitboards[piece]![square] = true
    }

    private mutating func remove(_ piece: Piece, at square: Square) {
        pieceBitboards[piece]![square] = false
    }
}

extension Board {

    /// Returns `true` if a piece can attack from the source square to the destination square.
    public func isValidAttack(from sourceSquare: Square, to destinationSquare: Square) -> Bool {
        let bitboard = attacksBitboard(at: sourceSquare)
        return bitboard[destinationSquare]
    }

    private func attacksBitboard(at square: Square) -> Bitboard {
        guard let piece = self[square] else { return Bitboard(rawValue: 0) }
        return Bitboard.attacks(for: piece, at: square, stoppers: occupiedBitboard)
    }

    private var occupiedBitboard: Bitboard {
        pieceBitboards
            .values
            .reduce(Bitboard(rawValue: 0), |)
    }
}
