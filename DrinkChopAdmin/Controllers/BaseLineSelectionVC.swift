////
//  BaseLineSelectionVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class BaseLineSelectionVC: UIViewController {

    @IBOutlet var baselineSelectionSegmentCtrl: UISegmentedControl!
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    @IBOutlet var peopleDoorLbl: UILabel!
    
    var baselineSelectionControllers:[UIViewController] = []
    
    fileprivate var pageVC: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setupControllers()
        setupPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
    }
    
    func setupControllers() {
        let baselineController = storyboard?.instantiateViewController(withIdentifier: "BaselineVC") as! BaselineVC
        baselineController.parentController = self
        let selectionController = storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        selectionController.parentController = self
        
        baselineSelectionControllers = [baselineController, selectionController]
    }
    
    func setupPageController() {
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageVC.delegate = self
        
        pageVC.setViewControllers([getViewController(index: 0)!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParentViewController: self)
        
        pageVC.view.anchor(self.baselineSelectionSegmentCtrl.bottomAnchor, left: self.view.leftAnchor, bottom: self.peopleDoorLbl.topAnchor, right: self.view.rightAnchor, topConstant: 8, leftConstant: 20, bottomConstant: 8, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    func getViewController(index:Int) -> UIViewController?  {
        if index == NSNotFound || index < 0 || index >= 2 {
            return nil
        }
        return baselineSelectionControllers[index]
    }
    
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
    }
    
    @IBAction func baselineSelectionChangeAction(_ sender: Any) {
        self.pageVC.setViewControllers([getViewController(index: self.baselineSelectionSegmentCtrl.selectedSegmentIndex)!], direction: .forward, animated: true, completion: nil)
    }
    
    deinit {
        print("BaseLineSelectionVC deinit")
    }
}


extension BaseLineSelectionVC: UIPageViewControllerDataSource,UIPageViewControllerDelegate  {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var Index = (viewController).view.tag
        Index = Index - 1
        return getViewController(index: Index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var Index = (viewController).view.tag
        Index = Index + 1
        return getViewController(index: Index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == true {
            
        }
    }
}

extension BaseLineSelectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleDoorCellID, for: indexPath) as! PeopleDoorCVC
        if indexPath.row%2 == 0 {
            cell.infoLbl.textColor = appTintColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: collectionView.frame.width/3, aspectRatio: 86/44, padding: 20)
    }
}
