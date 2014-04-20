---
layout: page
title: "MVVM, WPF, and XAML Notes"
comments: true
sharing: true
footer: true
---
# MVVM

Similiar Design Pattern by Martin Fowler called *Presentation Model* (PM).

# XAML (WPF)

`IDataErrorInfo` interface sends up the validation errors to the view. To implement add a property and an indexer:

```csharp
public string Error 
{ 
    get { ... } 
    // return object level error message
}

public string this[string columnName]
{ 
    get { ... }
}
```

`Error` property sends object level error messages (e.g., when the whole object is in an erroneous state).

The indexer should return validation messages based on the property/column name.

View first approach: view creates an instance of ViewModel (prob. in the code behind and with explicit type name).

You must add a property to the binding: `Text={Binding ... ,ValidatesOnDataErrors=True}`.

From [here](http://stackoverflow.com/a/17256111/836432): 

> `ValidatesOnNotifyDataErrors` and `ValidatesOnDataErrors` are used when you want a XAML bound control to validate its input based on an interface implemented in the ViewModel/Model, for `ValidatesOnNotifyDataErrors` that interface is `INotifyDataErrorInfo` and for `ValidatesOnDataErrors` it is `IDataErrorInfo`.

Read this:
http://blog.magnusmontin.net/2013/08/26/data-validation-in-wpf/

From *Pro WPF in C# 2010*:

.NET provides two shortcuts. Rather than adding the `ExceptionValidationRule` to the binding, you can set the `Binding.ValidatesOnExceptions` property to `true`. Rather than adding the `DataErrorValidationRule`, you can set
the `Binding.ValidatesOnDataErrors` property to true.

```xml
<TextBox Margin="5" Grid.Column="1">
    <TextBox.Text>
        <Binding Path="ModelNumber">
            <Binding.ValidationRules>
                <DataErrorValidationRule></DataErrorValidationRule>
            </Binding.ValidationRules>
        </Binding>
    </TextBox.Text>
</TextBox>
```



#PRISM
Region is a placeholder for dynamic UI.

Analogous to `ContentPlaceHolder` in ASP.NET master page.

`Shell` contain regions to be injected, sth like the containing form.

-> IRegion

RegionContext attached property.


