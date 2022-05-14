import SwiftUI

struct ProfileView: View {
    @Binding var user: User

    var body: some View {
        List {
            Section(header: ProfileHeader(picture: user.picture)) {
                ProfileCell(key: "ID", value: user.id)
                ProfileCell(key: "Name", value: user.name)
                ProfileCell(key: "Email", value: user.email)
                ProfileCell(key: "Email verified?", value: user.emailVerified)
                ProfileCell(key: "Updated at", value: user.updatedAt)
            }
        }
    }
}
