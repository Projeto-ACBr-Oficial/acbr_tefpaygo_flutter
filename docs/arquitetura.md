# Arquitetura da aplicação #


Controller
---
Controller foi dividido em duas classes principais: *PayGoResponseHandler* e *PayGoRequestHandler.*

#### [PayGoResponseHandler](../lib/controller/paygo_response_handler.dart)  ####
Responsável por receber as respostas do PayGo Integrador e enviá-las para o TefPayGoController.

#### [PayGoRequestHandler](../lib/controller/paygo_request_handler.dart) ####
Responsável para enviar as requisições para o PayGo Integrador.


#### [TefPayGoCallBack](../lib/controller/types/tef_paygo_callback.dart) ####
É uma interface de comunicação entre a view e o PayGoResponseHandler.
