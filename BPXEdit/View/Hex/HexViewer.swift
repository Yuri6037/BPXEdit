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

fileprivate struct ParserPicker: View {
    @Binding var selection: ValueParser;

    var body: some View {
        Picker("Interpreter", selection: $selection) {
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
    }
}

class Dummy: Reader {
    var size: Int {
        0
    }

    func seek(pos: UInt64) {
    }

    func read(size: Int) -> [uint8] {
        []
    }
}

struct HexViewer<T: Reader>: View {
    @Binding var data: [uint8];
    @Binding var reader: T?;
    @Binding var refresh: Int;
    @State var selection: Selection = Selection();
    @State var parser: ValueParser = .u8;
    @State var page = 0;
    let selectionChanged: ((Selection) -> Void)?;

    init(reader: Binding<T?> = .constant(nil), refresh: Binding<Int> = .constant(0), selectionChanged: ((Selection) -> Void)? = nil) {
        self.init(data: .constant([]), reader: reader, refresh: refresh, selectionChanged: selectionChanged);
    }

    init(data: Binding<[uint8]>, reader: Binding<T?> = .constant(nil), refresh: Binding<Int> = .constant(0), selectionChanged: ((Selection) -> Void)? = nil) {
        _data = data;
        _reader = reader;
        _refresh = refresh;
        self.selectionChanged = selectionChanged;
    }

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
                if let reader = reader {
                    HStack {
                        Button(action: { page -= 1 }) {
                            Image(systemName: "arrowtriangle.left.fill")
                        }
                        .disabled(page == 0)
                        Text("\(page) / \(reader.size / PAGE_SIZE)")
                        Button(action: { page += 1 }) {
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                        .disabled(page == reader.size / PAGE_SIZE)
                    }
                }
                HexViewWrapper(
                    data: $data,
                    reader: $reader,
                    selection: $selection,
                    page: $page,
                    refresh: $refresh
                )
                Divider()
                if selection.length == 0 {
                    Text("Selection is out of range.").bold()
                } else {
                    VStack {
                        HStack {
                            Text("Current selection: ").bold()
                            Text("[\(selection.start); \(selection.end))")
                            Text("(length: \(selection.length))")
                        }
                        if geo.size.width < 512 {
                            VStack {
                                ParserPicker(selection: $parser)
                                if let value = parse(parser: parser) {
                                    ValueView(value: value, container: .constant(nil))
                                } else {
                                    Text("Could not parse value")
                                }
                            }
                            .fixedSize()
                        } else {
                            HStack {
                                ParserPicker(selection: $parser).padding(.trailing)
                                Divider()
                                if let value = parse(parser: parser) {
                                    ValueView(value: value, container: .constant(nil)).padding(.leading)
                                } else {
                                    Text("Could not parse value").padding(.leading)
                                }
                            }
                            .fixedSize()
                        }
                    }
                }
            }
            .onChange(of: selection) { newSelection in
                if let selectionChanged = selectionChanged {
                    selectionChanged(newSelection);
                }
            }
        }
    }
}

extension HexViewer where T == Dummy {
    init(data: Binding<[uint8]>, selectionChanged: ((Selection) -> Void)? = nil) {
        self.init(data: data, reader: .constant(nil), selectionChanged: selectionChanged);
    }
}

struct HexViewer_Previews: PreviewProvider {
    static var previews: some View {
        HexViewer(data: .constant([]))
    }
}
