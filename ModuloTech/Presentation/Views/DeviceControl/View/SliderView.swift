//
//  SliderView.swift
//  ModuloTech
//
//  Created by Mohamed Amine HAJ MOHAMED on 03/12/2021.
//

import UIKit
import RxSwift

private let kSliderHeight: CGFloat = 250
private let kSliderWidth: CGFloat = 10
private let kThumbWidth: CGFloat = 24
private let kThumbBorderWidth: CGFloat = 6

class SliderView: UIView {
    
    // MARK: - View
    
    private var viewSlider: UIView!
    private var viewSliderThumb: UIView!
    private var viewSliderFilled: UIView!
    private var labelMaxValue: UILabel!
    private var labelMinValue: UILabel!
    
    private var constraintViewSliderThumbBottom: NSLayoutConstraint!
    
    private var panGestureViewSliderThumb: UIPanGestureRecognizer!
    
    // MARK: - Properties
    
    let valueSubject = BehaviorSubject<Float>(value: 0)
    var value: Float { (try? valueSubject.value()) ?? 0 }
    
    private var maxValue: Float = 100
    private var minValue: Float = 0
    private var diffBetweenMaxAndMindValues: Float = 100
    private var step: Float = 1
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        loadView()
        updateMinAndMaxLabels()
        observe()
    }
    
    // MARK: - Configure
    
    func configureWith(value: Float, minValue: Float, maxValue: Float, step: Float) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.diffBetweenMaxAndMindValues = maxValue - minValue
        self.step = step
        updateMinAndMaxLabels()
        updateValue(value)
    }
    
    // MARK: - Observe
    
    private func observe() {
        valueSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.updateViewThumb()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update
    
    private func updateMinAndMaxLabels() {
        var minValueStringFormat = "%.1f"
        if minValue.truncatingRemainder(dividingBy: 1) == 0 {
            minValueStringFormat = "%.0f"
        }
        labelMinValue.text = String(format: minValueStringFormat, minValue)
        
        var maxValueStringFormat = "%.1f"
        if maxValue.truncatingRemainder(dividingBy: 1) == 0 {
            maxValueStringFormat = "%.0f"
        }
        labelMaxValue.text = String(format: maxValueStringFormat, maxValue)
    }
    
    private func updateViewThumb() {
        let percentageOfValue = (value - minValue) / diffBetweenMaxAndMindValues
        constraintViewSliderThumbBottom.constant = -(kSliderHeight * CGFloat(percentageOfValue) - kThumbWidth / 2)
    }
    
    private func updateValue(_ value: Float) {
        var value = value
        
        if value > maxValue {
            value = maxValue
        } else if value < minValue {
            value = minValue
        }
        
        value = round(value / step) * step
        
        valueSubject.onNext(value)
    }
}

// MARK: - View
private extension SliderView {
    
    func loadView() {
        setupViewSliderThumb()
        setupViewSliderFilled()
        setupViewSlider()
        setupLabelMaxValue()
        setupLabelMinValue()
        setupMainView()
    }
    
    func setupViewSliderThumb() {
        viewSliderThumb = UIView()
        viewSliderThumb.translatesAutoresizingMaskIntoConstraints = false
        viewSliderThumb.layer.cornerRadius = kThumbWidth / 2
        viewSliderThumb.layer.borderWidth = kThumbBorderWidth
        viewSliderThumb.layer.borderColor = UIColor(named: "DarkGray")?.cgColor
        viewSliderThumb.backgroundColor = UIColor(named: "White")
        
        panGestureViewSliderThumb = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        viewSliderThumb.addGestureRecognizer(panGestureViewSliderThumb)
        
        NSLayoutConstraint.activate([
            viewSliderThumb.heightAnchor.constraint(equalToConstant: kThumbWidth),
            viewSliderThumb.widthAnchor.constraint(equalToConstant: kThumbWidth),
        ])
    }
    
    func setupViewSliderFilled() {
        viewSliderFilled = UIView()
        viewSliderFilled.translatesAutoresizingMaskIntoConstraints = false
        viewSliderFilled.backgroundColor = UIColor(named: "Brown")
        viewSliderFilled.layer.cornerRadius = kSliderWidth / 2
        
        NSLayoutConstraint.activate([
            viewSliderFilled.widthAnchor.constraint(equalToConstant: kSliderWidth),
        ])
    }
    
    func setupViewSlider() {
        viewSlider = UIView()
        viewSlider.translatesAutoresizingMaskIntoConstraints = false
        viewSlider.backgroundColor = UIColor(named: "LightGray")
        viewSlider.layer.cornerRadius = kSliderWidth / 2
        
        viewSlider.addSubview(viewSliderFilled)
        viewSlider.addSubview(viewSliderThumb)
        
        constraintViewSliderThumbBottom = viewSliderThumb.bottomAnchor.constraint(equalTo: viewSlider.bottomAnchor)
        
        NSLayoutConstraint.activate([
            viewSlider.heightAnchor.constraint(equalToConstant: kSliderHeight),
            viewSlider.widthAnchor.constraint(equalToConstant: kSliderWidth),
            constraintViewSliderThumbBottom,
            viewSliderThumb.centerXAnchor.constraint(equalTo: viewSlider.centerXAnchor),
            viewSliderFilled.topAnchor.constraint(equalTo: viewSliderThumb.centerYAnchor),
            viewSliderFilled.bottomAnchor.constraint(equalTo: viewSlider.bottomAnchor),
            viewSliderFilled.centerXAnchor.constraint(equalTo: viewSlider.centerXAnchor),
        ])
    }
    
    func setupLabelMaxValue() {
        labelMaxValue = UILabel()
        labelMaxValue.translatesAutoresizingMaskIntoConstraints = false
        labelMaxValue.textAlignment = .center
    }
    
    func setupLabelMinValue() {
        labelMinValue = UILabel()
        labelMinValue.translatesAutoresizingMaskIntoConstraints = false
        labelMinValue.textAlignment = .center
    }
    
    func setupMainView() {
        addSubview(labelMaxValue)
        addSubview(viewSlider)
        addSubview(labelMinValue)
        
        NSLayoutConstraint.activate([
            labelMaxValue.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            labelMaxValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelMaxValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            viewSlider.topAnchor.constraint(equalTo: labelMaxValue.bottomAnchor, constant: 15),
            viewSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewSlider.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            viewSlider.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            labelMinValue.topAnchor.constraint(equalTo: viewSlider.bottomAnchor, constant: 15),
            labelMinValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelMinValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            labelMinValue.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
        ])
    }
}

// MARK: - Gestures
private extension SliderView {
    
    @objc func handleGesture(_ gesture: UIGestureRecognizer) {
        switch gesture {
        case panGestureViewSliderThumb:
            let distanceFromViewSliderBottom = kSliderHeight - panGestureViewSliderThumb.location(in: viewSlider).y
            let percentageOfDistance = distanceFromViewSliderBottom / kSliderHeight
            let value = diffBetweenMaxAndMindValues * Float(percentageOfDistance) + minValue
            updateValue(value)
            
        default:
            break
        }
    }
}
