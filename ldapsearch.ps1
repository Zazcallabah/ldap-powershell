param( $searchString, $server, $username, $password )

. $PSScriptRoot/ParseResult.ps1

$searchResult = ldapsearch -b $searchString -h $server -D $username -xw $password -LLL
return ParseResult $searchResult
