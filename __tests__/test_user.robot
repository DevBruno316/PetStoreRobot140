*** Settings ***
Library    RequestsLibrary
*** Variables ***
${url}    https://petstore.swagger.io/v2/user

${id}    420665201
${username}    jehjennifer2005
${firstName}    Jennifer
${lastName}    Santana
${email}    jehjennifer@gmail.com
${password}    narutinhojeh
${phone}    55184657
${userStatus}    665201


*** Test Cases ***

Create User
    ${body}    Create Dictionary    id=${id}    username=${username}    firstName=${firstName}    lastName=${lastName}    email=${email}    password=${password}    phone=${phone}    userStatus=${userStatus}

    ${response}    POST    url=${url}    json=${body}    

    ${response_body}    Set Variable    ${response.json()}

    Status Should Be    200
    Should Be Equal    ${response_body}[message]    ${id}

Get User by username
    
    ${response}    GET    url=${url}/${username}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[username]    ${username}
    Should Be Equal    ${response_body}[firstName]    ${firstName}
    Should Be Equal    ${response_body}[lastName]    ${lastName}
    Should Be Equal    ${response_body}[email]    ${email}
    Should Be Equal    ${response_body}[password]    ${password}
    Should Be Equal    ${response_body}[userStatus]    ${{int($userStatus)}}

Update User
    ${body}    Evaluate    json.loads(open('../fixtures/json/user.json').read())

    ${response}    PUT    url=${url}/${username}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[message]    ${id}

Get User after Update
   
   ${response}    GET    url=${url}/${username}
   ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}    
    Status Should Be    200

    Should Be Equal    ${response_body}[id]    ${{int($id)}}
    Should Be Equal    ${response_body}[username]    ${username}
    Should Be Equal    ${response_body}[firstName]    ${firstName}
    Should Be Equal    ${response_body}[lastName]    ${lastName}
    Should Be Equal    ${response_body}[email]    jehjennifer2005@gmail.com
    Should Be Equal    ${response_body}[password]    narutinhojeh2005
    Should Be Equal    ${response_body}[userStatus]    ${{int(42001)}}

Delete User
    
    ${response}    DELETE    url=${url}/${username}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[message]    ${username}

    


  

