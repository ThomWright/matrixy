arrayFns = require './arrays'
{expect} = require 'chai'

createMatrix = (arrays) ->
  expect(arrays, 'createMatrix').to.not.be.empty
  expect(arrays[0], 'createMatrix').to.not.be.empty
  matrix = (op) ->
    op?(matrix) or arrays

# Lol performance
createImmutableMatrix = (arrays) ->
  matrix = (op) ->
    op?(matrix) or arrayFns.copy arrays

# ([[]] -> [[]]) -> Matrix -> Matrix
lift = (arrayFunction) ->
  (m) ->
    arrayFunction m()

# ([[]], [[]] -> [[]]) -> Matrix -> Matrix -> Matrix
lift2 = (fOfTwoArrays) ->
  (m2) ->
    (m1) ->
      # console.log m1
      createMatrix \
        fOfTwoArrays m1(), m2()

###
Matrix Functions
###
get = (row, col) ->
  (m) ->
    m()[row][col]

numOfRowsOf = lift arrayFns.getNumOfRows

numOfColsOf = lift arrayFns.getNumOfColumns

innerArraysOf = lift (arrays) -> arrays

sizeOf = lift arrayFns.getSize

plus = lift2 arrayFns.add

module.exports =
  createMatrix: createMatrix
  createImmutableMatrix: createImmutableMatrix
  get: get
  plus: plus
  sizeOf: sizeOf
  innerArraysOf: innerArraysOf
  numOfRowsOf: numOfRowsOf
  numOfColsOf: numOfColsOf
