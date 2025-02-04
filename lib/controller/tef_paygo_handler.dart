import 'package:flutter/material.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_resposta.dart';
import 'package:tectoy_sunmiprinter/tectoy_sunmiprinter.dart';

import '../utils/paygo_consts.dart';
import '../utils/tef_paygo_transacoes.dart';

/**
 * Classe para tratar as respostas do PayGo Integrado
 */

class PayGOResponseHandler {
  final BuildContext context;
  final Function(String) onChangePaygoIntegrado;
  final Function() getPaygoIntegrado;
  final _printer = TectoySunmiprinter();
  final _tefPayGoTransacoes = PayGoOperationHelper().tefPayGoTransacoes;

  PayGOResponseHandler(
      this.context, this.onChangePaygoIntegrado, this.getPaygoIntegrado);

  /**
   * Metodo para tratar a transacao de venda
   */
  void handleTransacaoVenda(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "VENDA") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _tefPayGoTransacoes.confirmarTransacao(
              resposta.transactionId); //confirma a transacao automaticamente

          imprimirComprovante(resposta.merchantReceipt);

          mostrarDialogoImpressao(
              resposta.cardholderReceipt, "Imprimir via do Cliente?");
        } else {
          //tratar transacao pendente

          if (resposta?.transactionResult ==
              PayGoRetornoConsts.PWRET_FROMHOSTPENDTRN) {
            //resolverPendencia(resposta?.uri);
            ;
          }

          //tratar outros erros
        }
      }
    }
  }

  /**
   * Metodo para tratar a transacao de reimpressao
   */

  void handleTransacaoReimpressao(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "REIMPRESSAO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          imprimirComprovante(resposta.merchantReceipt);
          mostrarDialogoImpressao(
              resposta.cardholderReceipt, "Imprimir via do Cliente?");
        }
      }
    }
  }

  /**
   * Metodo (exemplo) para tratar transacao nao suportada
   */

  void handleTransacaoNaoSuportada(TransacaoRequisicaoResposta resposta) {}

  /**
   * Metodo para tratar a resposta do PayGo Integrado
   */
  void tratarRespostaPaygoIntegrado(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      switch (resposta.operation) {
        case "VENDA":
          handleTransacaoVenda(resposta);
          break;

        case "REIMPRESSAO":
          handleTransacaoReimpressao(resposta);
          break;

        case "CANCELAMENTO":
          handleCancelamento(resposta);
          break;

        case "RELATORIO_SINTETICO":
        case "RELATORIO_DETALHADO":
        case "RELATORIO_RESUMIDO":
          handleImprimeRelatorio(resposta);
          break;

        case "EXIBE_PDC":
          handleExibePDC(resposta);
          break;
        // não exigem ação imediata
        case "MANUTENCAO":
        case "INSTALACAO":
        case "ADMINISTRATIVA":
        case "TESTE_COMUNICACAO":
        case "OPERACAO_DESCONHECIDA":
          ;
        default:
          handleTransacaoNaoSuportada(resposta);
          break;
      }

      onChangePaygoIntegrado("Resposta do PayGo Integrado:\n" +
              "Operation: ${resposta?.operation} \n" +
              "ID: ${resposta?.transactionId}\n" +
              "Mensagem: ${resposta?.resultMessage}\n" +
              "Resultado da transação: ${resposta?.transactionResult}\n"
          // "cardholderReceipt: ${resposta?.cardholderReceipt}\n" + //via do cliente
          // "merchantReceipt: ${resposta?.merchantReceipt}\n" //via do estabelecimento

          );
    }
  }

  void imprimirComprovante(String comprovante) async {
    try {
      await _printer.printText(comprovante);
      await _printer.cutPaper();
    } catch (e) {
      String paygoIntegrado = getPaygoIntegrado();
      onChangePaygoIntegrado(paygoIntegrado + "\n" + e.toString());
    }
  }

  void handleExibePDC(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "EXIBE_PDC") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          onChangePaygoIntegrado(resposta.resultMessage);
        }
      }
    }
  }

  void handleCancelamento(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation == "CANCELAMENTO") {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          _tefPayGoTransacoes.confirmarTransacao(resposta.transactionId);
          mostrarDialogoImpressao(
              resposta.fullReceipt, "Imprimir comprovante de cancelamento?");
        }
      }
    }
  }

  void handleImprimeRelatorio(TransacaoRequisicaoResposta resposta) {
    if (resposta != null) {
      if (resposta.operation.startsWith("RELATORIO")) {
        if (resposta?.transactionResult == PayGoRetornoConsts.PWRET_OK) {
          String tipoRelatorio = resposta.operation
              .toLowerCase()
              .replaceAll("_", " ")
              .capitalizeFirstofEach();
          mostrarDialogoImpressao(
              resposta.fullReceipt, "Imprimir $tipoRelatorio?");
        }
      }
    }
  }

  void mostrarDialogoImpressao(String conteudo, String titulo) {
    showDialog(
        context: context,
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
                  imprimirComprovante(conteudo);
                  Navigator.of(context).pop();
                },
                child: const Text("Imprimir"),
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
