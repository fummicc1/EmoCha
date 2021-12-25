import SwiftUI

struct SWButton: View {

    @Environment(\.colorScheme) var colorSchema

    let text: String
    let action: () -> Void
    var foregroundColor: Color {
        colorSchema == .dark ? Color.black : Color.white
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(text).bold()
        }
        .foregroundColor(foregroundColor)
        .padding()
        .background(Color.accentColor)
        .cornerRadius(12)
    }
}

struct SWButton_Previews: PreviewProvider {
    static var previews: some View {
        SWButton(text: "テスト", action: {})
    }
}
