﻿$TopLevelFolder = Split-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -Parent
Import-Module (Join-Path -Path $TopLevelFolder -ChildPath 'PSDokuWiki\PSDokuWiki.psm1') -Force

Describe 'ConvertTo-XmlRpcType' {
    Context 'Strict Mode' {

        Set-StrictMode -Version latest

        It 'Successfully converts string(s)' {
            ConvertTo-XmlRpcType -InputObject 'Hello' | Should -be '<value><string>Hello</string></value>'
        }
        It 'Successfully converts Booleans' {
            ConvertTo-XmlRpcType -InputObject $true | Should -be '<value><boolean>1</boolean></value>'
        }
        It 'Successfully converts Base64 Encoded data' {
            ConvertTo-XmlRpcType -InputObject 'SGVsbG8gV29ybGQ=' | Should -be '<value><base64>SGVsbG8gV29ybGQ=</base64></value>'
        }
        It 'Successfully converts Int32' {
            ConvertTo-XmlRpcType -InputObject 8 | Should -be '<value><i4>8</i4></value>'
        }
        It 'Successfully converts DateTime' {
            [datetime]$Date = '1/1/1980'
            ConvertTo-XmlRpcType -InputObject $Date | Should -be '<value><dateTime.iso8601>19800101T00:00:00</dateTime.iso8601></value>'
        }
        It 'Successfully converts array' {
            ConvertTo-XmlRpcType -InputObject @('Hello','World',123) | Should -be '<value><array><data><value><string>Hello</string></value><value><string>World</string></value><value><i4>123</i4></value></data></array></value>'
        }
        It 'Successfully converts hashtables' {
            ConvertTo-XmlRpcType -InputObject @{'ow' = 1} | Should -be '<value><struct><member><name>ow</name><value><i4>1</i4></value></member></struct></value>'
        }   
        It 'Successfully converts XML' {
            # How to create a valid xml object without ConvertTo-Xml ???
            ConvertTo-XmlRpcType -InputObject (ConvertTo-Xml -InputObject @('lol',1,'hello')) | Should -be '<?xml version="1.0" encoding="utf-8"?><Objects><Object Type="System.Object[]"><Property Type="System.String">lol</Property><Property Type="System.Int32">1</Property><Property Type="System.String">hello</Property></Object></Objects>'
        }
        It 'Successfully converts mixed data' {
            ConvertTo-XmlRpcType -InputObject @('Hello World',1,@{'Key1' = 'Value1'; 'Key2' = 2; 'Key3' = @(1,2,3)}) | Should -be '<value><array><data><value><string>Hello World</string></value><value><i4>1</i4></value><value><struct><member><name>Key3</name><value><array><data><value><i4>1</i4></value><value><i4>2</i4></value><value><i4>3</i4></value></data></array></value></member><member><name>Key1</name><value><string>Value1</string></value></member><member><name>Key2</name><value><i4>2</i4></value></member></struct></value></data></array></value>'
        }
        It 'Successfully converts NULL' {
            ConvertTo-XmlRpcType -InputObject $null | Should -be ''
        }
    }
}
 # cm
Describe 'ConvertTo-XmlRpcMethodCall' {
    Context 'Strict Mode' {

        Set-StrictMode -Version latest
        function ConvertTo-XmlRpcType {  }
        
        Mock ConvertTo-XmlRpcType { return '' }
        It 'Succeeds for methods with no params' {
            ConvertTo-XmlRpcMethodCall -Name 'wiki.getAllPages' | Should -be '<?xml version="1.0"?><methodCall><methodName>wiki.getAllPages</methodName><params></params></methodCall>'
        }
    }
}

Describe 'New-DokuSession' {
    Context 'Strict Mode' {

        $credential = New-Object System.Management.Automation.PSCredential ('username', (ConvertTo-SecureString 'password' -AsPlainText -Force))
        Set-StrictMode -Version latest
        It 'Fails when specifying a non-existent server' {
            {New-DokuSession -Server 'wiki.localhost.local' -Unencrypted -SessionMethod 'Cookie' -Credential $credential}   | Should -Throw
        }
        It 'Fails when server is $null' {
            {New-DokuSession -Server $null -Unencrypted -SessionMethod 'Cookie' -Credential $credential}   | Should -Throw
        }
        It 'Fails when using a non-existent session method' {
            {New-DokuSession -Server 'wiki.localhost.local' -Unencrypted -SessionMethod 'Hello World' -Credential $credential}   | Should -Throw
        }
    }
}