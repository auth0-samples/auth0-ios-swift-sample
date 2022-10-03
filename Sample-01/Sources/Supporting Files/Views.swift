import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    private let padding: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .padding(.init(top: self.padding,
                           leading: self.padding * 6,
                           bottom: self.padding,
                           trailing: self.padding * 6))
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
