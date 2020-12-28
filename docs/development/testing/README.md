# Testing

Testing is vital to ensuring that our app is functioning and maintainable long
term. We want testing around all the concious decisions and requirements. 
Additionally we want to ensure each bug is patched and tested to prevent 
regressions from ever happening. 

## Setup

## Running
```
bundle exec rspec spec/
```

## Not using a factory gem
The choice was made to intentionally not use a factory gem in our test suite.
`FactoryBot` is the leading one at the moment. While convienant, it makes 
exerting control over tests difficult. Slow factories are the common killer of
test speed. Gems that autobuild associations end up bootstrapping far more
data needlessly. Since we do test with the database this can crawl things to
a halt. 

The decision to not use it forces conscious choices onto the developer. Do you
want to persist with a create or can you get away with just building the 
record?

Bootstrapping a lot of data for a test is a good chance to spot that your 
classes are probably too big or have too much reach in into other models. 
Good class construction makes simple tests. Simple tests don't need a 
seed factory. 
