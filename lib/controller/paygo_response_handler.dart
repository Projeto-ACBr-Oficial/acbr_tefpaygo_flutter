import 'package:flutter/material.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:receive_intent/receive_intent.dart' as receive_intent;
import 'package:tectoy_sunmiprinter/tectoy_sunmiprinter.dart';

import '../utils/paygo_consts.dart';
import '../utils/paygo_request_handler_helper.dart';

/**
 * Classe para tratar as respostas do PayGo Integrado
 */

class PayGOResponseHandler {
  final BuildContext _context;
  final _printer = TectoySunmiprinter();
  final _payGORequestHandler = PayGoRequestHandlerHelper().payGoRequestHandler;

  PayGOResponseHandler(this._context);

  /**
   * Metodo para tratar a resposta do PayGo Integrado
   */
  void processarResposta(receive_intent.Intent? intent) {
    if (intent?.data != null) {
      final Uri uri = Uri.parse(intent?.data ?? '');
      final String decodedUri = Uri.decodeFull(uri.toString());
      TransacaoRequisicaoResposta? resposta;
      resposta = TransacaoRequisicaoResposta.fromUri(decodedUri);
      _processarResposta(resposta);
    }
  }

  void _processarResposta(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      switch (resposta.operation) {
        case "VENDA":
          _handleTransacaoVenda(resposta);
          break;

        case "REIMPRESSAO":
          _handleTransacaoReimpressao(resposta);
          break;

        case "CANCELAMENTO":
          _handleCancelamento(resposta);
          break;

        case "RELATORIO_SINTETICO":
        case "RELATORIO_DETALHADO":
        case "RELATORIO_RESUMIDO":
          _handleImprimeRelatorio(resposta);
          break;

        case "EXIBE_PDC":
          _handleExibePDC(resposta);
          break;
        // não exigem ação imediata
        case "MANUTENCAO":
        case "INSTALACAO":
        case "ADMINISTRATIVA":
        case "TESTE_COMUNICACAO":
        case "OPERACAO_DESCONHECIDA":
        default:
          _handleOutraOperacao(resposta);
          break;
      }
    }
  }

  void _imprimirComprovante(String comprovante) async {
    try {
      await _printer.printText(comprovante);
      await _printer.cutPaper();
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  void _handleExibePDC(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "EXIBE_PDC") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _showMessage(resposta.resultMessage);
        }
      }
    }
  }

  void _handleCancelamento(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "CANCELAMENTO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _payGORequestHandler.confirmarTransacao(resposta.transactionId);
          _mostrarDialogoImpressao(
              resposta.merchantReceipt, "Imprimir comprovante de cancelamento?");
        }else
          _showMessage(resposta.resultMessage);
      }
    }
  }

  void _handleImprimeRelatorio(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation.startsWith("RELATORIO")) {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          String tipoRelatorio = resposta.operation
              .toLowerCase()
              .replaceAll("_", " ")
              .capitalizeFirstofEach();
          _mostrarDialogoImpressao(
              resposta.fullReceipt, "Imprimir $tipoRelatorio?");
        }else
          _showMessage(resposta.resultMessage);
      }
    }
  }

  /**
   * Metodo para tratar a transacao de venda
   */
  void _handleTransacaoVenda(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "VENDA") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _payGORequestHandler.confirmarTransacao(
              resposta.transactionId); //confirma a transacao automaticamente

          _imprimirComprovante(resposta.merchantReceipt);

          _mostrarDialogoImpressao(
              resposta.cardholderReceipt, "Imprimir via do Cliente?");
        } else {

          // para este exemplo, apenas exibe a mensagem de erro
          _showMessage(resposta.resultMessage);

          // // exemplo de tratamento de erro:
          // if ( resposta.resultCode == PayGoRetornoConsts.PWRET_NOTHING ) {
          //   _showMessage("Nenhuma ação foi realizada");
          // }
        }
      }
    }
  }

  /**
   * Metodo para tratar a transacao de reimpressao
   */

  void _handleTransacaoReimpressao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "REIMPRESSAO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _imprimirComprovante(resposta.merchantReceipt);
          _mostrarDialogoImpressao(
              resposta.cardholderReceipt, "Imprimir via do Cliente?");
        }else {
           _showMessage(resposta.resultMessage);
        }
      }
    }
  }

  void _handleOutraOperacao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      _showMessage("Resposta do PayGo Integrado:\n" +
              "Operation: ${resposta?.operation} \n" +
              "ID: ${resposta?.transactionId}\n" +
              "Mensagem: ${resposta?.resultMessage}\n" +
              "Resultado da transação: ${resposta?.transactionResult}\n"
          // "cardholderReceipt: ${resposta?.cardholderReceipt}\n" + //via do cliente
          // "merchantReceipt: ${resposta?.merchantReceipt}\n" //via do estabelecimento

          );
    }
  }

  void _mostrarDialogoImpressao(String conteudo, String titulo) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titulo),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
              TextButton(
                onPressed: () {
                  _imprimirComprovante(conteudo);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
              ),
            ],
          );
        });
  }

  void _showMessage(String message) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Resposta do PayGo Integrado"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
            ],
          );
        });
  }
}

extension on String {
  String capitalizeFirstofEach() {
    return this
        .split(" ")
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join(" ");
  }
}
