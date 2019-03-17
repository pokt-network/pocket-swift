//
//  Repository.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RxSwift

protocol Repository {
    var disposeBag: DisposeBag {get set}
    func request<Response>(with endpoint: Endpoint<Response>, andNotify observable: LiveData<Response>)
}

extension Repository {
    var WebService: WebServiceImpl {
        return WebServiceImpl()
    }
    
    func request<Response>(with endpoint: Endpoint<Response>, andNotify observable: LiveData<Response>) {
        WebService.load(endpoint: endpoint)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                observable.value = response
            }, onError: { error in
                observable.error = error
            })
            .disposed(by: self.disposeBag)
    }
}

