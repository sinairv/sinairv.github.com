---
layout: page
title: "Android Notes"
comments: true
sharing: true
footer: true
---
# Android Notes

`Activity` corresponds to `Form`

`View` corresponds to `Control`

`ViewGroup` corresponds to `Container` controls

`Fragment` corresponds to User Controls.

## Create a fragment

API level >= 11: create a class and inherit it from `android.app.Fragment`.

API lvels 4 - 10: create a class and inherit it from `android.support.v4.app.Fragment` and fragments should go into `Fragment Activity` (? needs more investigation)

Then override `onCreate` and `onCreateView` methods. Do the initializations in `onCreate`, things like reading from resources and storing them in local variables. Use `onCreateView` to inflate your UI from its XML definition:

```java
@Override
public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
  View theView = inflater.inflate(R.layout.my_fragment, container, false);
  // the third argument should be false, the framework will later attach the inflated fragment
  return theView;
}
```

Note that `Fragment` is not a `View`. However, in `onCreateView` method we use `inflater` to create a `View` corresponding to the `Fragment`. 

You can also override `onActivityCreated` method which is called after the containing activity is created.

`getActivity()` returns a reference to the `FragmentActivity` instance containing the fragment.

## How to find a (child) view from another (parent) view, by its ID?

Imagine that our child `View` is a `TextView`:

```java
TextView txt = (TextView) theParentView.findViewById(R.id.childTextView);
```

Note that `Fragment` is not a `View` so inside a `Fragment` one cannot call `this.findViewById`. However, in `onCreateView` method we used `inflater` to create a `View` corresponding to the `Fragment`. One can use that instance for this purpose.

## SrollView

[`ScrollView`](http://developer.android.com/reference/android/widget/ScrollView.html) must have one child, usually another container such as `LinearLayout`. Do not use `TextView` and `ListView` as its only child. They will take care of their own scrolling and also it will neutralize their internal performance optimizations.

`ScrollView` is a `FrameLayout` (containers with usually 1 child), which is in turn a `ViewGroup` (i.e., container control).

## Value Resources

Under project structure there's a folder structure `res/values` which contains XML files. The name of the XML files does not seem to matter (TODO: make sure). They must be standard XML files with root element named `resources`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
...
</resources>
```

It seems one can have as many files in this folder as they wish, with arbitrary names. Each file can contain any mixture of resources, although it seems to be a good practice that each file contain one type of resources. IntelliJ Idea's code completion helps to find out possible resource types, which seem to be:
`item`, `array`, `attr`, `bool`, `color`, `declare-stylable`, `dimen`, `drawable`, `eat-comment`, `fraction`, `integer`, `interger-array`, `plurals`, `string`, `string-array`, and `style`.

`string` resources, must have an attribute called `name`, and a value, and that's it:

```xml
<string name="person1">Tom Cruise</string>
```

The value of the resource can be retrieved in code like this:

```java
String person1Name = getResources().getString(R.string.person1);
```

`R.string.person1` is an auto-generated unique integer, that behaves like ID of the resource. It is NOT the value of the resource.

A string array resource, is an element named `string-array`, has an attribute called `name`, and child elements called `item`:

```xml
<string-array name="countries">
  <item>Australia</item>
  <item>Iran</item>
  <item>US</item>
  <item>Canada</item>
</string-array>
```

It can contain references to other resources. The syntax for referring to another resource is `@[resourcetype]/[resourcename]`:

```xml
<string name="person1">Tom Cruise</string>
<string name="person2">Jodie Foster</string>
<string name="person3">Steven Hopkins</string>
<string name="person4">Lana Del Rey</string>

<string-array name="people">
  <item>@string/person1</item>
  <item>@string/person2</item>
  <item>@string/person3</item>
  <item>@string/person4</item>
</string-array>
```

It can be retrieved in code as in:

```java
String[] people = getResources().getStringArray(R.array.people);
```

These are possible identifiers after `R.`, as shown by IntelliJ Idea's code completion: `array`, `drawable`, `id`, `layout`, `string`

## Add a fragment to an activity

```xml
<fragment android:layout_width="fill_parent"
          android:layout_height="wrap_content"
          android:name="com.sinairv.FragmentsTest01.MyFragment"
          android:id="@+id/fragment"/>
```

I had to use `fragment` with small f, for the element name while my `Fragment` class is an Android support fragment. I'm not sure if this is true for the Android built-in fragments or not.

Also in order to be able to add an instance of the fragment to the activity, I had to change the activity base class from `Activity` to `FragmentActivity` from Android support library.

## How to add support libraries to your project in IntelliJ Idea

You'll need to copy the jar files locally to your project structure.

See: http://www.in-nomine.org/2012/02/26/adding-android-support-v4-to-your-android-application-in-intellij-idea/

