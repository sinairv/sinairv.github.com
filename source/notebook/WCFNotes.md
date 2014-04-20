---
layout: page
title: "WCF Notes"
comments: true
sharing: true
footer: true
---
## WCF Serializers

* XmlSerializer (from .NET 1.0 till now)
* NetDataContractSerializer
* DataContractSerializer (default to WCF)
* DataContractJsonSerializer (new in .NET 3.5)


`SVCUtil.exe`: two-way conversion between .NET Objects and XSD 
* XSD Types `<->` .NET Types

## `DataContractSerializer` sample class

```csharp
[DataContract]
public class Eval
{
   [DataMemeber]
   public string Submitter;
}
```

Add `System.Runtime.Serialization.dll`.

Serialization done through `WriteObject` and `ReadObject` methods of `DataContractSerializer`.

## Create schema from assembly and vice versa

    SvcUtil.exe /dconly Assembly.dll

`/dconly` stands for data-contract only.

This is how to create .NET code out of schema:

    SvcUtil.exe /dconly Schema.xsd


## `XmlSerializer`

* Available since .NET 1.0
* Used by default by ASP.NET Web Services (ASMX)
* Relies on things being `public`
