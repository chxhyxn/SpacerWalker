//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct HermesIntroducingView: View {
    @Binding var isPresented: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }

                VStack(spacing: 16) {
                    HStack {
                        HStack(spacing: 4) {
                            Image("hermes")
                                .resizable()
                                .frame(
                                    width: 52,
                                    height: 42
                                )

                            Text("Hermes's Message")
                                .font(.oneMobile20)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.hermes)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Spacer()

                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    ScrollView {
                        Image("hermesImage")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 16)

                        Text("Hi! I'm HERMES, the little space weather fairy!\nI live on the Gateway, a space station orbiting the Moon.\n\nMy job is to watch how the Sun’s energy moves and changes space — the solar wind, magnetic fields, and radiation all dancing together.\n\nBy studying them, I help humans predict space weather, so astronauts, satellites, and GPS on Earth stay safe.\n\nTogether with my friends ERSA and IDA, I float around the Moon, measuring space particles and waves —helping everyone live safely under the Sun’s powerful breath.")
                            .font(.oneMobile24)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(8)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 28)
                .frame(
                    width: min(geometry.size.width * 0.85, 800),
                    height: min(geometry.size.height * 0.73, 600)
                )
                .background(Color(red: 0.9, green: 0.95, blue: 0.93))
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
    }
}

#Preview {
    HermesIntroducingView(isPresented: Binding.constant(true))
}
