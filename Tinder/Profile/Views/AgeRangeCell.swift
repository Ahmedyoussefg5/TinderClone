//
//  AgeRangeCell.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-23.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
  
  class AgeRangeLabel: UILabel {
    override var intrinsicContentSize: CGSize {
      return CGSize.init(width: 80, height: 0)
    }
  }
  
  let minAgeSlider: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 18
    slider.maximumValue = 100
    slider.value = 18
    return slider
  }()
  
  let maxAgeSlider: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 18
    slider.maximumValue = 100
    slider.value = 18
    return slider
  }()
  
  let minAgeLabel: AgeRangeLabel = {
    let label = AgeRangeLabel()
    label.text = "Min: 18"
    return label
  }()

  let maxAgeLabel: AgeRangeLabel = {
    let label = AgeRangeLabel()
    label.text = "Max: 18"
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let minStackView = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
    minStackView.axis = .horizontal
    let maxStackView = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
    maxStackView.axis = .horizontal
    
    let overallStackView = UIStackView(arrangedSubviews: [minStackView, maxStackView])
    overallStackView.axis = .vertical
    overallStackView.spacing = 16
    addSubview(overallStackView)
    overallStackView.anchor(
      top: topAnchor,
      leading: leadingAnchor,
      bottom: bottomAnchor,
      trailing: trailingAnchor,
      padding: .init(top: 16, left: 16, bottom: 16, right: 16)
    )
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
