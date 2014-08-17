arrayFns = require './arrays'

createMatrix = (arrays) ->
  (op) ->
    op arrays

# Lol performance
createImmutableMatrix = (arrays) ->
  (op) ->
    op arrayFns.copy arrays

# ([[]] -> [[]]) -> Matrix -> Matrix
fmap = (arrayFunction) ->
  (matrix) ->
    matrix arrayFunction

# ([[]], [[]] -> [[]]) -> Matrix -> [[]] -> Matrix
liftInfix = (infixArrayFunc) ->
  (matrix) ->
    (arrays) ->
      matrixArrays = innerArraysOf matrix
      createMatrix \
        infixArrayFunc arrays, matrixArrays

###
Matrix Functions
###
get = (row, col) ->
  (arrays) ->
    arrays[row][col]

numOfRowsOf = fmap arrayFns.getNumOfRows

numOfColsOf = fmap arrayFns.getNumOfColumns

innerArraysOf = fmap (arrays) -> arrays

sizeOf = fmap arrayFns.getSize

plus = liftInfix arrayFns.add

module.exports =
  createMatrix: createMatrix
  createImmutableMatrix: createImmutableMatrix
  get: get
  plus: plus
  sizeOf: sizeOf
  innerArraysOf: innerArraysOf
  numOfRowsOf: numOfRowsOf
  numOfColsOf: numOfColsOf
