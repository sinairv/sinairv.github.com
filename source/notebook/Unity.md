---
layout: page
title: "Unity Notes"
comments: true
sharing: true
footer: true
---
Unity does not need a `[Dependency]` attribute on constructor parameters.

properties that are not marked with `[Dependency]` are NOT resolved.

Q: when there are more than 1 ctor, how to force it to use a specific one?

A: decorate the one you want with ` [InjectionConstructor]`. TODO: there's another way to OVERRIDE injection.

From [here](http://vincenthomedev.wordpress.com/2010/02/01/a-schematic-view-of-dependency-injection-in-unity-ioc/):
> When a target class contains more than one constructor, Unity will use the one that has the InjectionConstructor attribute applied. If there is more than one constructor, and none carries the InjectionConstructor attribute, Unity will use the constructor with the most parameters. If there is more than one such constructor (more than one of the “longest” with the same number of parameters), Unity will raise an exception.

Q: What does `BuildUp` do?

A: It resolves dependencies in the properties (and methods?) for the given instance. Good if you have the instance at hand (e.g., when it was created with the `new` operator or through `Activator`) but need to resolve other dependencies of the object.

Key methods are `RegisterType` and `RegisterInstance`.

```csharp
UnityContainer container = new UnityContainer();

container.RegisterType<ISomeInterface,SomeConcreteClass>();

var requiredObj = container.Resolve(ISomeInterface);
```

Read it as: when someone wants an  `ISomeInterface` give them a `SomeConcreteClass`.

Register instance will always resolve the requested object with the given instance. So:

```csharp
Calculator calc = new Calculator();
container.RegisterInstance<ICalculator>(calc);
```

whoever needs an `ICalculator` will be given the very `Calculator` instance created above.


Likewise ctor params can be moved to properties, but to have them resolved they must be decorated with `[Dependency]` attribute for automatic resolution.

To configure a property that is not marked as `[Dependency]` use `InjectionProperty` instance.

```csharp
container.RegisterType<IStockQuoteService, RandomStockQuoteService>(new InjectionProperty("Logger"));
```

which means `RandomStockQuoteService` has a property called `Logger` which needs to be injected.

Also the resolution can be specified (e.g., when there are more than one options available):

```csharp
container
    .RegisterType<ILogger, ConsoleLogger>()
    .RegisterType<ILogger, TraceSourceLogger>("UI")
    .RegisterInstance(new TraceSource("UI", SourceLevels.All))
    .RegisterType<StocksTickerPresenter>( 
        new InjectionProperty("Logger", 
            new ResolvedParameter<ILogger>("UI")));
```

Here `ILogger` had 2 candidates for resolution.



Moving configs to XML, or app config makes assemblies less dependent. Because when in code, you'll need the ref to assembly to resolve type name.
[think: Also it may help lazy assembly load]

If you want to register an interface with more than one classes, you must specify a name for each registration, so that unity can distinguish between them when one is required.

```csharp
container.RegisterType<ILogger, ConsoleLogger>();
container.RegisterType<ILogger, TraceSourceLogger>("UI");
```

We could also give the first registration a name.

To get a sequence of all the instances registered (not only one of them with the given name), use `ResolveAll`.

```csharp
var loggers = new List<ILogger>(
  container.ResolveAll<ILogger>());
```

In above, `loggers` will contain instances from both `ConsoleLogger` and `TraceSourceLogger` classes.

You can also inject the container itself (use `IUnityContainer` as the interface) (e.g., as the argument to ctor). I think no registration will be needed and unity will automatically resolve that.

```csharp
public class SomeClass {
    public SomeClass(IUnityContainer container) {
    ...
    }
}
```

If you may want to change `IUnityContainer` with another type of container (e.g., Ninject), use service locator instead of `IUnityContainer`. The interface is `IServiceLocator`. The ctor will be:

```csharp
public class SomeClass {
    public SomeClass(IServiceLocator serviceLocator) {
    ...
    // instead of Resolve use
    locator.GetInstance<ISomething>();
    // or instead of ResolveAll use
    locator.GetAllInstances<ISomething>();
    }
}
```

We need to register `IServiceLocator` after unity container has been created.

```csharp
UnityContainer container = new UnityContainer();
container.RegisterInstance<IServiceLocator>(
    UnityServiceLocatorAdapter(container));
```

The adapter wrapper is because `UnityContainer` does not implement `IServiceLocator`.

### Singleton (container controlled life-time manager)

`unityContainer.RegisterType<TheType>(new ContainerControlledLifetimeManager());` means that the injected object will be created once and will be disposed of with the container, hence it'll be a singleton.

### Semi-singleton (per-resolve life-time manager)

Taken from [here](http://www.sharpfellows.com/post/Unity-IoC-Container-.aspx) > section: Injecting the same object in multiple places in the object graph (semi-singleton)

`PerResolveLifetimeManager` within a single call to `Resolve<T>()` will create an instance of particular type and reuse it wherever required as the next sample illustrates:

```csharp
[TestFixture]
public class PerResolutionLifetimeTests
{
    [Test]
    public void Regiser_WithPerResolveLifetimeManager_ContainerInjectsSameInstance()
    {
        var container = new UnityContainer();
        container.RegisterType<IService, AService>(new PerResolveLifetimeManager());
        container.RegisterType<IParent, Parent>();
        container.RegisterType<IChild, Child>();

        var parent = container.Resolve<IParent>();

        Assert.AreSame(parent.Service, parent.Child.Service);
    }
}

public interface IService {}
public class AService : IService {}
public interface IChild
{
    IService Service { get; set; }
}

public class Child : IChild
{
    public IService Service { get; set; }

    public Child(IService service)
    {
        Service = service;
    }
}

public interface IParent
{
    IChild Child { get; set; }
    IService Service { get; set; }
}

public class Parent : IParent
{
    public IChild Child { get; set; }
    public IService Service { get; set; }

    public Parent(IChild child, IService service)
    {
        Child = child;
        Service = service;
    }
}
```




----

Great awesome video:
http://channel9.msdn.com/blogs/mtaulty/prism--silverlight-part-2-dependency-injection-with-unity