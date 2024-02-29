//
//  ViewController.swift
//  Samespace
//
//  Created by Nitesh Malhotra on 26/02/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var SongsListTableView: UITableView!
    let viewModel = TracksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTracks()
        setupUI()
    }
    
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.black
        self.SongsListTableView.backgroundColor = UIColor.black
    }
    func fetchTracks() {
        viewModel.fetchTracks { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching tracks: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.SongsListTableView.reloadData()
                }
            }
        }
    }
}

    extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.tracks.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let trackCell = cell as! TrackTableViewCell
            trackCell.trackNameLabel.textColor = UIColor.white
            trackCell.artistNameLabel.textColor = UIColor.white
        }

        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrackTableViewCell
            let track = viewModel.tracks[indexPath.row]
            cell.backgroundColor = UIColor.clear
            cell.trackNameLabel.textColor = UIColor.white
            cell.artistNameLabel.textColor = UIColor.white
            cell.trackNameLabel.text = track.name
            cell.artistNameLabel.text = track.artist
            if let coverID = track.cover {
                let imageURL = Constants.CoverImage.imageURL + coverID
                if let url = URL(string: imageURL) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.trackImage.image = image
                            }
                        }
                    }.resume()
                }
            } else {
                cell.trackImage.image = UIImage(named: "placeholder_image")
            }
            
            return cell
        }
    }

    extension ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedTrack = viewModel.tracks[indexPath.row]
                    
                    guard let secondViewController = storyboard?.instantiateViewController(withIdentifier: "SongDetailViewController") as? SongDetailViewController else {
                        return
                    }

                    secondViewController.track = selectedTrack
                    navigationController?.pushViewController(secondViewController, animated: true)
                    tableView.deselectRow(at: indexPath, animated: true)
        }
    }

 


