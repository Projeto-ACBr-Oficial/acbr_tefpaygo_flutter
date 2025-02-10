import 'package:flutter/material.dart';

import '../../../controller/paygo_request_handler.dart';
import '../../../utils/paygo_request_handler_helper.dart';
import '../../widget/button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandlerHelper().payGoRequestHandler;

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
              text: 'Abrir menu de instalação',
            ),
            Button(
              onPressed: onclickButtonManutencao,
              text: 'Abrir menu de manutenção',
            ),
            Button(
              onPressed: onclickButtonPainelAdministrativo,
              text: 'Abrir Painel Administrativo',
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
    await _payGORequestHandler.instalacao();
  }

  void onclickButtonManutencao() async {
    await _payGORequestHandler.manutencao();
  }

  void onclickButtonPainelAdministrativo() async {
    await _payGORequestHandler.painelAdministrativo();
   Navigator.canPop(context);
  }

  void onclickButtonExibePDC() async {
    await _payGORequestHandler.exibePDC();
   Navigator.canPop(context);
  }

  void onClickButtonRelatorioDetalhado() async{
    await _payGORequestHandler.relatorioDetalhado();
   Navigator.canPop(context);
  }

  void onclickButtonRelatorioResumido() async {
    await _payGORequestHandler.relatorioResumido();

   Navigator.canPop(context);
  }

  void onclickButtonSelectProvider(){
     var providers =  { "DEMO", "REDE", "CIELO" } ;
     showDialog(
       context: context,
       builder: (BuildContext context) {
         String? selectedProvider = _payGORequestHandler.provider;
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
                   _payGORequestHandler.setProvider(value!);
                 });
                 Navigator.canPop(context);
               },
             )).toList(),
           ),
         );
       },
     );

  }
}
