# Committing code

Every commit should be able to stand on its own and not break the environment.
Small commits are highly encouraged and if a PR has more than 250 or so lines,
then perhaps it is too big and should be broken up. 

### Branch naming

Since we practice continous integration (merging), we want flexibility to 
branching and do not tie branches to tickets. Not all of our changes need
ticketed and quantified. If you see a small improvement to be made, simply
make a branch for it, commit and then create a pull request.

For naming, ensure to include your initials and a description:
```
cp-commission-calculator
```

### Commit Format

A commit should follow the conventional guidelines of a title line of max
50 characters, a blank line, and then the body with a max of 80 characters.

```
TIK-001 Creates a Commission Calculator

This adds a class for calculating commissions for our sellers on the platform.
We will consolidate all the calculation logic to this class and other ways
to do this will be deprecated with warnings. 

I found a fancy algorithm that speeds this up and performs it in the most 
efficient way. You can read about that [here](https://www.google.com).
```


### Committing Checklist

- [ ] Does the commit follow the proper format?
- [ ] Does the commit include the ticket number if applicable?
- [ ] Does the commit have proper context in the commit message?
