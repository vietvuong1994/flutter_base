//
//  DateTimePicker.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

typealias DateTimePickerDateResponse = (date: Date, day: Int, month: Int, year: Int)
typealias DateTimePickerTimeResponse = (date: Date, hour: Int, minute: Int, second: Int)
typealias DateTimePickerDateTimeResponse = (date: Date, day: Int, month: Int, year: Int, hour: Int, minute: Int, second: Int)

enum DateTimePickerType {
    case time, date, dateAndTime
    
    var mode: UIDatePicker.Mode {
        switch self {
        case .time: return .time
        case .date: return .date
        case .dateAndTime: return .dateAndTime
        }
    }
}

class DateTimePicker: BasePicker {
    
    // MARK: - Outlets
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    // MARK: - Constraints
    @IBOutlet var pickerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Constants
    private let calendar = Calendar(identifier: .gregorian)
    
    // MARK: - Variables
    private var safeAreaInsetsBottom: CGFloat {
        if #available(iOS 11.0, *) {
            if let safeAreaInsetBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                return safeAreaInsetBottom
            }
        }
        return 0
    }
    private var selectedDate: Date = Date()
    private var minDate: Date?
    private var maxDate: Date?
    private var type: DateTimePickerType = .date
    
    // MARK: - Closure
    var didScrollToTime: ((DateTimePickerTimeResponse?) -> Void)?
    var didScrollToDate: ((DateTimePickerDateResponse?) -> Void)?
    var didScrollToDateTime: ((DateTimePickerDateTimeResponse?) -> Void)?
    var didSelectTime: ((DateTimePickerTimeResponse?) -> Void)?
    var didSelectDate: ((DateTimePickerDateResponse?) -> Void)?
    var didSelectDateTime: ((DateTimePickerDateTimeResponse?) -> Void)?
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPickerView()
        setupGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showWithAnimation()
    }
    
    // MARK: - Setup
    private func setupView() {
        //UI
        view.backgroundColor = .clear
        view.isOpaque = false
        let bottomValue = -containerView.bounds.height - safeAreaInsetsBottom
        pickerViewBottomConstraint.constant = bottomValue
        dimView.alpha = 0
        
        // Config animation
        configWhenShow = { [weak self] in
            self?.pickerViewBottomConstraint.constant = 0
            self?.dimView.alpha = 0.5
        }
        
        configWhenHide = { [weak self] in
            guard let sSelf = self else { return }
            let bottomValue = -sSelf.containerView.bounds.height - sSelf.safeAreaInsetsBottom
            sSelf.pickerViewBottomConstraint.constant = bottomValue
            sSelf.dimView.alpha = 0
        }
    }
    
    private func setupPickerView() {
        pickerView.calendar = calendar
        pickerView.datePickerMode = type.mode
        pickerView.setDate(selectedDate, animated: true)
        pickerView.minimumDate = minDate
        pickerView.maximumDate = maxDate
        if type == .time {
            // Fixed to display hour format from 0 to 23
            pickerView.locale = Locale(identifier: "en_GB")
        }
        pickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesture:)))
        dimView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        cancelPickerView()
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        let day = calendar.component(.day, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)
        let hour = calendar.component(.hour, from: selectedDate)
        let minute = calendar.component(.minute, from: selectedDate)
        let second = calendar.component(.second, from: selectedDate)
        hideWithAnimation(completion: { [weak self] in
            guard let sSelf = self else { return }
            sSelf.dismiss(animated: false, completion: { [weak sSelf] in
                if let type = sSelf?.type {
                    switch type {
                    case .time:
                        sSelf?.didSelectTime?((date: sSelf?.selectedDate ?? Date(), hour: hour, minute: minute, second: second))
                    case .date:
                        sSelf?.didSelectDate?((date: sSelf?.selectedDate ?? Date(), day: day, month: month, year: year))
                    case .dateAndTime:
                        sSelf?.didSelectDateTime?((date: sSelf?.selectedDate ?? Date(), day: day, month: month, year: year, hour: hour, minute: minute, second: second))
                    }
                }
            })
        })
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date
        let components = sender.date.components()
        guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return }
        switch type {
        case .time:
            didScrollToTime?((date: sender.date, hour: hour, minute: minute, second: second))
        case .date:
            didScrollToDate?((date: sender.date, day: day, month: month, year: year))
        case .dateAndTime:
            didScrollToDateTime?((date: sender.date, day: day, month: month, year: year, hour: hour, minute: minute, second: second))
        }
    }
    
    @objc func tapGestureAction(gesture: UITapGestureRecognizer) {
        cancelPickerView()
    }
    
    private func cancelPickerView() {
        hideWithAnimation(completion: { [weak self] in
            guard let sSelf = self else { return }
            sSelf.dismiss(animated: false, completion: { [weak sSelf] in
                sSelf?.didSelectTime?(nil)
                sSelf?.didSelectDate?(nil)
                sSelf?.didSelectDateTime?(nil)
            })
        })
    }
    
    // MARK: - Builder
    @discardableResult
    func set(type: DateTimePickerType) -> DateTimePicker {
        self.type = type
        return self
    }
    
    @discardableResult
    func set(day: Int, month: Int, year: Int, minDate: Date? = nil, maxDate: Date? = nil) -> DateTimePicker {
        self.selectedDate = Date(year: year, month: month, day: day)
        self.minDate = minDate
        self.maxDate = maxDate
        self.type = .date
        return self
    }
    
    @discardableResult
    func set(date: Date, minDate: Date? = nil, maxDate: Date? = nil) -> DateTimePicker {
        self.selectedDate = date
        self.minDate = minDate
        self.maxDate = maxDate
        return self
    }
    
    @discardableResult
    func set(hour: Int, minute: Int, minTime: Date? = nil, maxTime: Date? = nil) -> DateTimePicker {
        self.selectedDate = Date(hour: hour, minute: minute, second: 0)
        self.minDate = minTime
        self.maxDate = maxTime
        self.type = .time
        return self
    }
}

