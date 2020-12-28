# Aphrodite - Styles

Aphrodite is our style framework. As a developer, you should have rich access 
to quickly implement any UI element our site uses. You should be able to 
layout a page with the specified style elements and have it look pretty good 
without much customization (ideally none). 


### Styleguide

You can preview the styleguide at [localhost:3000/styleguide](localhost:3000/styleguide) 
in development mode. That will give you all the info you need. 

### Responsibilities

Wisp is responsible for colors, styles, layout, and any fancy JS components 
like datepickers. Wisp styleguide can directly be tested for functionality of
the components. Datepickers are ensured that they can be toggled and change 
and trigger proper callbacks. That leaves only app logic to test in our unit
tests. It also provides some nice examples of how to test those components if
we run into it with a capybara test.

### Architecture

Wisp relies on stimulus to add progress enhancement onto the input fields. At
this point in time I think it's safe to say everyone is going to have Javascript
and we don't need to be concerned with people that have JS disabled. We should
add a check though perhaps to ensure that JS is enabled so they don't have
broken functionality (think about bots though).
