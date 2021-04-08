//
//  ViewController.swift
//  Own CollectionView Transition Animations
//
//  Created by Ilya Cherkasov on 08.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView?
    var customTransition = CustomTransitionAnimation()
    var cellCenter = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 180, height: 180)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        collectionView?.backgroundColor = view.backgroundColor
        collectionView?.layer.borderWidth = 2
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Custom Transition

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customTransition.customTransitionMode = .dismiss
        return customTransition
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as! CollectionViewCell
        let cellImage = Image(image: UIImage(named: "cat")!, containerSize: cell.bounds.size)
        cell.image = cellImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let vc = SecondViewController()
        let cell = collectionView.cellForItem(at: indexPath)! as! CollectionViewCell
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        cellCenter = view.coordinateSpace.convert(cell.center, from: collectionView.coordinateSpace)
        vc.view.backgroundColor = view.backgroundColor
        customTransition.customTransitionMode = .present
        customTransition.startingPoint = CGPoint(x: view.bounds.midX, y: 1.5 * view.bounds.maxY)
        customTransition.imageStartingPoint = cellCenter
        customTransition.image = cell.image
        customTransition.executeWhileAnimationTo = {
            cell.imageView.isHidden = true
        }
        customTransition.executeWhileAnimationFrom = {
            cell.imageView.isHidden = false
        }
        self.present(vc, animated: true) {
            print("New custom VC")
        }
    }
}
