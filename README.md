Aplicativo feito em ruby onde consulta diretamente a api do shopify
Crud completo para produtos, collects,coleções,pedidos e cliente.(Funções do passo 1 de gerencimaneto de pedidos e faturamento)
Todas as requisições retornam json totalmente tratado. 
Infelizmente, não foi possivel concluir o front a tempo e fazer deploy do servidor. 

Instruções para instalação
Instalar o ruby 3.0 =>
gem install bundler
bundle install
ruby app.rb 

as chaves do shopify foram expostos propositalmente pois são apenas para testes

ENDPOINTS:
Endpoint: GET /collections

Finalidade: Recupera detalhes de todas as coleções personalizadas na loja Shopify.


{
  "id": "ID_da_Coleção"
}
Endpoint: DELETE /collection/:id

Finalidade: Remove uma coleção personalizada com base no ID fornecido.
Parâmetro de Rota: :id (ID da Coleção)

Endpoint: POST /collection
{
"title": "title",
"image":"image_url",
}
Finalidade: Cria uma nova coleção personalizada com base nas informações fornecidas.


Endpoint: PUT /product/:id

Finalidade: Atualiza um produto com base nas informações fornecidas.
Parâmetro de Rota: :id (ID do Produto)

{
  "title": "Novo Título",
  "body_html": "Novo HTML do Corpo",
  "status": "novo_status",
  "images": ["nova_imagem_url1", "nova_imagem_url2"],
  "clear_images": true (para ser false apenas não coloque no body)
}
Endpoint: GET /product/:id

Finalidade: Recupera detalhes de um produto específico com base no ID fornecido.
Parâmetro de Rota: :id (ID do Produto)
Endpoint: DELETE /remove_product

Finalidade: Remove um produto com base no ID fornecido.

Endpoint: POST /create_product
{
'title': "titulo,      
"body_html": "body_html",
"product_type":"product_type", 
"status": "status",
"images": "[]"
}

Finalidade: Cria um novo produto com base nas informações fornecidas.

Endpoint: GET /products

Finalidade: Recupera detalhes de todos os produtos na loja Shopify.
Endpoint: DELETE /order/:id
Parâmetro de Rota: :id (ID do pedido)
Finalidade: Remove um pedido específica com base no ID fornecido.

Endpoint: GET /orders
{"status": "all"}
Finalidade: Recupera todas os pedidos com base no status fornecido.

Endpoint: GET /order/:id

Finalidade: Recupera detalhes de um pedido específica com base no ID fornecido.
Parâmetro de Rota: :id (ID do pedido)
Endpoint: PUT /order

Finalidade: Atualiza uma ordem com base nas informações fornecidas.

Endpoint: PUT /order

Finalidade: edita um pedido
{
"id": "id",
"email":"email",
}

Endpoint: GET /collect

Finalidade: Recupera todos os registros de coletas da loja Shopify.
Endpoint: POST /collect/add_product
{
product_id: id,
collection_id: id,
}
Finalidade: Adiciona um produto a uma coleção específica.

Endpoint: DELETE /collect/remove_product
{
collect_id: id
}

Finalidade: Remove um produto de uma coleção específica.
