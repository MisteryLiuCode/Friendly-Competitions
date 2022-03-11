import SwiftUI

struct ExploreCompetitionDetails: View {

    @Binding var competition: Competition

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                if competition.owner == Bundle.main.id {
                    AppIcon(size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                }
                Text(competition.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                Spacer()
                Text("\(competition.participants.count)")
                    .font(.footnote)
                Image(systemName: "person.3.sequence.fill")
                    .font(.footnote)
            }
            let start = competition.start.formatted(date: .abbreviated, time: .omitted)
            let end = competition.end.formatted(date: .abbreviated, time: .omitted)
            let text = "\(start) - \(end)"
            Label(text, systemImage: "calendar")
                .font(.footnote)
        }
    }
}
