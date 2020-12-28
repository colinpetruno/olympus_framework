# Javascript (well TypeScript)

Meettrics follows an approach to use as little javascript as possible. In order
to have dynamic content on pages there is a small app that runs on the front 
end that provides various controls and utilities to enhance the applications.

### Typescript

Javascript is a bad programming language. Typescript will allow us to hopefully
catch the weird javascript errors better and provide higher overall code 
quality and easier testing.

### Global namespace

All the Meettrics javascript can be found within `window.Meettrics`


### Components 

Components allow the control of items utilized on multiple pages. Different
styles of forms input, navigation, graph refreshing etc can all be found in
the components function.

It will return the object that registers the components if there is nothing 
given, otherwise it will return the component you passed into it as a string
parameter.

`Meettrics.components();`
`Meettrics.components("navigation").toggleNavigation();`
`Meettrics.components().navigation().toggleNavigation();`


##### Navigation Component

This component is responsible for the navigation sidebar that pulls out from
the left. Through this component, you can toggle the navigation, see the status
of the navigation or set it to an explicit open or closed state.


#### Resources

What is webpack:
https://blog.capsens.eu/how-to-write-javascript-in-rails-6-webpacker-yarn-and-sprockets-cdf990387463
