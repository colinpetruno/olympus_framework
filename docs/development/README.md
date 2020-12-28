# Development guide

## Naming Scheme
Our naming conventions are derrived from mythology. The goal is to be able to
easily determine what we are talking about even if you have no idea what it is.
Our core technologies are named after Gods, infrastructure and servers are 
named after places, and objects or tools are named after things.

## Driving motivations
Our goal is to be able to develop products fast and at high quality. We are
building this to be maintained with as little time as possible. 

- Priortize stability over speed
- Priortize support and infrastructure over cutting edge
- Priortize user experience over dev experience 
- Priortize being independent over utilizing vendors<sup>†</sup>
- Priortize long term over short term
- Prioritize problem solving over brute force
- Prioritize privacy

<small><sup>†</sup> Particulary if there is no open source migration path. We 
do not want to get locked into vendors increasing prices with no option to 
bail.</small>

### Stability
Developing for stablity is more work than developing for completion. Our 
systems should self audit their data and correct discrepencies where possible
automatically. When this is not possible our systems should alert us. We do
not want to have to actively monitor anything and want to spend as little time
as possible keeping our services running. This starts in the planning phase
before a line of code is ever written. We don't load up the first gem we see,
we try to avoid an endless amount of JS libraries. Simple systems are stable 
systems and we build our complex systems as a ccombination of simple systems
done corectly. 

### Support & Infrastructure
We are not tech chasers. Our core framework is Rails. This is proven and solid
tech that aligns with our value of developing products quickly. A good sized
community and support is important to ensure that the tech we choose is around 
for many years to come. The worst thing is we would choose a piece of tech and
end up having to become the maintainer if we want to continue to use it. While
this may happen over time, we should accept that risk up front for cutting 
edge tech. If we can't say "we are willing to maintain this" if it doesn't 
stick then we should not choose that tech. 

### User experience
User experience comes first. Don't cut corners as a dev that will hurt user 
experience. We want to ensure that every i is dotted and t is crossed for them.

### Long term 
Our core framework Rails has been out for 15 years when we choose this 
framework. We plan to make sure it's in use for the next 40 at least. This 
plays into things like vendor selection. New start up vendors can be tempting.
But if they haven't been around 5 years how do we have any confidence that
they will exist in the next 10? Also we want to avoid the price baiting. Early
startups will eat cost to get you to sign. When the end of their runway starts
to become visible they raise up prices substantially creating unexpected cost
increases. We might get a nice discount over established players for a year or
two but the price gap is always going to close.

### Independent
Cloud costs and services are out of control. Everyone is selling a bunch of 
crap that we need all these services to run our business. The reality is most
dev teams spend so much time integrating these services they forget about their
product. Minimizing external services helps us maintain focus on our products.

Tools won't solve our problems. If we don't know how to solve the issue we face
no tool is going to fix that. If our ticketing isn't working well, a different
ticketing system isn't going to be some silver bullet, we need to work on our
communication. 

We don't want lock in. AWS, GCP, Azure etc are all rolling out services to get
you locked in. We want to ensure any service we use has an easy open source 
migration path and not put us in a position where we get "pinched" by external
parties. For services that we do not want to accept the liability of 
maintaining we should seek services that have multiple similar alternatives. 

### Problem solving
Theres a wall with a sledgehammer next to it. Your task is to knock it down. 
Most people are going to see the sledgehammer, pick it up and start whacking. 
Not us. We need to gather all the information first. How is the wall built?
What tools are available to us? What type of ground is the wall on? From there
we can derrive the easiest and simplest solution to knock the wall down. 
Maybe digging a small hole under it will cause it to crack and fall over. Or
just letting a hose next to it erode the ground and cause it to crumble. Or
if we go get a bit of gas we can use the wrecking ball. If you haven't thought
of at least a few solutions then you have no clue if yours is best or not. We
may need to rely on team members for fresh and different perspectives to get 
this done correctly. 

### Privacy
The privacy of our users is paramount. We make sure to utilize the best data
security procedures even though we "don't have to". We don't want to use
vendors that may share or aggregate the data. We need to ensure anyone we 
export data to holds the same standards as us. People's data should be their
data. We will not buy or sell their data. 


### A contradiction? 
Our mission is to develop things quickly but we prioritize stablity over 
speed? This isn't a contradiction when taking in our commitment to long term. 
Developing stable systems does take longer, but stable systems let us move
faster. We need to measure speed over a period of years. The reality is one 
year is not the longest amount of time. We can probably get out a few core
product enhancements and big features in a year. 

Getting something out in two weeks verses two months is not that important. 
The reality is we probably need to spend about 2 months on the feature but when 
we cut out the nice to haves we find ourselves spending the next 4 months 
implementing them bit by bit. This puts us in a spot where the system lost the 
ability to have a nice architecture and introduces distractions.
