//
//  SplashScreenView.swift
//  ExpenseManagement
//
//  Created by infra on 12/07/24.
//

import SwiftUI
import Lottie

struct SplashScreenView: View {
    // The Lottie animation is controlled by this SwiftUI state
    @State var playbackMode = LottiePlaybackMode.playing(.fromProgress(0, toProgress: 0.95, loopMode: .playOnce))
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            LottieView(animation: .named("PFUAnimation"))
              .playbackMode(playbackMode)
              .animationDidFinish { _ in
                playbackMode = .paused
              }
        }
    }
}


#Preview {
    SplashScreenView()
}
