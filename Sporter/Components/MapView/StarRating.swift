//
//  StarRating.swift
//  Sporter
//
//  Created by Khang on 12/09/2022.
//

import SwiftUI

struct StarRating: View {
    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int

    init(rating: Float) {
        self.rating = rating
        fullCount = Int(rating)
        emptyCount = Int(5 - rating)
        halfFullCount = (Float(fullCount + emptyCount) < 5) ? 1 : 0
    }

    var body: some View {
        HStack {
            ForEach(0..<fullCount, id: \.self) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount, id: \.self) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount, id: \.self) { _ in
                self.emptyStar
            }
        }
    }

    private var fullStar: some View {
        Image(systemName: "star.fill")
            .foregroundColor(Color.accentColor)
    }

    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill")
            .foregroundColor(Color.accentColor)
    }

    private var emptyStar: some View {
        Image(systemName: "star")
            .foregroundColor(Color.accentColor)
    }
}
