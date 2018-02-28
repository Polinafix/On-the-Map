//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Polina Fiksson on 25/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
