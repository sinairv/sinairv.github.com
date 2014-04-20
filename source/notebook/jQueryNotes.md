---
layout: page
title: "jQuery Tips"
comments: true
sharing: true
footer: true
---
### Ready event

```javascript
$(document).ready(function {
    // code here will execute after DOM is ready
})
// ... or ... 
// this is short for `ready` function
$(function () {
    // code here will execute after DOM is ready
});
```

**`ready` vs `window.onload`**: The ready event occurs after the HTML document has been loaded, while the onload event occurs later, when all content (e.g. images) also has been loaded.

The onload event is a standard event in the DOM, while the ready event is specific to jQuery. The purpose of the ready event is that it should occur as early as possible after the document has loaded, so that code that adds funcionality to the elements in the page doesn't have to wait for all content to load [[+](http://stackoverflow.com/a/3698214/836432)].	

### Attribute selectors
Taken from [[+](http://www.slideshare.net/apnerve/jquery-essentials-selectors)]: Selecting an `input` element which has a `name` attribute with value of `funny`:

```javascript
$("input[name='funny']");
```

This is what is selected:

```html
<input name="funny" type="text" value="alarm" />
```

### Each
jQuery's each method

jQuery provides a generic each-function to iterate over properties of objects, as well as elements of arrays:

```javascript
jQuery.each(obj, function(key, value) {
    console.log("key", key, "value", value);
});
```

This is my demo:

```javascript
var arr = [1, 2, 3, 4];
iter(arr);

var o = { name: "John", value: "Doe", age: 127,
  doSth: function () { console.log("Sth"); } 
};
iter(o);

function iter(obj) {
  $.each(obj, function (k, v) {
      console.log(k + " -> " + v);
  });
}
```

**Note:** In jQuery we have Array<String> or these kinds of generics.
	
### Misc

The following searches even-indexed table rows within the table with the given id:

    var $table = $('#CustomersTable');
    $('tr:even', $table).doSomething();

On the other hand the following:

	$("<li />", { "text": "Hi" }).appendTo($("#sth"));​​​​​​

creates `<li>Hi</li>` and appends to an element with id of `sth`. It seems that one can pass the properties to be set in a separate object as the second argument.

If we want to look for several items we have to separate them with comma *inside* the string:

	$("#sth, #anotherthing, .someClass");

The existence of comma and the placement of selectors in string is very important, for example the following selects all `li`s which are descendants to `ul`s, not both of them:
	
	$("ul li");

See these examples from [[+](http://www.slideshare.net/apnerve/jquery-essentials-selectors)] and [[+](http://api.jquery.com/category/selectors/)]:

	$("*"); // all selector: selects all elements
	$("prev next"); // descendant selector
	$("prev > next"); // child selector
    // Selects all next elements matching "next"
	// that are immediately preceded by a sibling "prev"
	$("prev + next"); // next adjacent selector
	$("prev ~ next"); // next sibling selector
	// Selects all sibling elements that follow 
	// after the "prev" element, have the same parent, 
	// and match the filtering "siblings" selector.

The notable difference between `(prev + next)` and `(prev ~ siblings)` is their respective reach. While the former reaches only to the immediately following sibling element, the latter extends that reach to all following sibling elements.


	$("prev next:first"); // first element in a result-set
	$("prev next:first-child"); // first child of a parent
	// returns one per parent

While `:first` matches only a single element, the `:first-child` selector can match more than one: one for each parent. `:first` is equivalent to `:nth-child(1).`

	<prev>
		<next>...</next> // :first and :first-child
		<next>...</next>
		<next>...</next>
	</prev>
	<prev>
		<next>...</next> // :first-child only (not :first)
		<next>...</next>
		<next>...</next>
	</prev>

	$("prev next:last"); // last element in a result-set
	$("prev next:last-child"); // last element of a parent, 
	// returns 1 per parnet

`:contains` selector, works on values:

	$("li:contains('sth')");
	// selects ...
	<li class="someClass">sth</li>

`:has()` selector:
	
	$("div:has(p)") // selects all `div`s which have `p`s inside


There's a `hover` event in jQuery which seems to be fired on both `mouseenter` and `mouseleave`, therefore one must have a same code for the handler.

For `fadeIn` and `fadeOut` and other animations which might happen sequentally, one can stop previous animations whith `.stop` function:

	$("#sth").stop();
	$("#sth).fadeOut(500);

One can chin stop and next functions; however they don't seem to lead to same results. Therefore I recommend them in separate statements as above. See this fiddler for an example: http://jsfiddle.net/sinairv/SEwfG/29/


`PrependTo` adds some text or html at the beginning of an element, and returns the thing which is being prepended [[+](http://api.jquery.com/prependTo/)]:

	var result = $("<strong>I'm bold!</strong>").prependTo($("p#par1"));
	// result: ["<strong>I'm bold!</strong>"]
	

`find` Get the descendants of each element in the current set of matched elements, filtered by a selector, jQuery object, or element. [[+](http://api.jquery.com/find/)]

`empty` Remove all child nodes of the set of matched elements from the DOM: [[+](http://api.jquery.com/empty/)]

`serializeArray`  Encode a set of form elements as an array of names and values [[+](http://api.jquery.com/serializeArray/)]

`jQuery.fn === jQuery.prototype`

`jQuery.extend( target [, object1] [, objectN] )` Returns: Object   
Description: Merge the contents of two or more objects together into the first object [[+](http://api.jquery.com/jQuery.extend/)].


Multiple handlers for a single event:

 	$("#datarows").on("click", ".drow", function() {
        alert($(this).text());                    
    });
    
    $("#datarows").on("click", ".drow", function() {
        alert("This is just some dummy row added to test jQuery event delegation!");
    });

There are two `onClick` event handlers added to the childs of an element with id `datarows` which have css class `drow`. When clicking on them two subsequent message-boxes will be shown.

Good example of `mouseenter` and `mouseleave` events:

	<!DOCTYPE html>
	<html>
	<head>
	  <style>
	.test { color: #000; padding: .5em; border: 1px solid #444; }
	.active { color: #900;}
	.inside { background-color: aqua; }
	</style>
	  <script src="http://code.jquery.com/jquery-latest.js"></script>
	</head>
	<body>
	  <div class="test">test div</div>
	<script>$("div.test").on({
	  click: function(){
	    $(this).toggleClass("active");
	  },
	  mouseenter: function(){
	    $(this).addClass("inside");
	  },
	  mouseleave: function(){
	    $(this).removeClass("inside");
	  }
	});</script>
	
	</body>
	</html>

Want to define an event for elements which may be added dynamically later? Do it through delegating events, e.g., you want to assign a `click` event on every paragraph which might be added later, do this [[+](http://api.jquery.com/on/)]:


	$("body").on("click", "p", function(){
      // do something
    });

This will be bound to any `p` inside `body`, regardless of the time it is created, because:

> the event is handled by the ever-present body element after it bubbles to there.

Example: Cancel a link's default action using the preventDefault method.

	$("body").on("click", "a", function(event){
	  event.preventDefault();
	});

	
The `blur` event is sent to an element when it loses focus.

`stop`: Stop the currently-running animation on the matched elements.

`fadein`: Display the matched elements by fading them to opaque.

`fadeout`: Hide the matched elements by fading them to transparent.

Check for a check-box's `checked` property not its attribute 
[[+](http://jsfiddle.net/johnpapa/kPL8w/light/)]:

	$("#chk").prop('checked');

## Refs

[1] http://docs.jquery.com/Types

### JS

`location.href`: address to the current location

### HTML

#### `fieldset` and `legend`: 

The `<fieldset>` tag is used to group related elements in a form.  
The `<fieldset>` tag draws a box around the related elements.  
Tip: The `<legend>` tag defines a caption for the `<fieldset>` element.

#### `name` vs `id`
See here [[+](http://stackoverflow.com/q/1397592/836432)]: 
The name is used when sending data in a form submission. Different controls respond differently. For example, you may have several radio buttons with different ids, but the same name. When submitted, there is just the one value in the response - the radio button you selected. Of course, there's more to it than that, but it will definitely get you thinking in the right direction.

Use name attributes for `<form>` elements, as that's the identifier used in the POST or GET call that happens on form submission.

Use id attributes whenever you need to address a particular element with CSS or JavaScript. It's possible to look up elements by name, too, but it's more efficient to look them up by ID.

#### Label's `for` attribute [[+](http://www.w3schools.com/tags/att_label_for.asp)]

#### Span's `title` attribute, makes a tooltip for that span
