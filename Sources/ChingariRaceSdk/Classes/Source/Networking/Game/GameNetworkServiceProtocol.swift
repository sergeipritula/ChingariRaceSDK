//
//  GameNetworkServiceProtocol.swift
//  
//
//  Created by Sergey Pritula on 13.03.2025.
//

import Foundation
import RxSwift

protocol GameNetworkServiceProtocol {
    func configuration(requestData: EmptyRequestData) -> Single<ResponseBaseModel<SdkConfigurationDTO>>
    func token(requestData: GetTokenRequest) -> RxSwift.Single<ResponseBaseModel<GetTokenResponse>>
}
