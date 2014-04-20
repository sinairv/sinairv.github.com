---
layout: page
title: "ASP.NET MVC Notes"
comments: true
sharing: true
footer: true
---
### Helpers vs functions

helpers are not free to return anything and can be used inline. (Not sure).

# ASP.NET Notes

### aspx vs ashx files
See [this](http://stackoverflow.com/questions/5469491/aspx-vs-ashx-main-difference)

TL;DR. `.aspx` is a rendered page. If you need a view, use an `.aspx`. If all you need is backend functionality but staying on the same view, use an `.ashx`.

### Embedded Code

From [here](http://stackoverflow.com/a/3812341/836432)

`<%%>` is short hand for:

```html
<script runat="server">
</script>
```

Anyting inside the `<%` and `%>` is server side code.

The other variants are also shortcuts:

* `<%@ %>` is a page directrive
* `<%= %>` is short for Response.Write
* `<%: %>` is short for Response.Write, adding html encoding (introduced with .NET 4.0)
* `<%# %>` is a binding expression

There are more than these. See this awesome article and attached code:
[Embedded Code and Inline Server Tags - Ahmed Moosa](http://weblogs.asp.net/ahmedmoosa/archive/2010/10/06/embedded-code-and-inline-server-tags.aspx)


### Page event handling
With `AutoEventWireup` which is turned on by default on a page you can just add methods prepended with `Page_event` and have ASP.NET connect to the events for you.

In the case of `Unload` the method signature is:

```csharp
protected void Page_Unload(object sender, EventArgs e)
```
See: http://stackoverflow.com/a/7708993/836432

It can be done through overloading as well:

```csharp
protected override void OnUnload(EventArgs e)
{
   base.OnUnload(e);
   // your code
}
```

### storing in ViewState vs Session

Sessions run out, Viewstate does not - you can go back an hour later and your viewstate will still be available. Viewstate is also consistently available when you go back/forward on the website, Session changes.
From: http://stackoverflow.com/a/575592/836432

### User controls must be introduced in web.config
See: http://stackoverflow.com/a/243493/836432

### Lifecycles
See this: http://www.codeproject.com/Articles/73728/ASP-NET-Application-and-Page-Life-Cycle
Specially this:
![Page life cycle](http://www.codeproject.com/KB/aspnet/ASPDOTNETPageLifecycle/7.jpg)


