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
    @State var value: Value?;

    private func parse(parser: ValueParser) {
        if let bytes = selection.bytes {
            let buf = ByteBuf(buffer: bytes);
            switch parser {
            case .u8:
                if let v = buf.readUInt8() {
                    value = .scalar(.u8(v));
                } else {
                    value = nil;
                }
                break;
            case .u16:
                if let v = buf.readUInt16() {
                    value = .scalar(.u16(v));
                } else {
                    value = nil;
                }
                break;
            case .u32:
                if let v = buf.readUInt32() {
                    value = .scalar(.u32(v));
                } else {
                    value = nil;
                }
                break;
            case .u64:
                if let v = buf.readUInt64() {
                    value = .scalar(.u64(v));
                } else {
                    value = nil;
                }
                break;
            case .i8:
                if let v = buf.readInt8() {
                    value = .scalar(.i8(v));
                } else {
                    value = nil;
                }
                break;
            case .i16:
                if let v = buf.readInt16() {
                    value = .scalar(.i16(v));
                } else {
                    value = nil;
                }
                break;
            case .i32:
                if let v = buf.readInt32() {
                    value = .scalar(.i32(v));
                } else {
                    value = nil;
                }
                break;
            case .i64:
                if let v = buf.readInt64() {
                    value = .scalar(.i64(v));
                } else {
                    value = nil;
                }
                break;
            case .f32:
                if let v = buf.readFloat32() {
                    value = .scalar(.f32(v));
                } else {
                    value = nil;
                }
                break;
            case .f64:
                if let v = buf.readFloat64() {
                    value = .scalar(.f64(v));
                } else {
                    value = nil;
                }
                break;
            }
        }
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
                            .onChange(of: parser, perform: parse)
                            .onAppear { parse(parser: parser) }
                            if let value = value {
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
                            .onChange(of: parser, perform: parse)
                            .onAppear { parse(parser: parser) }
                            Divider()
                            if let value = value {
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
