import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/PayGoTefController.dart';
import '../../widget/button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TefController _tefController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: <Widget>[
            Button(
              onPressed: onclickButtonInstalacao,
              text: 'Instalação',
            ),
            Button(
              onPressed: onclickButtonManutencao,
              text: ' Manutenção',
            ),
            Button(
              onPressed: onclickButtonPainelAdministrativo,
              text: 'Administrativo',
            ),
            Button( onPressed: onclickButtonExibePDC,
              text: "Exibe PDC",)
            ,
            Button(onPressed: onClickButtonRelatorioDetalhado,
                text: "Relatório Detalhado"),
            Button(onPressed: onclickButtonRelatorioResumido,
                text: "Relatório Resumido"),
            Button(onPressed: onclickButtonSelectProvider, text: "Selecionar Provedor")


          ],
        ),
      ),
    );
  }

  void onclickButtonInstalacao() async {
    await _tefController.payGORequestHandler.instalacao();
  }

  void onclickButtonManutencao() async {
    await _tefController.payGORequestHandler.manutencao();
  }

  void onclickButtonPainelAdministrativo() async {
    await _tefController.payGORequestHandler.painelAdministrativo();
   Navigator.canPop(context);
  }

  void onclickButtonExibePDC() async {
    await _tefController.payGORequestHandler.exibePDC();
   Navigator.canPop(context);
  }

  void onClickButtonRelatorioDetalhado() async{
    await _tefController.payGORequestHandler.relatorioDetalhado();
   Navigator.canPop(context);
  }

  void onclickButtonRelatorioResumido() async {
    await _tefController.payGORequestHandler.relatorioResumido();

   Navigator.canPop(context);
  }

  void onclickButtonSelectProvider(){
     var providers =  { "DEMO", "REDE", "CIELO" } ;
     showDialog(
       context: context,
       builder: (BuildContext context) {
         String? selectedProvider = _tefController.payGORequestHandler.provider;
         return AlertDialog(
           title: Text("Selecione o provedor"),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: providers.map((e) => RadioListTile<String>(
               title: Text(e),
               value: e,
               groupValue: selectedProvider,
               onChanged: (String? value) {
                 setState(() {
                   selectedProvider = value;
                   _tefController.payGORequestHandler.setProvider(value!);
                 });
                 Navigator.pop(context);
               },
             )).toList(),
           ),
         );
       },
     );

  }
}
