//
//  ViewController.swift
//  ImageLoadingProject
//
//  Created by Teacher on 16.11.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var rows: [Image] = [
        Image(title: "Guinea pig", urlString: "https://news.clas.ufl.edu/files/2020/06/AdobeStock_345118478-copy-1440x961-1.jpg"),
    Image(title: "Large satellite photo", urlString: "https://ichef.bbci.co.uk/news/976/cpsprodpb/F3BC/production/_113769326_1.jpg", largeImageUrlString: "https://www.dropbox.com/s/vylo8edr24nzrcz/Airbus_Pleiades_50cm_8bit_RGB_Yogyakarta.jpg?dl=1")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageCell else {
            fatalError("Could not dequeue cell")
        }

        cell.title = self.rows[indexPath.row].title
        cell.imageUrl = URL(string: "\(self.rows[indexPath.row].urlString)")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
                let detailsViewController = URLDetailsViewController()
                detailsViewController.pageUrl = URL(string: "https://news.clas.ufl.edu/uncovering-the-origin-of-the-domesticated-guinea-pig/")
                navigationController?.pushViewController(detailsViewController, animated: true)
            case 1:
                largeImageViewControlllerOpen(image: rows[indexPath.row])
            default:
                return
        }
    }
    
    private func largeImageViewControlllerOpen(image: Image) {
        guard let largeImageViewControlller
                = storyboard?.instantiateViewController(withIdentifier: "largeImage") as? LargeImageViewController
                else {
                    return
                }
        largeImageViewControlller.image = image
        largeImageViewControlller.loadViewIfNeeded()
        show(largeImageViewControlller, sender: nil)
    }
}

