Matrixy
=======
[![Build Status](https://travis-ci.org/ThomWright/matrixy.svg?branch=master)](https://travis-ci.org/ThomWright/matrixy)
[![Dependency Status](https://david-dm.org/ThomWright/matrixy.svg?theme=shields.io)](https://david-dm.org/ThomWright/matrixy)
[![devDependency Status](https://david-dm.org/ThomWright/matrixy/dev-status.svg?theme=shields.io)](https://david-dm.org/ThomWright/matrixy#info=devDependencies)

A general-purpose matrix library for NodeJS capable of LU-decomposition and solving equations of the form Ax=b.

## Quick Intro
 There are two main APIs in Matrixy:
 - **arrays** - works with 2D arrays
 - **matrixy** - works with Matrices (wrapped 2D arrays)

```coffeescript
{Matrixy, Arrays} = require 'matrixy'

fours = [[4, 4]]
fives = [[5, 5]]

# Arrays API
{add} = Arrays
add fours, fives

# Matrixy API
{createMatrix, plus} = Matrixy
foursM = createMatrix fours
fivesM = createMatrix fours

foursM plus fivesM
```

[API Docs are in the wiki.](https://github.com/ThomWright/matrixy/wiki)
