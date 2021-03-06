import Foundation

struct JokeBundleCategory: Codable {
    let label: String
    let icon: String
}

struct JokeBundleJoke: Codable {
    let id: Int
    let cat: String
    let txt: String
}

struct JokeBundle: Codable {
    let categories: [JokeBundleCategory]
    let jokes: [JokeBundleJoke]
}

struct JokeCategory {
    let category: String
    let icon: String
    var jokes: [(id: Int, text: String, favorite: Bool)]
}

import UIKit

extension String {
    func textToImage() -> UIImage {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 28)
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label,
                                NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }
}


class JokeViewModelController {
    private enum JokeSection: Int, CaseIterable {
        case Favorites = 0
        case All = 1
        case ByCategory = 2
    }

    private var jokeBundle: JokeBundle?
    private var categories: [(label: String, icon: String)] = []
    private var disabledCategories: [String] = []
    private var enabledCategories: [(label: String, icon: String)] {
        get {
            categories.filter {
                cat in disabledCategories.firstIndex(of: cat.label) == nil
            }
        }
    }
    private var favorites: [Int] = []
    private var jokes: [(id: Int, text: String, cat: String)] = []
    private static let favoriteDefaultsKey = "favorites"
    private static let disabledCatDefaultsKey = "disabledCategories"
    private var searchResults: [(id: Int, excerpt: NSAttributedString, fullText: String, favorite: Bool)] = []

    var invalidator: [(() -> ())] = []

    var categoryCount: [Int] {
        get { return [1, 1, enabledCategories.count] }
    }

    let sections = JokeSection.allCases.count

    private func isFavorite(id: Int) -> Bool {
        favorites.firstIndex(of: id) != nil
    }

    func setFavorite(id: Int, favorited: Bool) {
        if let oldIndex = favorites.firstIndex(of: id) {
            favorites.remove(at:oldIndex)
        }
        if favorited {
            favorites.append(id)
        }
        UserDefaults.standard.removeObject(forKey: JokeViewModelController.favoriteDefaultsKey)
        UserDefaults.standard.set(favorites, forKey: JokeViewModelController.favoriteDefaultsKey)
    }

    private func augmentWithFavorite(input: (id: Int, text: String, cat: String)) -> (id: Int, text: String, favorite: Bool) {
        (input.id, input.text, isFavorite(id: input.id))
    }

    func getEnabledCategories() -> [(category: String, index: Int, enabled: Bool)] {
        self.categories.enumerated().map { (index, element) in
            (category: element.label,
             index: index,
             enabled: disabledCategories.firstIndex(of: element.label) == nil)
        }
    }

    func setSearch(_ searchTerm: String?) {
        guard let term = searchTerm else {
            searchResults = []
            return
        }

        searchResults = getCategoryFor(indexPath: IndexPath(row: 0, section: JokeSection.All.rawValue)).jokes.compactMap { (j) -> (id: Int, excerpt: NSAttributedString, fullText: String, favorite: Bool)? in
            if let range = j.text.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) {
                var s = range.lowerBound
                var e = range.upperBound
                let ellideStart = j.text.formIndex(&s, offsetBy: -20, limitedBy: j.text.startIndex)
                let ellideEnd = j.text.formIndex(&e, offsetBy: 20, limitedBy: j.text.endIndex)

                let excerpt = ((ellideStart ? "???" : "") + String(j.text[s..<e]) + (ellideEnd ? "???" : ""))
                    .replacingOccurrences(of: "\n", with: " ")
                let excerptAS = NSMutableAttributedString(string: excerpt, attributes:nil)
                let matchRange = (excerptAS.string as NSString).range(of: term, options: [.caseInsensitive, .diacriticInsensitive])
                excerptAS.addAttribute(.backgroundColor, value: UIColor.systemFill, range: matchRange)

                return (j.id, excerptAS, j.text, j.favorite)
            }
            else {
                return nil
            }
        }

    }

    func getSearchResults() -> [(id: Int, excerpt: NSAttributedString, fullText: String, favorite: Bool)] {
        searchResults
    }

    func setCategoryEnablement(index: Int, enabled: Bool) {
        if let oldIndex = disabledCategories.firstIndex(of: categories[index].label) {
            disabledCategories.remove(at:oldIndex)
        }
        if !enabled {
            disabledCategories.append(categories[index].label)
        }
        UserDefaults.standard.removeObject(forKey: JokeViewModelController.disabledCatDefaultsKey)
        UserDefaults.standard.set(disabledCategories, forKey: JokeViewModelController.disabledCatDefaultsKey)
        invalidator.forEach { $0() }
    }

    func getCategoryFor(indexPath: IndexPath) -> JokeCategory {
        switch JokeSection(rawValue: indexPath.section)  {
        case .Favorites:
            return JokeCategory(category: "Suosikit", icon: "??????",
                                jokes: favorites.compactMap({ favid in jokes.first(where: { j in j.id == favid }) })
                                    .map(augmentWithFavorite))
        case .All:
            return
                JokeCategory(category: "Kaikki", icon: "???", jokes: jokes.filter {
                    (j) -> Bool in
                    disabledCategories.firstIndex(of: j.cat) == nil
                }
                .map(augmentWithFavorite))
        case .ByCategory:
            let category = enabledCategories[indexPath.row]
            return JokeCategory(category: category.label, icon: category.icon, jokes:jokes.filter({ $0.cat == category.label }).map(augmentWithFavorite))
        default:
            fatalError("unknown enum ????" )
        }
    }

    func load() {
        guard let path = Bundle.main.url(forResource: "vitsit", withExtension: "json") else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: path)
                self.jokeBundle = try JSONDecoder().decode(JokeBundle.self, from: data)
                let iconsByCategory = Dictionary(grouping: self.jokeBundle!.categories, by: { $0.label })
                let jokesByCategory = Dictionary(grouping: self.jokeBundle!.jokes, by: { $0.cat })
                self.categories = jokesByCategory.keys.map({ (cat) -> (label: String, icon: String) in
                    (cat, iconsByCategory[cat]?.first?.icon ?? "?")
                }).sorted(by: { $0.label < $1.label })
                self.jokes = (self.jokeBundle?.jokes.map({ ($0.id, $0.txt, $0.cat) }) ?? []).shuffled()
                self.favorites = (UserDefaults.standard.array(forKey: JokeViewModelController.favoriteDefaultsKey) ?? []) as? [Int] ?? []
                self.disabledCategories = (UserDefaults.standard.array(forKey: JokeViewModelController.disabledCatDefaultsKey)) as? [String] ?? []
            }
            catch {
                print("error:\(error)")
            }
        }
    }
}

