//
//  TYNumberPicker.swift
//
//  Created by Yash Thaker on 10/06/18.
//  Copyright © 2018 Yash Thaker. All rights reserved.
//

import UIKit

protocol TYNumberPickerDelegate {
    func selectedNumber(_ number: Int)
}

class TYNumberPicker: UIViewController {
    
    var delegate: TYNumberPickerDelegate!
    var maxNumber: Int!
    var bgGradients: [UIColor] = [.white, .white]
    var tintColor = UIColor.black
    var heading = ""
    
    private var bgView, pickerView: UIView!
    private var cancelBtn, doneBtn: UIButton!
    private var titleLbl, numberLbl: UILabel!
    
    private var pickerViewBottomConstraint: NSLayoutConstraint?
    private var cancelBtnLeftConstraint: NSLayoutConstraint?
    private var doneBtnRightConstraint: NSLayoutConstraint?
    private var titleLblTopConstraint: NSLayoutConstraint?
    
    private var isPickerOpen = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 1, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var layout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private var cellWidthIncludingSpacing: CGFloat {
        return layout.itemSize.width + layout.minimumLineSpacing
    }
    
    private let cellId = "cellId"

    private lazy var arrowImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = tintColor
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    // this is for iphone x
    private var bottomPadding: CGFloat = 0.0
    
    private var selectedNumber: Int = 0 {
        didSet {
            self.numberLbl.text = "\(selectedNumber)"
        }
    }
    
    var defaultSelectedNumber: Int = 0
    
    init(_ delegate: TYNumberPickerDelegate, maxNumber: Int) {
        self.delegate = delegate
        self.maxNumber = maxNumber
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.animatePickerView()
            self.scrollToDefaultNumber(self.defaultSelectedNumber)
        }
    }
    
    private func initializeViews() {
        bgView = createView()
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.65)
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
        
        pickerView = createView()
        pickerView.layer.masksToBounds = true
        
        cancelBtn = createBtn(#imageLiteral(resourceName: "cancel"))
        doneBtn = createBtn(#imageLiteral(resourceName: "done"))
        doneBtn.tag = 99
        
        titleLbl = createLabel(heading, fontSize: 18)
        numberLbl = createLabel("0", fontSize: 30)
        
        collectionView.register(TYNumberPickerLineCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func addViews() {
        self.view.addSubview(bgView)
        bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        if let window = UIApplication.shared.keyWindow {
            bottomPadding = window.safeAreaInsets.bottom
        }
        
        self.view.addSubview(pickerView)
        pickerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        pickerViewBottomConstraint = pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 250 + bottomPadding)
        pickerViewBottomConstraint?.isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 250 + bottomPadding).isActive = true
        
        pickerView.applyGradient(colors: bgGradients, type: .cross)
        pickerView.roundCorners([.topLeft, .topRight], radius: 10)
        
        pickerView.addSubview(cancelBtn)
        cancelBtnLeftConstraint = cancelBtn.leftAnchor.constraint(equalTo: pickerView.leftAnchor, constant: -54)
        cancelBtnLeftConstraint?.isActive = true
        cancelBtn.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        pickerView.addSubview(doneBtn)
        doneBtnRightConstraint = doneBtn.rightAnchor.constraint(equalTo: pickerView.rightAnchor, constant: 54)
        doneBtnRightConstraint?.isActive = true
        doneBtn.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        doneBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        pickerView.addSubview(titleLbl)
        titleLbl.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        titleLblTopConstraint = titleLbl.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: -86)
        titleLblTopConstraint?.isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        pickerView.addSubview(numberLbl)
        numberLbl.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        numberLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor).isActive = true
        
        pickerView.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: pickerView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: pickerView.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: pickerView.topAnchor, constant: 125).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: pickerView.bounds.width / 2, bottom: 0, right: pickerView.bounds.width / 2)
        
        pickerView.addSubview(arrowImageView)
        arrowImageView.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor, constant: 32 - bottomPadding/2).isActive = true
    }
    
    private func scrollToDefaultNumber(_ number: Int) {
        if number <= 0 { return }
        if number > maxNumber { return }
        let offset = CGPoint(x: CGFloat(number) * cellWidthIncludingSpacing - collectionView.contentInset.left, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: true)
    }
    
    @objc private func btnTapped(_ sender: UIButton) {
        self.animatePickerView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.dismiss(animated: true, completion: {
                if sender.tag == 99 {
                    self.delegate?.selectedNumber(self.selectedNumber)
                }
            })
        }
    }
    
    @objc private func dismissController() {
        self.animatePickerView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func animatePickerView() {
        pickerViewBottomConstraint?.constant = isPickerOpen ? 250 + bottomPadding + 10 : 0
        let animationDuration = isPickerOpen ? 0.4 : 0.5
        
        isPickerOpen = !isPickerOpen
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
         
            self.view.layoutIfNeeded()
        })
        
        animateButtons(animationDuration)
    }
    
    private func animateButtons(_ duration: Double) {
        cancelBtnLeftConstraint?.constant = isPickerOpen ? 8 : -54
        doneBtnRightConstraint?.constant = isPickerOpen ? -8 : 54
        titleLblTopConstraint?.constant = isPickerOpen ? 0 : -86
        
        UIView.animate(withDuration: duration, delay: duration/2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createLabel(_ text: String, fontSize: CGFloat) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: fontSize)
        lbl.text = text
        lbl.textColor = tintColor
        return lbl
    }
    
    private func createBtn(_ image: UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(image, for: .normal)
        btn.tintColor = tintColor
        btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        return btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TYNumberPicker: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxNumber + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            as! TYNumberPickerLineCell
        cell.calcLineViewHeight(indexPath.row, bgColor: tintColor)
        return cell
    }
}

extension TYNumberPicker: UIScrollViewDelegate {
    
    // this is for exactly stop on line
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        selectedNumber = roundedIndex <= 0 ? 0 : Int(roundedIndex)
    }
}

