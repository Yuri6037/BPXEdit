//
//  HexViewer.swift
//  BPXViewer
//
//  Created by Yuri Edwrad on 6/23/22.
//

import SwiftUI

enum ValueParser {
    case u8
    case u16
    case u32
    case u64
    case i8
    case i16
    case i32
    case i64
    case f32
    case f64
}

struct HexViewer: View {
    @Binding var data: [uint8];
    @State var selection: Selection = Selection();
    @State var parser: ValueParser = .u8;

    private func parse(parser: ValueParser) -> Value? {
        if let bytes = selection.bytes {
            let buf = ByteBuf(buffer: bytes);
            switch parser {
            case .u8:
                guard let v = buf.readUInt8() else { return nil }
                return .scalar(.u8(v));
            case .u16:
                guard let v = buf.readUInt16() else { return nil }
                return .scalar(.u16(v));
            case .u32:
                guard let v = buf.readUInt32() else { return nil }
                return .scalar(.u32(v));
            case .u64:
                guard let v = buf.readUInt64() else { return nil }
                return .scalar(.u64(v));
            case .i8:
                guard let v = buf.readInt8() else { return nil }
                return .scalar(.i8(v));
            case .i16:
                guard let v = buf.readInt16() else { return nil }
                return .scalar(.i16(v));
            case .i32:
                guard let v = buf.readInt32() else { return nil }
                return .scalar(.i32(v));
            case .i64:
                guard let v = buf.readInt64() else { return nil }
                return .scalar(.i64(v));
            case .f32:
                guard let v = buf.readFloat32() else { return nil }
                return .scalar(.f32(v));
            case .f64:
                guard let v = buf.readFloat64() else { return nil }
                return .scalar(.f64(v));
            }
        }
        return nil;
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HexViewWrapper(data: $data, selection: $selection)
                Divider()
                VStack {
                    HStack {
                        Text("Current selection: ").bold()
                        Text("[\(selection.start); \(selection.end))")
                        Text("(length: \(selection.length))")
                    }
                    if geo.size.width < 512 {
                        VStack {
                            Picker("Interpreter", selection: $parser) {
                                Text("8 bits unsigned").tag(ValueParser.u8)
                                Text("16 bits unsigned").tag(ValueParser.u16)
                                Text("32 bits unsigned").tag(ValueParser.u32)
                                Text("64 bits unsigned").tag(ValueParser.u64)
                                Text("8 bits signed").tag(ValueParser.i8)
                                Text("16 bits signed").tag(ValueParser.i16)
                                Text("32 bits signed").tag(ValueParser.i32)
                                Text("64 bits signed").tag(ValueParser.i64)
                                Text("32 bits float").tag(ValueParser.f32)
                                Text("64 bits float").tag(ValueParser.f64)
                            }
                            if let value = parse(parser: parser) {
                                ValueView(value: value, container: .constant(nil))
                            } else {
                                Text("Could not parse value")
                            }
                        }
                        .fixedSize()
                    } else {
                        HStack {
                            Picker("Interpreter", selection: $parser) {
                                Text("8 bits unsigned").tag(ValueParser.u8)
                                Text("16 bits unsigned").tag(ValueParser.u16)
                                Text("32 bits unsigned").tag(ValueParser.u32)
                                Text("64 bits unsigned").tag(ValueParser.u64)
                                Text("8 bits signed").tag(ValueParser.i8)
                                Text("16 bits signed").tag(ValueParser.i16)
                                Text("32 bits signed").tag(ValueParser.i32)
                                Text("64 bits signed").tag(ValueParser.i64)
                                Text("32 bits float").tag(ValueParser.f32)
                                Text("64 bits float").tag(ValueParser.f64)
                            }
                            .padding(.trailing)
                            Divider()
                            if let value = parse(parser: parser) {
                                ValueView(value: value, container: .constant(nil))
                                    .padding(.leading)
                            } else {
                                Text("Could not parse value")
                                    .padding(.leading)
                            }
                        }
                        .fixedSize()
                    }
                }
            }
        }
    }
}

struct HexViewer_Previews: PreviewProvider {
    static var previews: some View {
        HexViewer(data: .constant([]))
    }
}
