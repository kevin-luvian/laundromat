import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Sizes {
  static const double mm = 72.0 / 25.4;
  static const double cm = 72.0 / 2.54;
}

class TextColor {
  static const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
  static const PdfColor white = PdfColor.fromInt(0xffffffff);
  static const PdfColor black = PdfColor.fromInt(0xff000000);
}

class TextWidget {
  static Text big(String text) =>
      Text(text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));

  static Text normal(String text, {TextAlign? align}) {
    return Text(text, textAlign: align, style: const TextStyle(fontSize: 23));
  }

  static Text sub(String text, {TextAlign? align}) =>
      Text(text, textAlign: align, style: const TextStyle(fontSize: 20));
}

class Breaker extends StatelessWidget {
  @override
  build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 15),
        Divider(color: TextColor.black, thickness: 3),
        SizedBox(height: 15),
      ],
    );
  }
}
