---
layout: page
title: "A JavaScript Primer"
comments: true
sharing: true
footer: true
---

Table of Contents:

* 
{:toc}


These are lessons learned when I tried to strengthen my JavaScript skills, by learning from these [Koans](/blog/2012/05/27/programming-koans-one-of-the-best-ways-to-learn-a-new-language-or-framework/):


1. JavaScript Koans by Liam McLennan, hosted on [GitHub](https://github.com/liammclennan/JavaScript-Koans)
2. JavaScript Koans by David Laing, again hosted on [GitHub](https://github.com/mrdavidlaing/javascript-koans)

I highly recommend learning from both of these Koans in the same order as specified above. The first one is easier to start with. While the second one is a smaller set of Koans, but gets more advanced, and contains an introduction to [Underscore.js](http://underscorejs.org/) as well.

I come from a C#, Java, and C++ background, so that it's probable that my terminology is not consistent with those used by the JavaScript community; particularly when it comes to object oriented concepts.

To test the code snippets here, you will need to host the JavaScript code within an html page, and open that page into your browser. A simple way is using the following template:

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <script language="javascript" type="text/javascript">
            // TODO: put other JavaScript codes here
            console.log("Hi");
        </script>
        <title>JavaScript Testing...</title>
    </head>
<body>
    <h1>Let's See...</h1>
</body>
</html>
```
    
The examples in this post make use of `console.log` function to print to the output. To view the results on the browser console do the following in each browser:


* Google Chrome (19.x and most probably others): Press F12, and go to the Console tab
* Mozilla Firefox (12.0 and most probably others): go to Firefox main menu > Web Developer > Web Console (Ctrl + Shift + K)
* Microsoft Internet Explorer (9): Press F12, and go to the Console tab

### Basic Concepts
**Comparison and Equality.** Comparison via `==` Considers equality, regardless of type.

Comparison via `===` checks identity, and types must match. Always use this syntax, if possible.

Corresponding inequality operators are: `!==` and `!===` . These are some examples of the behaviour of the equality operator:

```javascript
console.log(3 == "3");  // true: equality with type correction
console.log(3 === "3"); // false: equality without type correction
console.log(3 === 3);   // true
console.log(3 === 2+1); // true
```
    
More examples for odd behaviours of `==` operator. The result to all the examples below would be `false` if we use`===` instead of `==`:

```javascript
console.log(0 == false);  // true
console.log(true == 1);   // true
console.log(true == 5);   // *false*
console.log("" == false); // true
console.log("" == 0);     // true
```
    
Note that `NaN` (short for not a number) is never equal to itself! It must always be checked using the function `isNaN`.

Strings enclosed in single-quotes and double-quotes are the same. Note that in JavaScript there’s no such thing as character data-types.

```javascript
console.log("something" === 'something'); // true
```
    
**Global variables** are assigned to the `window` object:

```javascript
function() {
    temp = 1; // note that it does not start with `var`
    equals(temp, window.temp, 'global variables are assigned to the window object');
}
```
    
**Creating objects from anonymous types**:

```javascript
var person = {
    name: "John Doe",
    age: 27
};
```
 
**Enumerating properties of an object with the `for in` loop**:

```javascript
var person = {
    name: "John Doe",
    age: 27
};

var result = "";
// for in enumerates the property names of an object
for (property_name in person) {
    result = result + property_name + " ";
};
console.log(result); // name age
```
    
**Null coalescing operator**: The same as C#’s `??` operator, is logical OR `||` in Javascript. If the first argument (the one at left-hand-side of `||`) is null, it chooses the second argument (the one at the right-hand-side of `||`):

```javascript
var result = null || "a value";
console.log(result); // a value
```
    
See this wondoerful explanation [here](http://stackoverflow.com/a/476445/836432).

**Sinagle vs Double quoted strings.** They are the same and of the same type.

```javascript
console.log("str1" === 'str1'); // true
```

**tyepof**. It receives an object as an argument and returns its type (as opposed to C#, it does not need the type-name as the argument).


```javascript
typeof(2) -> number
typeof(2.0) -> number
typeof("Hi") -> string
typeof('Hi') -> string
typeof('H') -> string
typeof("Hi".charAt(0)) -> string
typeof(false)-> boolean
typeof(null) -> object
```

As you see, there’s no such thing as character type, they’re all strings.

The type informations are also strings:

```javascript
typeof(typeof(2.0)) -> string
```

**How to include unicode chars in a string.**

```javascript
var stringWithAnEscapedCharacter  = "\u0041pple";
```

**The string `slice` method.** returns a substring of the given string. This is the syntax of the method [[+](http://www.w3schools.com/jsref/jsref_slice_string.asp)]:`string.slice(start,end)`.


* `start`: Required. The index where to begin the extraction.
* `end`: Optional. The index (up to, but not including) where to end the extraction, If omitted, slice() selects all characters from the start-position to the end of the string.

**NaN** (short for not a number) is the result of failed arithmatic operations. Two NaN objects are not equal to each other, always use the `isNaN` function to check.

```javascript
var resultOfFailedOperations = 7/'apple';
console.log(isNaN(resultOfFailedOperations)); // true
console.log(resultOfFailedOperations == NaN); // false
```

### Objects
Empty objects (no properties, no methods): `var empty_obj = {};`

Objects can have properties in definition:

```javascript
var myObject = {
    name: "John Doe",
    age: 28
}; 
```

Or properties can be added later:

```javascript
var myObject = {};
myObject.name = "John Doe";
myObject.age = 29;
```

Properties can be added from strings dynamically:

```javascript
var myObject = {};
myObject["name"] = "John Doe";
myObject["age"] = 28;
```

Objects can have methods, and fields can be accessed via the `this` qualifier:

```javascript
var myObject = {
    name: "John Doe",
    age: 28,
    toString: function() {
        return "I'm " + this.name + ".";
    }
}
```

Properties can be accessed by their name in the code, as in: `myObject.name` or accessed from a string at run-time, as in: `myObject["name"]`.

### Arrays

Arrays can contain objects from different types:

```javascript
var favouriteThings = ["cellar door", 42, true]; 
// array elements do not have to be of the same type
// elements are referenced by [] indexer
// favouriteThings[1] -> 42
// array type is "object"
// typeof(favouriteThings) -> "object"
// the length is accessed via .length property
```

Creating arrays with a predefined length:

```javascript
var arr = new Array(10);
console.log(arr.length); // 10
console.log(arr); // [undefined × 10]
```

Or one can explicitly assign to the `array.length` property. Note that if the new value is less than the original array size, the trailing elements will be removed:

```javascript
var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
arr.length = 5;
console.log(arr.length); // 5
console.log(arr); // [1, 2, 3, 4, 5] 
```

**Note:** The `for in` loop in arrays, iterates through the indices only, not the values.

**Arrays are passed to functions by reference.** Therefore any change to the passed array in the body of the function will modify the original array too. Also when assignments are done, the reference to tha array is assigned, hence this also has the risk of modifying the original array:

```javascript
var arr = [0, 1, 2, 3, 4, 5];
function changeArray(someArray) {
    someArray[1] = 10;
}
changeArray(arr);
console.log(arr.toString()); // [0, 10, 2, 3, 4, 5]
var anotherArr = arr;
anotherArr[4] = 40;
console.log(arr.toString()); // [0, 10, 2, 3, 40, 5]
```

You can create a copy of an array using `arr.slice()`.

**Array `join` method** creates a string by concatenating all array members using the provided separator:

```javascript
var arr = [1, 2, false, 4.5, "hi"];
console.log(arr.join(","));
// 1,2,false,4.5,hi
```

**Array `slice` method.** Returns the sub-array of a given array, from the first index inclusive, to the second index exclusive; or returns an empty array if the provided indices do not match a valid range within the provided array:


```javascript
var arr = [0, 1, 2, 3, 4, 5];
var sub = arr.slice(2, 4);
// [2, 3]
```


The `slice` function, when called without arguments creates a copy of the array. Changing the copied arrays elements will not affect the original array’s contents.

```javascript
var copyOfArr = arr.slice();
```

**Array `splice` method.** The `splice` method adds/removes items to/from an array, and returns the removed item(s) if any [[+](http://www.w3schools.com/jsref/jsref_splice.asp)].

Syntax: `array.splice(index,howmany,item1,.....,itemX)`

Parameter Values:

* `index`: Required. An integer that specifies at what position to add/remove items, Use negative values to specify the position from the end of the array
* `howmany`: Required. The number of items to be removed. If set to 0, no items will be removed
* `item1, ..., itemX`: Optional. The new item(s) to be added to the array

Return Value:

Type: Array; A new array containing the removed items, if any

This is a demo of `splice`. Note that, only when we remove items from an array, the method returns the removed items.


```javascript
var array1 = [];
console.log("Empty Array:\n" + array1.toString());

var array2 = [1, 2, 3, 4];
console.log("Array2:\n" + array2.toString());

var array3 = array2.splice(2, 0, 2.25, 2.5, 2.75);
console.log("array2 after additive splice():\n" + array2.toString());
console.log("returned array from additive splice():\n" + array3.toString());

var array4 = array2.splice(2, 3);
console.log("array2 after deductive splice()\n" + array2);
console.log("returned array from deductive splice()\n" + array4);

//Empty Array:
// 
//Array2:
//1,2,3,4 
//array2 after additive splice():
//1,2,2.25,2.5,2.75,3,4 
//returned array from additive splice():
// 
//array2 after deductive splice()
//1,2,3,4 
//returned array from deductive splice()
//2.25,2.5,2.75
```

**Array stack methods: `push` and `pop`.** Javascript arrays have `push` and `pop` methods. `push` inserts at the end of an array, and `pop` removes from the end of an array. The `push` function can receive more than 1 argument to add to the end of an array.

**Array `unshift` and `shift` methods.** The `unshift` method inserts one or more items at the beginning of an array, while `shift` removes one item from the beginning of an array [[+](http://www.w3schools.com/jsref/jsref_unshift.asp), [+](http://www.w3schools.com/jsref/jsref_shift.asp)].


### Functions

This is the way a named function can be defined in JavaScript:


```javascript
function fname() {
    // body
}
```

But the following syntax, is assigning a variable to an anonymous function:

```javascript
var fn = function() {
    // body
};
```

and as seen above we receive a warning if we don’t put a semicolon after the closing brace. That’s because it is just an assignment statement, but a little bit fatter.

Invokation of both is the same: `fn()`, and `fname()`.

```javascript
typeof(fn) -> "function"
typeof(fname) -> "function"
```

The `toString` method of each function returns the signature and the body of a function as well as its comments. See the result of `fn.toString()` or `fname.toString()` to get amazed.

**The `Function` object.** An alternative way to defining functions is creating an object from `Function`, and providing all the details in arguments as strings, e.g.:

```javascript
var add = new Function("a", "b", "return a + b;");
console.log(add(1, 2)); // 3
```

**Functions can return functions.** See this nice example from [JavaScript Koans by David Laing](https://github.com/mrdavidlaing/javascript-koans):


```javascript
function makeIncreaseByFunction(increaseByAmount) {
    var increaseByFunction = function increaseBy(numberToIncrease) {
        return numberToIncrease + increaseByAmount;
    };
    return increaseByFunction;
}
var increaseBy3 = makeIncreaseByFunction(3);
var increaseBy5 = makeIncreaseByFunction(5);
console.log(increaseBy3(10) + increaseBy5(10)); // 28;
```

### Reflection

Properties of an object can be accessed at run-time via the `for in` loop. This function, prints the properties of an object as well as their values:

```javascript
function printProps(obj) {
    console.log("{");
    for (var propName in obj) {
        console.log(propName + ": " + obj[propName]);
    }
    console.log("}");
}
```

The `in` keyword, when not used along with the `for` loop, can be used to check whether an object has a specific property with the given name:

```javascript
var obj = { name: "John", age: 29 };
var hasName = "name" in obj;     // true
var hasFamily = "family" in obj; // false
```

**Object Constructor functions**: A function with a typical signature, but used for initializing objects. These functions usually assign fields using the `this` qualifier. Note that after each assignment, the specified field will be created, it doesn’t need to be declared beforehand:

```javascript
function fnObject() {
    this.name = "John";
    this.age = 23;
}
```
    
The above code can be regarded as the constructor of an object, with 2 fields namely `name`, and `age`. This is how we can instantiate this object with the `new` keyword:

```javascript
var obj = new fnObject();
```

You can add properties at runtime to an instantiated object, not the class/prototype, via this syntax:`obj["newprop"] = "newvalue";`

**How to add properties to a class/object prototype?** Via the `prototype` chain. E.g., to add a property to the`fnObject` statically (namely `weight`) use the following syntax. The property will be added to all instances of the class:

```javascript
fnObject.prototype.weight = 75.0;
```

To do the same job dynamically use the following syntax:

```javascript
fnObject.prototype["weight"] = 75.0;
```

To add a set of properties which currently exist in another class, simply set the `prototype` property with a new instance of that class. For example:

```javascript
function fnObj2() {
    this.salary = 20.0;
    this.eyeColor = "Brown";
}

fnObject.prototype = new fnObj2();
```

Then objects from `fnObject` will have the following properties: `{name, age, salary, eyeColor}`. This reminds us of inheritance.

As another example, take a look at this piece of code from [JavaScript Koans by David Laing](https://github.com/mrdavidlaing/javascript-koans), that demonstrates attaching a function to an object vs to a class (or object prototype):

```javascript
function Circle(radius)
{
    this.radius = radius;
}
var simpleCircle = new Circle(10);
var colouredCircle = new Circle(5);
colouredCircle.colour = "red";
console.log(simpleCircle.colour); //undefined
console.log(colouredCircle.colour); // red
Circle.prototype.describe = function () {
    return "This circle has a radius of: " + this.radius;
};
console.log(simpleCircle.describe());
// This circle has a radius of: 10
console.log(colouredCircle.describe()); 
// This circle has a radius of: 5
```

**How to tell which property belongs to the orignial class of the object, and which one has been added through the prototype chain?** This can be checked with the `hasOwnProperty` method of the object. For example:

```javascript
var obj2 = new fnObj2(); // as defined above
obj2.hasOwnProperty("name") // -> true
obj2.hasOwnProperty("salary") // -> false
```

**The `eval()` method.** Runs the JavaScript code, that is stored in a string:

```javascript
var result = "";
eval("result = 'apple' + ' ' + 'pie'");
// result equals "apple pie" after eval
```

### Inheritance and Prototype Chain

Many of the materials in this section are taken form [[+](https://developer.mozilla.org/en/JavaScript/Guide/Inheritance_and_the_prototype_chain)] (a must read):

> A “constructor” in JavaScript is “just” a function that happens to be called with the new operator.


**`Object.create` method.** Calling this method creates a new object. The prototype of this object is the first argument of the function.

This is an example:

```javascript
var father = {
  b: 3,
  c: 4
};

var child = Object.create(father);
child.a = 1;
child.b = 2;

// child has properties "a", and "b" as its own
// child.prototype <- father
// child has properties "c", and (shadowed) "b"
// from its prototype i.e., not its own
```

**Property Shadowing.** Is something like method overriding. For example in the code above, property `b` from object `child`, hides the effect of property `b` from object `father`. This is called shadowing.

**Removing a property from an object** can be achieved by calling `delete`. For example removing property `b`from object `child` is accomplished by calling:

```javascript
delete child.b;
```

Doing this would neutralize the shadowing effect, and the `child.b` property would be that of its prototype, not of its own.

**The `call` method** calls a method from an object, but with a different `this` provided. This is the syntax (many parts taken from [[+](https://developer.mozilla.org/en/JavaScript/Guide/Inheritance_Revisited)]):

```javascript
FuncToCall.call(theNewThis, arg1, arg2, ...);
```

Consider this example (adapted from reference above):

```javascript
var animals = [
  {species: 'Lion', name: 'King'},
  {species: 'Whale', name: 'Fail'}
];

for (var i = 0; i < animals.length; i++) {
  (function(i) {
      console.log('#' + i + ' ' + this.species + ': ' + this.name);
  }).call(animals[i], i);
}
```

It defines a dynamic function which prints information from `this.species` and `this.name`. It then calls the function replacing `this` with each array item.

Another usage for `call` is chaining constructors (as in `C#` or `Java` we can call other constructors to do the initialization and then we do the rest). This is an example (again taken from reference above):

```javascript
function Product(name, price) {
  this.name = name;
  this.price = price;

  if (price < 0)
    throw RangeError('Cannot create product "' + name +
         '" with a negative price');
  return this;
}

function Food(name, price) {
  Product.call(this, name, price);
  this.category = 'food';
}
```
    
In the above example we reused construction logic of `Product` for `Food` and continued further. However this technique emulates inheritance too. To make it look like a real inheritance we set `Product` as the prototype for`Food`:

```javascript
Food.prototype = new Product();
```
    
Since functions such as `call` and `apply`, allow you to set the callers `this` context, you should not expect any more that `this` is a user-defined type; `this` can be anything, a `string`, or even a `numeric`:

```javascript
var invokee = function( message ){
    return this + message;    
};

var result = invokee.call("I am this! ", "Where did it come from?");
console.log(result);
// "I am this! Where did it come from?
```
    
See also this nice example taken from [JavaScript Koans by Liam McLennan](https://github.com/liammclennan/JavaScript-Koans):

```javascript
var person = {
    handle: 'bob',
    intro: function () {
        return "Hello, my name is " + this.handle;
    } 
}

// calling a function with 'call' lets us assign 'this' explicitly
var message = person.intro.call({handle: "Frank"});
```
    
**The `apply` method** operates just like `call`, except that it sends the arguments to the invokee function through an array:

```javascript
var invokeeFunc = function( a, b ) {
    return this + a + b;
};
// using apply
var sum1 = invokeeFunc.apply(1, [2, 3]);
// using call
var sum2 = invokeeFunc.call(1, 2, 3);
// sum1 == sum2 == 6
```    

### Emulating maps with objects
One can define objects to have a map functionality, e.g.,

```javascript
var map1 = { 0: "Zero", 2: "Two" };
console.log(map1[0]); // zero
console.log(map1[2]); // two
console.log(map1[1]); // undefined

var map2 = { "zero": 0, "two": 2 };
console.log(map2["zero"]); // 0
console.log(map2["two"]); // 2
console.log(map2["one"]); // undefined
```    

### Self-invoking functions

This is how we can define and call a function in one statement:

```javascript
//(func_definition)(func_arguments);
var theMessage = "Hello World!";
(
    function(msg) { console.log(msg); }
)(theMessage);
```    

### The arguments map

Every function, whether having defined a set of arguments or not, will have access to the arguments passed to it, through the `arguments` map. The `arguments` map, maps the argument index to its value, and has a `length`property:

```javascript
var add = function() {
    var total = 0;
    for(var i = 0; i < arguments.length; i++) {
        total += arguments[i];
    }
    return total;
};
```
    
In JavaScript, you can pass any arguments of any type, and any number, to any function (no need to match the number of arguments with the parameters list). You can always access them through the `arguments` map.

### Regular Expressions

In JavaScript, regular expressions are objects instantiated from `RegExp`. However, one can create regular expression objects easily with syntactic sugars integrated into the language. Using them, regular expression objects are a special kind of string which are delimited within two slashes `/pattern/` instead of quotation marks, reminding unix style regular expression search programs and commands.

```javascript
var regex = /\d+/;
```    

This has the benefit that the programmer does not need to escape the backslash characters in the pattern (something like at-quoted strings in C#). For example the equivalant object for the above pattern is:

```javascript
var regex = new Regexp("\\d+");
```
    
Besides the pattern, one can make use of flags or modifiers which modify the behaviour of the regular expression engine [[+](http://www.w3schools.com/jsref/jsref_obj_regexp.asp)]:


* `i`: Perform case-insensitive matching
* `g`: Perform a global match (find all matches rather than stopping after the first match)
* `m`: Perform multiline matching

These flags can come after the closing slash of the pattern, or inside a string as the second argument to the `RegExp`constructor. For example the following defines a regular expression pattern that is going to find all of its matches within a given string case-insensitively:

```javascript
// words beginning and ending in "a" or "A"
var regex = /a\w*a/gi;
// ... or ...
var regex = new Regexp("a\\w*a", "gi");
```

**The `exec` method** returns the matches of the whole regular expression as well as its groups. For example the following regular expression for matching words starting and ending with the character “a” returns also the “a” characters themselves, because they have been defined within a group (i.e., inside parantheses). Note that upon calling it returns only the first match, if any:

```javascript
var regexp = /(a)\w*(a)/;
var results = regexp.exec("1. ABA 2. aba 3. aca!");
if(results != null) {
    console.log("index: " + results.index + " found [" + results + "]");
} else {
    console.log("Not found!");
}
// index: 10 found [aba,a,a] 
```
    
To find all the matches, we have to carry out these two steps: 1) add the `g` (global) flag to the regular expression pattern. 2) call `exec` iteratively until it returns null. Note that without adding the `g` flag, the second step will be trapped within an infinite loop. The following example looks for all words (hence the `g` flag) beginning and ending in the letter “a”, case-insensitively (hence the `i` flag):

```javascript
var regexp = /(a)\w*(a)/ig;
var input = "1. ABA 2. aba 3. aca!";
var results = regexp.exec(input);
while(results != null) {
    console.log("index: " + results.index + " found [" + results + "]");
    results = regexp.exec(input);
} 
// index: 3 found [ABA,A,A]
// index: 10 found [aba,a,a]
// index: 17 found [aca,a,a] 
```

**The `test` method** tests whether a string contains a pattern:

```javascript
var doesItContain = /ye(s|ah)/.test("He said: yeah!");
console.log(doesItContain); // true
```

**The string `match` method** returns the match(es) of the specified regular expression within the caller string:

```javascript
var matches = "1. ABA 2. aba 3. aca!".match(/(a)\w*(a)/ig);
console.log(matches);
//["ABA", "aba", "aca"] 
```

**The string `replace` method** replaces the instances of the found pattern within the given input string and returns the new string:

```javascript
var result = "1. ABA 2. aba 3. aca!".replace(/(a)\w*(a)/, "oops");
console.log(result); // 1. ABA 2. oops 3. aca! 
// add "ig" flags -> case-insensitive global replace
result = "1. ABA 2. aba 3. aca!".replace(/(a)\w*(a)/ig, "oops");
console.log(result); // 1. oops 2. oops 3. oops! 
```

One of the beauties of the `replace` method is that it can receive a function as the second argument, so that we can decide dynamically on what to replace with each single instance of the found pattern:

```javascript
var result = "1. ABA 2. aba 3. aca!".replace(/(a)\w*(a)/ig, function (found) {
    if (found[0] == "A") {
        return "OOOPSS";
    } else if (found[1] == "b") {
        return "oobs";
    } else {
        return "oocs";
    }
});
console.log(result); // 1. OOOPSS 2. oobs 3. oocs!
```

### The 'use strict' statement

TL;DR. It prevents some bad usages of the language. Here's a [summary](http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/).

This is the [Source](http://stackoverflow.com/questions/1335851/what-does-use-strict-do-in-javascript-and-what-is-the-reasoning-behind-it).

> Strict Mode is a new feature in ECMAScript 5 that allows you to place a program, or a function, in a "strict" operating context. This strict context prevents certain actions from being taken and throws more exceptions.

And:

> Strict mode helps out in a couple ways:
> * It catches some common coding bloopers, throwing exceptions.
> * It prevents, or throws errors, when relatively "unsafe" actions are taken (such as gaining access to the global object).
> * It disables features that are confusing or poorly thought out.

Usage:

```javascript
// Non-strict code...

(function(){
  "use strict";

  // Define your library strictly...
})();

// Non-strict code... 
```

