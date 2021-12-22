import Foundation
import SwiftUI

struct ProfileView: View {
    @Binding var profile: Profile

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: profile.picture))
            Text(profile.id)
            Text(profile.email)
            Text(profile.updatedAt)
        }
    }
}
