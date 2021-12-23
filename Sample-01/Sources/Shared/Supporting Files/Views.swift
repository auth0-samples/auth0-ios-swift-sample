import SwiftUI

struct PrimaryButton: ButtonStyle {
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

struct Hero: View {
    private let padding: CGFloat = 8
    private let tracking: CGFloat = -4

    var body: some View {
    #if os(iOS)
        Image("Auth0")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 28, alignment: .center)
            .padding(.top, self.padding)
        VStack(spacing: -24) {
            Text("Swift")
                .tracking(self.tracking)
                .foregroundStyle(
                    .linearGradient(
                      colors: [
                        Color("Orange"),
                        Color("Pink")
                      ],
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                    ))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Sample")
                .tracking(self.tracking)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("App")
                .tracking(self.tracking)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, self.padding * 4)
        .frame(maxHeight: .infinity)
        .font(.custom("SpaceGrotesk-Medium", size: 80))
    #else
        Text("Auth0 Swift Sample")
            .font(.title)
            .frame(height: 16)
    #endif
    }
}

struct ProfilePicture: View {
    @State var picture: String

    private let size: CGFloat = 96

    var body: some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            AsyncImage(url: URL(string: picture), content: { image in
                image.resizable()
            }, placeholder: {
                Color.clear
            })
            .frame(width: self.size, height: self.size)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.bottom, 24)
        } else {
            Text("Profile")
        }
    }
}

struct ProfileCell: View {
    @State var key: String
    @State var value: String

    private let size: CGFloat = 14

    var body: some View {
        HStack {
            Text(key)
                .font(.system(size: self.size, weight: .semibold))
            Spacer()
            Text(value)
                .font(.system(size: self.size, weight: .regular))
            #if os(iOS)
                .foregroundColor(Color("Grey"))
            #endif
        }
    #if os(iOS)
        .listRowBackground(Color.white)
    #endif
    }
}
