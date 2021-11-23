//
//  DefaultRecordDetailUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import Foundation

final class DefaultRecordDetailUseCase: RecordDetailUseCase {
    var runningResult: RunningResult
    
    let mock = TeamRunningResult(
        runningSetting: RunningSetting(
            sessionId: "",
            mode: .team,
            targetDistance: 5000,
            hostNickname: "Jungwon",
            mateNickname: "YeoHoon",
            dateTime: Date()
        ),
        userElapsedDistance: 5123,
        userElapsedTime: 351,
        calorie: 131.3,
        points: [
            Point(latitude: 37.46701422823457, longitude: 127.0999055016327),
            Point(latitude: 37.46701386730851, longitude: 127.09990707320856)
        ],
        emojis: [
            "Minji": Emoji.clap,
            "YeoHoon": Emoji.fire,
            "Yujin": Emoji.clap,
            "Messi": Emoji.burningHeart,
            "Ronaldo": Emoji.flower,
            "Son": Emoji.running,
            "Kante": Emoji.tear,
            "Kane": Emoji.okay,
            "Park": Emoji.lovely
        ],
        isCanceled: false,
        mateElapsedDistance: 4823.53,
        mateElapsedTime: 299
    ) as RunningResult
    
    init() {
        self.runningResult = self.mock
    }
    
//    init(with runningResult: RunningResult) {
//        self.runningResult = runningResult
//    }
}
