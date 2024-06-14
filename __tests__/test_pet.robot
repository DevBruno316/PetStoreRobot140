*** Settings ***
# Bibliotecas e Configurações
Library    RequestsLibrary
Library    ../.venv/Lib/site-packages/robot/libraries/Telnet.py

*** Variables ***
# Objetos, Atributos e Variables
${url}    https://petstore.swagger.io/v2/pet

${id}     420665201                    # $ sinaliza uma variavel simples
${name}    Snoopy
&{category}    id=1    name=cachorro    # & = lista com campos determinados. Ex: id e name - seria {}
@{photoUrls}                            # @ sinaliza uma lista com vários registros - seria []
&{tag}    id=1    name=vacinado
@{tags}   ${tag}                        # Fez uma lista de outra lista
${status}    available

*** Test Cases ***
# Descritivo de Negócio + Passos de Automação

Post pet
    # Montar a mensagem / body
    ${body}    Create Dictionary    id=${id}    category=${category}    name=${name}    
    ...                             photoUrls=${photoUrls}  tags=${tags}    status=${status}
    
    # Executar 
    ${response}    POST    url=${url}    json=${body}

    # Validar
    ${response_body}    Set Variable    ${response.json()}  # Recebe o conteúdo da outra variavel
    Log To Console      ${response_body}    # imprimir o retorno da API no terminal / console

    Status Should Be    200
    Should Be Equal    ${response_body}[id]               ${{int($id)}}
    Should Be Equal    ${response_body}[name]             ${name}
    Should Be Equal    ${response_body}[tags][0][id]      ${{int(${tag}[id])}}
    Should Be Equal    ${response_body}[tags][0][name]    ${tag}[name]   
    Should Be Equal    ${response_body}[status]           ${status}
Get pet
    ${response}    GET    url=${{$url + '/' + $id}}

    ${response_body}        Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[name]    ${name}
    Should Be Equal    ${response_body}[category][id]   ${{int(${category}[id])}}
    Should Be Equal    ${response_body}[category][name]   ${category}[name]
    Should Be Equal    ${response_body}[status]    ${status}


Put pet
    # Montar o body com a mudança
    ${body}    Evaluate    json.loads(open("../fixtures/json/pet2.json").read())

    ${response}    PUT    url=${url}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[name]    Maya
    Should Be Equal    ${response_body}[category][id]   ${{int(${category}[id])}}
    Should Be Equal    ${response_body}[category][name]   ${category}[name]
    Should Be Equal    ${response_body}[status]    sold

Delete pet
    ${response}    DELETE    ${{$url + '/' + $id}}

     ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{int(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${id}
    
    


