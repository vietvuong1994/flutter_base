//
//  PickerViewer.swift
//  iOS Structure MVC
//
//  Created by kien on 10/9/18.
//  Copyright © 2018 kien. All rights reserved.
//

import UIKit

class PickerViewer {
    static func showTextPicker(list: [String],
                               defaultIndex: Int = 0,
                               completion: ((TextPickerResponse?) -> Void)?) {
        TextPicker.present(animated: false, prepare: { picker in
            picker.set(list: list, defaultIndex: defaultIndex)
            picker.didSelectText = { response in
                completion?(response)
            }
        })
    }

    static func showTimePicker(hour: Int, minute: Int, minTime: Date? = nil, maxTime: Date? = nil, completion: ((DateTimePickerTimeResponse?) -> Void)?) {
        DateTimePicker.present(animated: false, prepare: { picker in
            picker.set(type: .time)
            picker.set(hour: hour, minute: minute, minTime: minTime, maxTime: maxTime)
            picker.didSelectTime = { response in
                completion?(response)
            }
        })
    }
    
    static func showDatePicker(date: Date, minDate: Date? = nil, maxDate: Date? = nil, completion: ((DateTimePickerDateResponse?) -> Void)?) {
        DateTimePicker.present(animated: false, prepare: { picker in
            picker.set(type: .date)
            picker.set(date: date, minDate: minDate, maxDate: maxDate)
            picker.didSelectDate = { response in
                completion?(response)
            }
        })
    }
    
    static func showDateTimePicker(date: Date, minDate: Date? = nil, maxDate: Date? = nil, completion: ((DateTimePickerDateTimeResponse?) -> Void)?) {
        DateTimePicker.present(animated: false, prepare: { picker in
            picker.set(type: .dateAndTime)
            picker.set(date: date, minDate: minDate, maxDate: maxDate)
            picker.didSelectDateTime = { response in
                completion?(response)
            }
        })
    }
}
