import Foundation

/// Represents a movie, tv show or person.
public enum Media: Identifiable, Equatable, Hashable {

    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id

        case .tvShow(let tvShow):
            return tvShow.id

        case .person(let person):
            return person.id
        }
    }

    /// Movie.
    case movie(TMDBMovie)
    /// TV show.
    case tvShow(TMDBTVShow)
    /// Person.
    case person(Person)

}

extension Media: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvShow = "tv"
        case person
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try TMDBMovie(from: decoder))

        case .tvShow:
            self = .tvShow(try TMDBTVShow(from: decoder))

        case .person:
            self = .person(try Person(from: decoder))
        }
    }

}
