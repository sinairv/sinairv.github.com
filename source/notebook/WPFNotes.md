---
layout: page
title: "WPF Notes"
comments: true
sharing: true
footer: true
---
### Data Binding

General form of data-binding

```xml
<TextBox Text="{Binding Path=Property}"/>
```

`TextBox.Text` is the target, while `Property` is the source of binding.

*Target class*: any `FrameworkElement` (e.g., `TextBox`)   
*Target property*: any dependency property (DP) (e.g., `TextBox.Text`)   
`Binding` Properties: 
* `Path`: source object's *property*
* `XPath` ( **TODO** ), 
* `Source`: source *object*. This is required, but can be implicitly concluded
* `Mode`: if not specified, the element chooses the default (e.g., `TextBlock` -> `OneWay` whereas `TextBox` -> `TwoWay`)
    * `OneTime`: use the value for initializing, and do not watch for changes
    * `OneWay`: from source to target (useful for readonly elements like `TextBlock`
    * `OneWayToSource`: from target to source
    * `TwoWay`

#### Example

```xml
<Window x:Class="DataBinding.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:s="clr-namespace:System;assembly=mscorlib"
        Title="MainWindow" Height="350" Width="525">
    <Window.Resources>
        <s:String x:Key="TheString">OnWindow</s:String>
    </Window.Resources>
    <Grid>
        <Grid.Resources>
            <s:String x:Key="TheString">OnGrid</s:String>
        </Grid.Resources>
        <StackPanel>
            <TextBlock Text="{Binding Source={StaticResource ResourceKey=TheString}}"></TextBlock>
            <TextBlock Text="{Binding Source={StaticResource ResourceKey='TheString'}, Path=Length}"></TextBlock>
        </StackPanel>
    </Grid>
</Window>
```

The above code shows that:
* `FrameworkElement`s can have `Resources`.
* Each resource statically defined in XAML, must have a key defined through `x:key`.
* Binding to two resources with identical names is resolved in favour of the closest parent (here the `Grid`).
* The curly braces syntax is like object initializers of C#, except that the type name is moved inside the braces. Different properties are separated with commas.
* Assigning to `ResourceKey` (and similar assignments) do not require quotes, but single quotes can be used anyway.
* `StaticResource` is mapped to class `StaticResourceExtension`, and this class accepts `ResourceKey` as an argument to its constructor. Hence we can use it simply like `{StaticResource TheString}` (this is different from C# object initializers syntax).
* `Binding` class also accepts a constructor receiving the path, hence we can rewrite the second binding as follows:

```xml
<TextBlock Text="{Binding Length,Source={StaticResource TheString}}"></TextBlock>
```
* Binding to a static property of an object (e.g., `Environment.OSVersion.Platform`) can be accomplished by `x:Static` (Note that it is different from `StaticResource`):

```xml
<TextBlock Text="{Binding Platform,Source={x:Static s:Environment.OSVersion}}"></TextBlock>
```
### Binding String Format

Lets you format the displayed value of the bound data. Does not work for some target data-types such as `Content` of a `Button`. But works for the `Text` of a `TextBlock`. An example for integer:

```xml
<TextBox Text="{Binding Path=TheNumber,Mode=TwoWay,UpdateSourceTrigger=PropertyChanged}"/>
<TextBlock Text="{Binding Path=TheNumber,StringFormat='{}Hooy {0:C} Hi Hey'}"/>
```

Note that the format string is enclosed inside a pair of single quotes. Note that XAML parser treats braces for special purposes inside string literals. We can neutralize this effect by putting an empty pair of braces in the beginning, so that XMAL parser ignores the next brace and passes it to the string formatting method.

#### DataContext

* A property of `FrameworkElement`
* Setting `DataContext` to a `FrameworkElement` flows down to the child elements (they call it *inherited property*, but it is not inheritance by object types. It is inheritance by visual elements hierarchy).
* When `DataContext` does not have a value, the binding source must be explicitly specified; otherwise it is default to `DataContext`.


### Dependency Properties

* Can be used on `DependencyObject`s. 
* A public static instance of `DependencyProperty` per each dependency property in the class. This instance is created through the call to `DependencyProperty.Register` method.
* The `Register` method above recieves an instance of `PropertyMetadata` which can be used to define property-changed event-handlers or coerce-value-delegats.
* The coerce-value-delegate is called upon every value assigned to the property, and can be used to filter or change those values.
* The property-changed-deleate is called upon every **new** value assigned to the property. See the sample below:

```csharp
public class Person : DependencyObject
{
    public static readonly DependencyProperty PersonNameProperty =
        DependencyProperty.Register(
            "PersonName",                // the property name
            typeof(string),              // the property type
            typeof(Person),              // the property parent type
            new PropertyMetadata(        // instance of property meta-data
                    default(string),     // default value for the property
                    OnPersonNameChanged, // delegate called when property changes
                    CoerceValue));       // delegate to coerce (modify) each value assigned to property 

    private static object CoerceValue(DependencyObject o, object e)
    {
        Console.WriteLine("Coerce called with {0}", e);
        return ((e as string) ?? "") +  "!";
    }

    public void PerformCoerce()
    {
        CoerceValue(PersonNameProperty);
    }

    private static void OnPersonNameChanged(
        DependencyObject o, DependencyPropertyChangedEventArgs e)
    {
        Console.WriteLine("[{2}] Changed from {0} to {1}", 
            e.OldValue ?? "null", 
            e.NewValue ?? "null", 
            e.Property.Name);
    }

    public string PersonName
    {
        get { return (string) GetValue(PersonNameProperty); }
        set { SetValue(PersonNameProperty, value); }
    }
}
```

And the driver application:

```csharp
var sample = new Person();
sample.PersonName = "John";
sample.PersonName = "Jack";
sample.PersonName = "Jack";
sample.PersonName = "Tom";

sample.PerformCoerce();
Console.WriteLine("At last name is {0}", sample.PersonName);
```
