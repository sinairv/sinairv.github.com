---
layout: page
title: "NHibernate Notes"
comments: true
sharing: true
footer: true
---
#NHibernate Notes

## Mapping metadata

* XML-based
  * hbm.xml files
* Code-based
  * Fluent NHibernate
* Convention-based
  * Automapping in Fluent NHibernate
  * ConfORM

## Enbale visual studio intelli-sense

Copy NHibernate `xsd` files to `C:\Program Files\Visual Studio\Xml\Schemas`

## Defining entity classes

```csharp
public class SomeEntity
{
    public SomeEntity() { }
    public virtual Guid Id { get; set; }
    public virtual string SomeName { get; set; }
    public virtual DateTime? SomeDate { get; set; }
}
```

Notice that all properties are preceded by a `virtual` declaration. This is required in order to use the **lazy loading** feature of NHibernate. As you can see, NHibernate does not require inheritance from a base class or implementation of any interfaces to utilize its features. Instead, **NHibernate creates a proxy of the class**. In this context, **an NHibernate proxy is an inherited type of the `SomeEntity` class**. The `SomeEntity` class is considered the base class to NHibernate's proxies. **At application startup**, NHibernate inherits and overrides the class, adding the required logic to support **lazy loading**. Note that if value-types correspond to a nullable database column, must be defined as nullable in the entity class as well, otherwise an instance of `PropertyValueException` would be thrown.

> All value types should be implemented as nullable or you need to ensure that the values on the database do not allow nulls.

Use automatic properties: When using NHibernate's property-level accessor mappings, using
the underlying private field value (instead of going through the `{get; set;}`
property) will circumvent lazy loading and produce unexpected results. Consider
this another reason to use auto-implemented or automatic properties.

When an entity has a list of another entity, it is important to set lazy loading to `true`; otherwise, when loading the data
into the first entity, the second entity is also loaded, too, even if it is not needed.

*TODOs*:
* Note about ClassMapping<Enitity>
* Note about session techniques, e.g., session-per-presenter
* What is flushing

> Take a look at the NHibernate.ISession.cs file for a great description of
the Session and the role it plays. The source code is well documented and you
can learn a lot from it. The comments were written by experts and you can find
some real gems in there. 
[ISession.cs](https://github.com/nhibernate/nhibernate-core/blob/master/src/NHibernate/ISession.cs)
