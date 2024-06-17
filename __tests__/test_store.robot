*** Settings ***
Library    RequestsLibrary

*** Variables ***
${url}    https://petstore.swagger.io/v2/store
${id}    665201
${petId}    420665201
${quantity}    3
${shipDate}    2024-06-17T04:11:08.686+0000
${status}    placed
${complete}    true

*** Test Cases ***

Post Order
    ${body}    Create Dictionary    id=${id}    petId=${petId}    quantity=${quantity}    shipDate=${shipDate}    status=${status}    complete=${complete}

    ${response}    POST    url=${url}/order    json=${body}

    ${response_body}    Set Variable    ${response.json()}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[petId]    ${{int($petId)}}
    Should Be Equal    ${response_body}[quantity]    ${{int($quantity)}}
    Should Be Equal    ${response_body}[shipDate]    ${shipDate}
    Should Be Equal    ${response_body}[status]    ${status}
    Should Be Equal    ${response_body}[complete]    ${{bool($complete)}}

Get Order
    ${response}    GET    url=${url}/order/${id}

    ${response_body}    Set Variable    ${response.json()}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[petId]    ${{int($petId)}}
    Should Be Equal    ${response_body}[quantity]    ${{int($quantity)}}
    Should Be Equal    ${response_body}[shipDate]    ${shipDate}
    Should Be Equal    ${response_body}[status]    ${status}
    Should Be Equal    ${response_body}[complete]    ${{bool($complete)}}
    

Delete Order
    ${response}    DELETE    url=${url}/order/${id}
    ${response_body}    Set Variable    ${response.json()}
    Status Should Be    200
    Should Be Equal    ${response_body}[message]    ${id}

