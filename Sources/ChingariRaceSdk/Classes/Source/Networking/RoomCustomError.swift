//
//  RoomCustomError.swift
//  chingari
//
//  Created by Тетяна Нєізвєстна on 19.08.2021.
//  Copyright © 2021 Nikola Milic. All rights reserved.
//

import Foundation

enum ErrorType: String, Codable {
    case incompitiableRoom = "INCOMPITITABLE_ROOM" // code - 491
    case forceUpdate = "FORCE_UPDATE"// code 490
    case globalBan = "GLOBAL_BAN" // code 495
    case bannedFromRoom = "BANNED_FROM_ROOM"
    case roomLocked = "ROOM_LOCKED"
    case userAlreadySeated = "USER_ALREADY_SEATED"
    case notEnoughPermission = "NOT_ENOUGH_PERMISSION"
    case userIsNotInRoom = "USER_IS_NOT_IN_ROOM"
    case roomIsNotActive = "ROOM_IS_NOT_ACTIVE"
    case notSafeContent = "NOT_SAFE_CONTENT"
    case validation = "VALIDATION" // all 4** errors for which type is not specified
    case levelRestriction = "LEVEL_RESTRICTION"
    case basic = "BASIC" // all other possible errors
    case themeForOwnerOnly
    case noActivePlans
    
    case userOffline = "USER_OFFLINE"
    case endCurrentCall = "END_CURRENT_CALL"
    case receiverBusy = "RECEIVER_BUSY"
    case wrongReceiver = "WRONG_RECEIVER"
    case wrongProfileState = "WRONG_PROFILE_STATE"
    case insufficientBalance = "INSUFFICIENT_BALANCE"
    case faceDetection = "FACE_DETECTION"
    case paidRandomLevel = "PAID_RANDOM_LEVEL_ERROR"
    case creatorPermissionDisabled = "CREATOR_PERMISSION_DISABLED"
    case creatorAudioPermissionDisabled = "AUDIO_PERMISSION_DISABLED"
    case vCardLevel = "V_CARD_LEVEL_ERROR"
    case socketConnectionError = "SOCKET_CONNECTION_ERROR"
    case pandaHolderRestriction = "PANDA_HOLDER_RESTRICTION"
    case invalidBody = "INVALID_BODY"
    case timeout = "TIMEOUT"
    case noUserForRandomCall = "NO_USERS_FOR_RANDOM_CALL"
    case callStarted = "CALL_STARTED"
    case general
    case audioCallNotSupported = "AUDIO_CALL_NOT_SUPPORTED"
    case commentMaxPerMinReached = "COMMENT_MAX_PER_MIN_REACHED"
    case commentLevelError = "COMMENT_LEVEL_ERROR"
    case COMMENT_PERMISSION_GIFTS = "COMMENT_PERMISSION_GIFTS"
    case COMMENT_PERMISSION_FOLLOWING = "COMMENT_PERMISSION_FOLLOWING"
    case COMMENT_PERMISSION_NOBODY = "COMMENT_PERMISSION_NOBODY"
    case COMMENT_PERMISSION_GIFTS_AND_FOLLOWING = "COMMENT_PERMISSION_GIFTS_AND_FOLLOWING"
}

struct RoomSocketErrorModel: Decodable {
    let error: RoomCustomError
}

struct RoomCustomError: Error, Decodable {
    let statusCode: Int
    let type: ErrorType
    let message: String?
    
    var localizedDescription: String {
        return ""
    }
    
    var analyticsName: String {
        switch type {
        case .userOffline:
            return "Call failed because the user is offline."
        case .endCurrentCall:
            return "Call initiation failed because the user is already on a call."
        case .receiverBusy:
            return "Call failed because the receiver is currently busy."
        case .wrongReceiver:
            return "Call failed because the receiver is unable to receive a call at the moment."
        case .wrongProfileState:
            return "Call failed because the receiver is unable to receive a call at the moment."
        case .insufficientBalance:
            return "Call initiation failed due to insufficient diamonds."
        case .faceDetection:
            return "FaceDetection"
        case .paidRandomLevel:
            return "Call initiation failed because the creator cannot receive free calls."
        case .creatorPermissionDisabled:
            return "Call initiation failed because the creator has disabled private calls."
        case .vCardLevel:
            return "Call initiation failed because the creator cannot receive free calls."
        case .validation:
            return "The call initiation failed due to validation errors."
        case .globalBan:
            return "The call initiation failed due to a global ban."
        case .basic:
            return "The call initiation failed due to basic errors."
        case .notSafeContent:
            return "The call initiation failed due to unsafe content."
        case .invalidBody:
            return "The call initiation failed due to an invalid body."
        case .socketConnectionError:
            return "The call failed due to a socket connection error."
        case .timeout:
            return "The call failed due to a timeout."
        case .noUserForRandomCall:
            return "No users available for random call."
        case .callStarted:
            return "Call already started."
        case .levelRestriction:
            return "Level restiction"
        case .general:
            return "An unknown error occurred during the call process."
        default:
            return "An unknown error occurred during the call process."
        }
    }
}

extension RoomCustomError {
    static let generalError = RoomCustomError.init(statusCode: -1, type: .general, message: "")
    static let socketDisconnected = RoomCustomError.init(statusCode: -1, type: .general, message: "")
    static let purchaseFailed = RoomCustomError.init(statusCode: -1, type: .general, message: "")
    static let roomsFeedErrorLoggedIn = RoomCustomError.init(statusCode: -1, type: .general, message: "")
    static let themeForOwnerOnlyError = RoomCustomError.init(statusCode: -1, type: .themeForOwnerOnly, message: "")
    static let noActivePlansError = RoomCustomError.init(statusCode: -1, type: .noActivePlans, message: "")
    static let generalGameError = RoomCustomError.init(statusCode: -1, type: .general, message: "")
}
