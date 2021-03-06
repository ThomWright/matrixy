[![Build Status](https://img.shields.io/travis/ThomWright/matrixy.svg)](https://travis-ci.org/ThomWright/matrixy)
[![npm](https://img.shields.io/npm/v/matrixy.svg)](https://www.npmjs.com/package/matrixy)
[![Dependency Status](https://img.shields.io/david/ThomWright/matrixy.svg)](https://david-dm.org/ThomWright/matrixy)
[![devDependency Status](https://img.shields.io/david/dev/ThomWright/matrixy.svg)](https://david-dm.org/ThomWright/matrixy#info=devDependencies)

<img src="imgs/logo.png" width="400" />

A general-purpose matrix library for NodeJS capable of LU-decomposition and solving equations of the form Ax=b.

## Quick Intro
 There are two main APIs in Matrixy:
 - **arrays** - works with 2D arrays
 - **matrixy** - works with Matrices (wrapped 2D arrays)

```coffeescript
{Matrixy, Arrays} = require 'matrixy'

# Arrays API
{add} = Arrays
fours = [[4, 4]]
fives = [[5, 5]]

result = add fours, fives

# Matrixy API
{createMatrix, plus} = Matrixy
fours = createMatrix [[4, 4]]
fives = createMatrix [[5, 5]]

result = fours plus fives
```

[API Docs are in the wiki.](https://github.com/ThomWright/matrixy/wiki)

[Background blog post on the ideas behind the design of the *matrixy* API.](http://thomwright.co.uk/2014/08/23/beautiful-apis-coffeescript/)
