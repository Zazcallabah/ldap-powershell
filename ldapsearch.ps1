param( $searchString, $server, $username, $password )

. $PSScriptRoot/ParseResult.ps1

$searchResult = ldapsearch -b $searchString -D $user -h $server -xw $password -LLL
return ParseResult $searchResult
