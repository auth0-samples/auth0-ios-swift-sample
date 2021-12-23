import SwiftUI

struct ProfileView: View {
    @Binding var profile: Profile

    var body: some View {
        List {
            Section(header: ProfilePicture(picture: profile.picture)) {
                ProfileCell(key: "ID", value: profile.id)
                ProfileCell(key: "Name", value: profile.name)
                ProfileCell(key: "Email", value: profile.email)
                ProfileCell(key: "Email verified?", value: profile.emailVerified)
                ProfileCell(key: "Updated at", value: profile.updatedAt)
            }
        }
    }
}
