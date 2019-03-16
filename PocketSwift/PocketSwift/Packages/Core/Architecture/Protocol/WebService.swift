//
//  WebService.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RxSwift

protocol WebService {
    func load<Response>(endpoint: Endpoint<Response>) -> Observable<Response>
}
