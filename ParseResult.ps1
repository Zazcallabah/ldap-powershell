function ParseResult
{
	param( $searchResult )

	$outputList = @()
	$currentObj = @{}
	$i = 0
	while( $i -lt $searchResult.Count )
	{
		$line = $searchResult[$i++]
		if( $line -eq "" )
		{
			$outputList += New-Object PSObject -Property $currentObj
			$currentObj = @{}
		}
		else
		{
			$base64 = $false
			$r = [regex]"^([^:]+):<? (.*)$"
			$match = $r.Matches($line)
			if($match -eq $null -or $match.Count -eq 0)
			{
				$r = [regex]"^([^:]+):: (.*)$"
				$match = $r.Matches($line)
				if($match -eq $null -or $match.Count -eq 0)
				{
					throw "malformed result at line $($i): $line"
				}
				$base64 = $true
			}

			$name = $match.Groups[1].value
			$value = $match.Groups[2].value

			while( $i -lt $searchResult.Count -and ($searchResult[$i][0] -eq " " -or $searchResult[$i][0] -eq "`t") )
			{
				$value += $searchResult[$i++].substring(1)
			}

			if( $base64 )
			{
				$value = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($value))
			}

			if( $currentObj.ContainsKey($name) )
			{
				if( $currentObj[$name].GetType().Name -eq "Object[]" )
				{
					$currentObj[$name] += $value
				}
				else
				{
					$existing = $currentObj[$name]
					$currentObj[$name] = @($existing,$value)
				}
			}
			else
			{
				$currentObj.Add( $name, $value )
			}
		}
	}
	if( $searchResult[$searchResult.Count-1] -ne "" )
	{
		Write-Warning "missing final newline, output possibly truncated"
		$outputList += New-Object PSObject -Property $currentObj
	}
	return $outputList
}
