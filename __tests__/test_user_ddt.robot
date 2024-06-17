*** Settings ***
Library    RequestsLibrary
Library    DataDriver    ../fixtures/csv/users.csv    dialect=excel
Test Template    Create User

*** Variables ***
${url}    https://petstore.swagger.io/v2/user


*** Test Cases ***
Create And Delete User   ${id}    ${username}    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}
    

*** Keywords ***
Create User
    [Arguments]    ${id}    ${username}    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}

    ${body}    Create Dictionary    id=${id}    username=${username}    firstName=${firstName}    lastName=${lastName}    email=${email}    password=${password}    phone=${phone}    userStatus=${userStatus}

    ${response}    POST    url=${url}    json=${body}
    ${response_body}    Set Variable    ${response.json()}

    Status Should Be    200
    Should Be Equal    ${response_body}[message]    ${id}
    Log To Console    ${response_body}

    ${response_delete}    DELETE    url=${url}/${username}
    ${response_body_delete}    Set Variable    ${response_delete.json()}

    Status Should Be    200
    Should Be Equal    ${response_body_delete}[message]    ${username}
    Log To Console    ${response_body_delete}

    
