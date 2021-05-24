////
////  WaterView.swift
////  minum
////
////  Created by Devi Mandasari on 24/05/21.
////  Copyright © 2021 Ihwan ID. All rights reserved.
////
//
//import UIKit
//
//class WaterView: UIView {
//    
//    let dateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Date"
//        label.font = .systemFont(ofSize: 17)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let activateButton: UIButton = {
//        let button = UIButton(type: UIButton.ButtonType.custom)
//        button.titleLabel?.text = "Activites"
//        button.tintColor = .white
//        button.backgroundColor = .systemBlue
//        return button
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupView(){
//        self.backgroundColor = .white
//        
//        self.addSubview(self.dateLabel)
//        self.addSubview(self.activateButton)
//        
//        self.dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 20).isActive = true
//    }
//}
