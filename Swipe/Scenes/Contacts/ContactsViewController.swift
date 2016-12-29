//
//  ContactsViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 05/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var listButton: ViewModeButton!
  @IBOutlet weak var gridButton: ViewModeButton!
  @IBOutlet weak var slideButton: ViewModeButton!
  
  @IBOutlet weak var contactsView: UIView!
  var collectionView: UICollectionView?
  var slideView: CardCarouselView?
  
  @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBarHeight.constant = 0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    gridViewDidSelect(gridButton)
  }
  
  override func viewDidLayoutSubviews() {
    updateNavBarTitleImage(named: "text-logo-white")
    navBar.setBackgroundImage(UIImage(), for:.default)
    navBar.shadowImage = UIImage()
    navBar.backgroundColor = UIColor.clear
    
  }
  
  @IBAction func searchButtonDidTap(_ sender: Any) {
    searchBarHeight.constant = 32
  }
  
  @IBAction func hideSearchBarButtonDidTap(_ sender: Any) {
    searchBarHeight.constant = 0
  }
  
  func updateNavBarTitleImage(named name: String)
  {
    navBar.items?.first?.titleView = UIImageView(image: UIImage(named: name))
  }
  
  func showCollectionView() {
    slideView?.isHidden = true
    if collectionView == nil {
      let frame = CGRect(x: 40 , y: 0, width: contactsView.bounds.width - 80, height: contactsView.bounds.height)
      collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
      collectionView?.register(UINib(nibName: "ContactViewCell", bundle: nil), forCellWithReuseIdentifier: "grid cell")
      collectionView?.delegate = self
      collectionView?.dataSource = self
      collectionView?.backgroundColor = UIColor.clear
      collectionView?.showsVerticalScrollIndicator = false
      contactsView.addSubview(collectionView!)
    }
    collectionView?.isHidden = false
    collectionView?.reloadData()
  }
  
  func showSlideCarouselView() {
    collectionView?.isHidden = true
    if slideView == nil {
      slideView = CardCarouselView(frame: contactsView.bounds)
      contactsView.addSubview(slideView!)
    }
    slideView?.isHidden = false
    slideView?.reloadData()
  }
  
  @IBAction func listViewDidSelect(_ sender: ViewModeButton) {
    sender.layer.borderWidth = 2.0
    gridButton.layer.borderWidth = 0
    slideButton.layer.borderWidth = 0
  }
  
  @IBAction func gridViewDidSelect(_ sender: ViewModeButton) {
    sender.layer.borderWidth = 2.0
    listButton.layer.borderWidth = 0
    slideButton.layer.borderWidth = 0
    
    showCollectionView()
  }

  @IBAction func slideViewDidSelect(_ sender: ViewModeButton) {
    sender.layer.borderWidth = 2.0
    listButton.layer.borderWidth = 0
    gridButton.layer.borderWidth = 0
    
    showSlideCarouselView()
  }
  
}

extension ContactsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = UICollectionViewCell()
    if let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid cell", for: indexPath) as? ContactViewCell {
      
      cell = gridCell
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width / 2.2
    return CGSize(width: width, height: width * 4 / 3)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16.0
  }
}

extension ContactsViewController: NavigationViewDelegate {
  
  @IBAction func navigationBtnDidTap(_ sender: Any) {
    Common.createNavigationIn(viewController: self)
  }
  
  func present(withViewController viewController: UIViewController) {
    if !(viewController is ContactsViewController) {
      present(viewController, animated: false, completion: {
      
      })
    }
  }
}
