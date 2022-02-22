import 'package:laundry/print_handlers/setting/styles.dart';
import 'package:pdf/widgets.dart';

class SenyumPageWrapper extends StatelessWidget {
  SenyumPageWrapper({List<Widget>? children}) : children = children ?? [];

  final List<Widget> children;

  @override
  Widget build(context) {
    return Expanded(
      child: Container(
        color: TextColor.white,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 70),
            child: Column(
              children: [
                senyumHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 80),
                  child: Column(children: children),
                ),
                senyumFooter(),
                SizedBox(height: 100),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget senyumHeader() {
    return Center(
      child: Column(children: [
        TextWidget.big("LAUNDRY SENYUM"),
        SizedBox(height: 30),
        TextWidget.normal("Jl. Perhubungan I No 03"),
        TextWidget.normal("Rawamangun Jati. 15228."),
        SizedBox(height: 20),
      ]),
    );
  }

  Widget senyumFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          TextWidget.normal(
              "Terima kasih sudah berbelanja pada jasa laundry senyum.",
              align: TextAlign.center),
          SizedBox(height: 40),
          TextWidget.normal(
              "Kami tidak bertanggung jawab untuk barang yang ditinggalkan lebih dari 30 hari.",
              align: TextAlign.justify),
        ]),
      ),
    );
  }
}
