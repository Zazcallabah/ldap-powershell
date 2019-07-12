. $PSScriptRoot/ParseResult.ps1

Describe "ParseResult" {
	It "can parse minimalistic result" {
		$result = ParseResult @("dn: a","cn: b","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "a"
		$result[0].cn | should be "b"
	}
	It "handles malformed input missing final newline" {
		$result = ParseResult @("dn: a","cn: b")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "a"
		$result[0].cn | should be "b"
	}
	It "can parse multiple objects" {
		$result = ParseResult @("dn: a","cn: b","","dn: 1","cn: 2","")
		$result | measure | select -expandproperty count | should be 2
		$result[0].dn | should be "a"
		$result[0].cn | should be "b"
		$result[1].dn | should be "1"
		$result[1].cn | should be "2"
	}
	It "can parse object with multiple lines in prop" {
		$result = ParseResult @("dn: a","cn: b"," aoeu","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "a"
		$result[0].cn | should be "baoeu"
	}
	It "can parse object with array property" {
		$result = ParseResult @("dn: a","memberOf: b","memberOf: d","memberOf: e","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "a"
		$result[0].memberOf | should be @("b","d","e")
	}
	It "can parse object with multiline tab indent" {
		$result = ParseResult @("dn: a","cn: b","`taoeu","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "a"
		$result[0].cn | should be "baoeu"
	}
	It "can parse object with multiline prop and missing final newline" {
		$result = ParseResult @("dn: a","cn: b"," aoeu")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "a"
		$result[0].cn | should be "baoeu"
	}
	It "can parse object with base64 prop" {
		$result = ParseResult @("dn:: YW9ldQ==","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "aoeu"
	}
	It "can parse object with multiline base64 prop" {
		$result = ParseResult @("dn:: YW9"," ldQ==","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "aoeu"
	}
	It "can find url property" {
		$result = ParseResult @("dn:< file:/null","")
		$result | measure | select -expandproperty count | should be 1
		$result[0].dn | should be "file:/null"
	}
}