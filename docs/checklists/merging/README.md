# Merging

We follow a Github flow style of brancing and merging. We do not like merge
commits and should try to avoid them at all costs. Merge early, merge often.
Our commits should not be large and thus hopefully you are merging at least
daily if not several times. 

We want to have only fast forward commits added onto our master branch. Also
you should only be merging one commit at a time if possible. If there are a 
few commits, each one should stand on it's own. 


### Merging Checklist

- [ ] Was all PR changes addressed if applicable? 
- [ ] Checkout master
- [ ] Pull latest master
- [ ] Checkout your branch
- [ ] Rebase your branch against master `git rebase -i master`
- [ ] Squash commits and format commit message
- [ ] Force push the rebased branch
- [ ] Checkout master
- [ ] Merge your branch `git merge -` 
