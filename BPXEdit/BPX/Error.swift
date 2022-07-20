//
//  Error.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 5/24/22.
//

import Foundation

public enum BpxcError: Error {
    case invalidPath
    case fileOpen
    case fileCreate
}

extension BpxcError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidPath:
            return "Invalid path.";
        case .fileOpen:
            return "Failed to open file.";
        case .fileCreate:
            return "Failed to create file.";
        }
    }

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

public enum CoreError: Error {
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

extension CoreError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .checksum:
            return "BPX checksum error.";
        case .io:
            return "IO error.";
        case .badVersion:
            return "Unrecognized BPX version.";
        case .badSignature:
            return "Unrecognized file signature.";
        case .capacity:
            return "Section capacity exceeded.";
        case .inflate(let error):
            return "BPX inflate error: " + error.description + ".";
        case .deflate(let error):
            return "BPX deflate error: " + error.description + ".";
        case .open(let error):
            return "Failed to open section: " + error.description + ".";
        case .bpxc(let error):
            return "Low-level bpxc error: " + error.description + ".";
        }
    }

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

public enum InflateError: Error {
    case memory
    case unsupported
    case data
    case unknown
    case io
}

extension InflateError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .memory:
            return "Memory allocation failure.";
        case .unsupported:
            return "Unsupported operation.";
        case .data:
            return "Data error.";
        case .unknown:
            return "Unknown error.";
        case .io:
            return "IO error.";
        }
    }
    
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

public enum DeflateError: Error {
    case memory
    case unsupported
    case data
    case unknown
    case io
}

extension DeflateError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .memory:
            return "Memory allocation failure.";
        case .unsupported:
            return "Unsupported operation.";
        case .data:
            return "Data error.";
        case .unknown:
            return "Unknown error.";
        case .io:
            return "IO error.";
        }
    }

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

public enum OpenError: Error {
    case sectionInUse
    case sectionNotLoaded
}

extension OpenError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sectionInUse:
            return "The section is already in use.";
        case .sectionNotLoaded:
            return "The section is not loaded.";
        }
    }

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

public enum SdError: Error {
    case io
    case truncation
    case badTypeCode
    case utf8
    case capacityExceeded
    case notAnObject
}

extension SdError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .io:
            return "IO error";
        case .truncation:
            return "Data is truncated.";
        case .badTypeCode:
            return "Unrecognized type code.";
        case .utf8:
            return "Invalid UTF-8 string.";
        case .capacityExceeded:
            return "Capacity exceeded.";
        case .notAnObject:
            return "Value is not an object.";
        }
    }

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
