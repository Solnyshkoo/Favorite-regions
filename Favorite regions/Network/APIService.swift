import UIKit

enum ObtainPostsResult {
    case success(info: [RegionInfo])
    case failure
}

class APIService {
    func loadMovies(_ closure: @escaping (ObtainPostsResult) -> Void) {
        guard let url = URL(string: "https://vmeste.wildberries.ru/api/guide-service/v1/getBrands")
        else {
            return assertionFailure("some problems with url")
        }
        let session = URLSession.shared.dataTask(with: url) { data, _, _ in
            var result: ObtainPostsResult
            guard
                let data = data,
                let post = try? JSONSerialization.jsonObject(with: data, options: .json5Allowed) as? [String: Any],
                    
                let results = post["brands"] as? [[String: Any]]
            else {
                result = .failure
                closure(result)
                return
            }

            let info: [RegionInfo] = results.map { item in
                let title = item["title"] as? String
                let viewCounts = item["viewsCount"] as? Int
                let thumbUrls = item["thumbUrls"] as? [String]
                let id = item["brandID"] as? String
                
                let overview = RegionOverview(title: title ?? "", isLike: false)
                let details = RegionDetails(viewCounts: viewCounts ?? 0, views: thumbUrls ?? [])
                return RegionInfo(id: id ?? "", overview: overview, details: details)
            }
            result = .success(info: info)
            let group = DispatchGroup()
            for movie in info {
                group.enter()
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let self = self else { return }
                    self.loadPosters(movie: movie, completion: { _ in
                        group.leave()
                    })
                }
            }
            group.notify(queue: .main) {
                result = .success(info: info)
                closure(result)
            }
        }
        session.resume()
    }
    
    private func loadPosters(movie: RegionInfo, completion: @escaping (UIImage?) -> Void) {
        guard
            let url = URL(string: movie.details.views.first ?? "")
        else {
            return completion(nil)
        }
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return completion(nil)
            }
            movie.overview.view = image
            completion(image)
        }
        session.resume()
    }
    
    func loadPicture(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return completion(nil)
            }
            
            completion(image)
        }
        session.resume()
    }
}
