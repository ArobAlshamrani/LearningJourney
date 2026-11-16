import SwiftUI

// MARK: - Glass Shapes

enum GlassShape { //يحدد الأشكال المتاحة للقلاس
    case card
    case circle
    case capsule

    var shape: AnyShape {
        switch self {
        case .card:
            return AnyShape(
                RoundedRectangle(cornerRadius: 24)
            )

        case .circle:
            return AnyShape(Circle())

        case .capsule:
            return AnyShape(Capsule())
        }
    }
}

// MARK: - Glass Modifier

struct GlassStyle: ViewModifier {//يجمع تنسيق القلاس في مكان واحد


    let shape: GlassShape
    let tint: Color?
    let isInteractive: Bool

    @ViewBuilder
    func body(content: Content) -> some View {

        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular
                        .tint(tint)
                        .interactive(isInteractive),
                    in: shape.shape
                )
        } else {
            content
                .background(
                    .ultraThinMaterial,
                    in: shape.shape
                )
        }
    }
}

// MARK: - View Extension

extension View {

    func appGlass(
        _ shape: GlassShape = .card,
        tint: Color? = nil,
        interactive: Bool = false
    ) -> some View {

        modifier(
            GlassStyle(
                shape: shape,
                tint: tint,
                isInteractive: interactive
            )
        )
    }
}
