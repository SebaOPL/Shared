Function GetGPOMetadata
{
    param(
        [System.Xml.XmlDocument]$data = [xml](Get-Content 'C:\PathToFile\gpreport.xml' -Raw)
    )

    $Namespaces = [System.Xml.XmlNamespaceManager]::New($data.NameTable)

    $Nodes = $data.ChildNodes
    foreach($Node in $Nodes)
    {
        if($Node.GetType().FullName -ne "System.Xml.XmlElement"){continue;}

        #Node is XmlElement
        $NodeNamespace = $Node.NamespaceURI
        $NodeNamespaceAbbreviation = $Node.NamespaceURI.Split("/")[-1]
        $Namespaces.AddNamespace($NodeNamespaceAbbreviation,$NodeNamespace)
        
        GetXMLElementPaths -XmlElement $Node -XPath "/$($NodeNamespaceAbbreviation):$($Node.LocalName)" -Namespaces $Namespaces
    }
}

Function GetXMLElementPaths
{
    param(
        [Parameter(Mandatory=$true)]
        [System.Xml.XmlElement]$XMLElement,
        [string]$XPath,
        [System.Xml.XmlNamespaceManager]$Namespaces
    )

    $XPath

    $Nodes = $XmlElement.ChildNodes

    foreach($Node in $Nodes)
    {
        if($Node.GetType().FullName -ne "System.Xml.XmlElement"){continue;}

        #Node is XmlElement
        $NodeNamespace = $Node.NamespaceURI
        $NodeNamespaceAbbreviation = $Node.NamespaceURI.Split("/")[-1]
        $Namespaces.AddNamespace($NodeNamespaceAbbreviation,$NodeNamespace)

        GetXMLElementPaths -XmlElement $Node -XPath "$($XPath)/$($NodeNamespaceAbbreviation):$($Node.LocalName)" -Namespaces $Namespaces
    }
}
