# DemoTefPayGoSimples #

Sobre
-----
DemoTefPayGoSimples é um projeto de exemplo que demonstra a integração


Tecnologias utilizadas
---
+ [PayGo SDK](https://github.com/claudneysessa/paygo_sdk)
+ [PayGo Integrado](https://paygodev.readme.io/docs/o-paygo-integrado)

Pré-requisitos
--- 
1. Baixar o [PayGo Integrado e PayGo SDK](https://setis.com.br/filevista/public/pg6b/kit-paygo-android-v4-1-35-7.zip)\*
2. Instalar o Apk do PayGo Integrado no dispositivo. 
   1. Para produção instalar o apk *PGIntegrado-v4.1.27.13_PROD-signed.apk*
   2. Para homologação instalar o apk *PGIntegrado-v4.1.27.13_CERT-signed.apk* 
3. Instalar este aplicativo no dispositivo. 
4. Ir em tela de configurações
5. Clicar no bõtão "Instalação" e digitar a senha técnica padrão  (314159)
   1. Digitar o id do ponto de captura 
   2. Digitar CPNJ do usuário 
   3. Digitar o endereço do servidor:

\* Lembre-se de baixar a versão correta para produção ou homologação

Arquitetura
--
Aplicação é dividida em camadas


Controller
---

## PayGoTefController ##
[PayGoTefController](lib/controller/PayGoTefController.dart) é responsável pelas regras de negócio.
<br/>

Essa tem propriedades configuráveis que permitem:
+   Habilitar/Desabilitar a impressão do comprovante
+  Trocar a [impressora](#generic-printer)


Essa classe implementa a interface [TefPayGoCallBack](lib/controller/types/tef_paygo_callback.dart) responsável por receber as respostas do PayGo Integrador.

+   [PayGoResponseHandler](lib/controller/paygo_response_handler.dart)
    +   Responsável por receber as respostas do PayGo Integrador e enviar para o TefController
+   [PayGoRequestHandler](lib/controller/paygo_request_handler.dart)
    +   Responsável para enviar as requisições para o PayGo Integrador.

    

## Generic Printer ## 
É uma interface que especifica os métodos que uma impressora deve implementar.</br>
A ideia dessa interface é desacoplar a impressora do TefController.

View
---
Responsável por mostrar as informações para o usuário.

## screens ##
Telas da aplicação

[MyHomePage](lib/view/screens/home_page.dart) é a tela principal da aplicação.<br/>
Essa tela implementa  [bottomNavigationBar](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html) para navegar entre as telas.

+  [PaymentModel](lib/view/screens/payment/payment_mode.dart)
   +    Tela inicial de pagamento
+  [ConfigurationPage](lib/view/screens/config/configuration_page.dart)
   +    Tela de configuração

## widgets ##
Widgets reutilizáveis.

Model
---
Responsável por armazenar as informações.


