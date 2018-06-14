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
    
    var maxNumber: Int!
    var delegate: TYNumberPickerDelegate!
    
    var bgGradients: [UIColor] = [.white, .white]
    var tintColor = UIColor.black
    var heading = ""
    
    var bgView: UIView!
    
    var pickerView: UIView!
    var isPickerOpen = false
    var pickerViewBottomConstraint: NSLayoutConstraint?
    
    var cancelBtn: UIButton!
    var cancelBtnLeftConstraint: NSLayoutConstraint?
    
    var doneBtn: UIButton!
    var doneBtnRightConstraint: NSLayoutConstraint?
    
    var titleLbl: UILabel!
    var titleLblTopConstraint: NSLayoutConstraint?
    
    var numberLbl: UILabel!
    
    lazy var arrowImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = tintColor
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    // this is for iphone x
    var bottomPadding: CGFloat = 0.0
    
    var selectedNumber = 0
    
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
        
        setupMainScrollView()
        
        pickerView.addSubview(arrowImageView)
        arrowImageView.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor, constant: 32 - bottomPadding/2).isActive = true
    }
    
    var mainScrollView: UIScrollView!
    
    let lineWidth: CGFloat = 1
    let lineHeight: CGFloat = 50
    let middleLineHeight: CGFloat = 80
    let gap: CGFloat = 10
    var contentSize: CGFloat = 0
    
    var offSet: UIEdgeInsets!
    
    private func setupMainScrollView() {
        self.view.layoutSubviews()
        
        offSet = UIEdgeInsets(top: 0, left: self.pickerView.frame.width / 2, bottom: 0, right: 0)
        
        mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 125, width: self.pickerView.frame.width, height: 80))
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        mainScrollView.contentInset = offSet
        for i in 0 ... maxNumber {
            let XPOS: CGFloat = gap * CGFloat(i)
            
            let lineView = UIView(frame: CGRect(x: XPOS, y: 15, width: lineWidth, height: lineHeight))
            lineView.backgroundColor = tintColor.withAlphaComponent(0.5)
            mainScrollView.addSubview(lineView)
            
            if i % 5 == 0 {
                lineView.frame = CGRect(x: XPOS, y: 0, width: lineWidth, height: middleLineHeight)
                lineView.backgroundColor = tintColor.withAlphaComponent(0.7)
            }
            
            contentSize = XPOS
        }
        
        mainScrollView.contentSize = CGSize(width: contentSize + offSet.left, height: mainScrollView.frame.height)
        self.pickerView.addSubview(mainScrollView)
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
    
    func animateButtons(_ duration: Double) {
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

extension TYNumberPicker: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = targetContentOffset.pointee
        var pos = targetOffset.x  + offSet.left
        
        pos = round(pos/10)
        pos = pos * 10
        pos = pos - offSet.left
        
        targetContentOffset.pointee = CGPoint(x: pos, y: 0.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let xPos = (scrollView.contentOffset.x + offSet.left)
        
        let approxNum = xPos/10
        
        let num = round(approxNum)
        
        if num < 0 || Int(num) > maxNumber { return }
        
        self.selectedNumber = Int(num)
        self.numberLbl.text = "\(Int(num))"
    }
}
