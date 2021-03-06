////
//  TemplateVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class TemplateVC: UIViewController {
    
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    @IBOutlet var weekdaysBtn: UIButton!
    @IBOutlet var saturdaysBtn: UIButton!
    @IBOutlet var thursdayBtn: UIButton!
    @IBOutlet var currentTemplateBtn: UIButton!
    
    var btnCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        addPanGesture(btn: self.saturdaysBtn)
        addPanGesture(btn: self.thursdayBtn)
        addPanGesture(btn: self.weekdaysBtn)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    func addPanGesture(btn: UIButton) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(dragTemplateBtnGesture(_:)))
        btn.addGestureRecognizer(gesture)
    }
    
    @objc func dragTemplateBtnGesture(_ gesture: UIPanGestureRecognizer) {
        guard let btn = gesture.view as? UIButton else {return}
        let translation = gesture.translation(in: self.view)
        
        switch gesture.state {
        case .began:
            btnCenter = btn.center
        case .changed:
            btn.center = CGPoint(x: btn.center.x + translation.x, y: btn.center.y + translation.y)
        case .ended:
            if btn.bounds.intersects(self.currentTemplateBtn.bounds) {
                self.currentTemplateBtn.setTitle(btn.currentTitle, for: .normal)
            }
            btn.center = btnCenter
        default:
            btn.center = btnCenter
        }
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
    }
    
    @IBAction func overwriteAction(_ sender: Any) {
        
    }
    
    @IBAction func createNewAction(_ sender: Any) {
        
    }
    
    deinit {
        print("TemplateVC deinit")
    }
}

extension TemplateVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
