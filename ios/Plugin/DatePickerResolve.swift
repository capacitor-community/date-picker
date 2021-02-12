//
//  DatePickerResolve.swift
//  CapacitorCommunityDatePicker
//
//  Created by Daniel Rosa on 12/02/21.
//

import Foundation

public class DatePickerResolve {
    init(done: @escaping (_ sender: UIButton) -> Void, cancel: @escaping (_ sender: UIButton) -> Void) {
        resolveDone = done
        resolveCancel = cancel
    }
    @objc var resolveDone: (_ sender: UIButton) -> Void
    @objc var resolveCancel: (_ sender: UIButton) -> Void
}
