//
//  TopMoviesViewController.swift
//  flix
//
//  Created by Olga Andreeva on 6/23/17.
//  Copyright © 2017 Olga Andreeva. All rights reserved.
//

import UIKit

class TopMoviesViewController: UIViewController, UICollectionViewDataSource {
    var movies: [[String : Any]] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchTopMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopMovieCell", for: indexPath) as! TopMovieCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterPath = URL(string: baseURLString + posterPathString)!
            cell.topMovieImageView.af_setImage(withURL: posterPath)
        }
        return cell
    }
    
    func fetchTopMovies() {
        let apiKey = "2d751347eb5c652750198b7d5d33c8b4"
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&api_key=\(apiKey)")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("response: \(responseDictionary)")
                self.movies = (responseDictionary["results"] as? [NSDictionary])! as! [[String : Any]]
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
