//
//  Error.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/24/22.
//

import Foundation

enum BpxcError: Error {
    case invalidPath
    case fileOpen
    case fileCreate
}

extension BpxcError {
    public static func fromc(code: bpx_error_t) -> BpxcError? {
        switch code {
        case UInt32(BPX_ERR_INVALID_PATH):
            return .invalidPath;
        case UInt32(BPX_ERR_FILE_OPEN):
            return .fileOpen;
        case UInt32(BPX_ERR_FILE_CREATE):
            return .fileCreate;
        default:
            return nil;
        }
    }

}

enum CoreError: Error {
    case checksum
    case io
    case badVersion
    case badSignature
    case capacity
    case inflate(error: InflateError)
    case deflate(error: DeflateError)
    case open(error: OpenError)
    case bpxc(error: BpxcError)
}

extension CoreError {
    public static func fromc(code: bpx_error_t) -> CoreError? {
        switch code {
        case UInt32(BPX_ERR_CORE_CHKSUM):
            return .checksum;
        case UInt32(BPX_ERR_CORE_IO):
            return .io;
        case UInt32(BPX_ERR_CORE_BAD_VERSION):
            return .badVersion;
        case UInt32(BPX_ERR_CORE_BAD_SIGNATURE):
            return .badSignature;
        case UInt32(BPX_ERR_CORE_CAPACITY):
            return .capacity;
        default:
            if let err = BpxcError.fromc(code: code) {
                return .bpxc(error: err);
            }
            if let err = InflateError.fromc(code: code) {
                return .inflate(error: err);
            }
            if let err = DeflateError.fromc(code: code) {
                return .deflate(error: err);
            }
            if let err = OpenError.fromc(code: code) {
                return .open(error: err);
            }
            return nil;
        }
    }
}

enum InflateError: Error {
    case memory
    case unsupported
    case data
    case unknown
    case io
}

extension InflateError {
    public static func fromc(code: bpx_error_t) -> InflateError? {
        switch code {
        case UInt32(BPX_ERR_INFLATE_MEMOR):
            return .memory;
        case UInt32(BPX_ERR_INFLATE_UNSUPPORTE):
            return .unsupported;
        case UInt32(BPX_ERR_INFLATE_DAT):
            return .data;
        case UInt32(BPX_ERR_INFLATE_UNKNOWN):
            return .unknown;
        case UInt32(BPX_ERR_INFLATE_IO):
            return .io;
        default:
            return nil;
        }
    }
}

enum DeflateError: Error {
    case memory
    case unsupported
    case data
    case unknown
    case io
}

extension DeflateError {
    public static func fromc(code: bpx_error_t) -> DeflateError? {
        switch code {
        case UInt32(BPX_ERR_DEFLATE_MEMORY):
            return .memory;
        case UInt32(BPX_ERR_DEFLATE_UNSUPPORTED):
            return .unsupported;
        case UInt32(BPX_ERR_DEFLATE_DATA):
            return .data;
        case UInt32(BPX_ERR_DEFLATE_UNKNOWN):
            return .unknown;
        case UInt32(BPX_ERR_DEFLATE_IO):
            return .io;
        default:
            return nil;
        }
    }
}

enum OpenError: Error {
    case sectionInUse
    case sectionNotLoaded
}

extension OpenError {
    public static func fromc(code: bpx_error_t) -> OpenError? {
        switch code {
        case UInt32(BPX_ERR_OPEN_SECTION_IN_USE):
            return .sectionInUse;
        case UInt32(BPX_ERR_OPEN_SECTION_NOT_LOADED):
            return .sectionNotLoaded;
        default:
            return nil;
        }
    }
}

enum SdError: Error {
    case io
    case truncation
    case badTypeCode
    case utf8
    case capacityExceeded
    case notAnObject
}

extension SdError {
    public static func fromc(code: bpx_error_t) -> SdError? {
        switch code {
        case UInt32(BPX_ERR_SD_IO):
            return .io;
        case UInt32(BPX_ERR_SD_TRUNCATION):
            return .truncation;
        case UInt32(BPX_ERR_SD_BAD_TYPE_CODE):
            return .badTypeCode;
        case UInt32(BPX_ERR_SD_UTF8):
            return .utf8;
        case UInt32(BPX_ERR_SD_CAPACITY_EXCEEDED):
            return .capacityExceeded;
        case UInt32(BPX_ERR_SD_NOT_AN_OBJECT):
            return .notAnObject;
        default:
            return nil;
        }
    }
}
