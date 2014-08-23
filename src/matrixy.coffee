arrayFns = require './arrays'
{expect} = require 'chai'

createMatrix = (arrays) ->
  expect(arrays, 'createMatrix').to.not.be.empty
  expect(arrays[0], 'createMatrix').to.not.be.empty
  wrapper = (op) ->
    op?(wrapper) or arrays

createImmutableMatrix = (arrays) ->
  wrapper = (op) ->
    op?(wrapper) or arrayFns.copy arrays

compose = (f, g) ->
  ->
    args = Array::slice.call arguments
    f g.apply @, args

# ([[]] -> [[]]) -> Matrix -> Matrix
lift = (arrayFunction) ->
  (m) ->
    arrayFunction m()

# ([[]], [[]] -> [[]]) -> Matrix -> Matrix -> Matrix
lift2 = (fOfTwoArrays) ->
  (m2) ->
    (m1) ->
      createMatrix \
        fOfTwoArrays m1(), m2()

###
Matrix Functions
###
createIdentityMatrix = compose createMatrix, arrayFns.createIdentity

createBlankMatrix = compose createMatrix, arrayFns.createBlank

get = (row, col) ->
  (m) ->
    m()[row][col]

set = (row, col) ->
  {
    to: (value) ->
      (m) ->
        m()[row][col] = value
    plusEquals: (value) ->
      (m) ->
        m()[row][col] += value
  }

numOfRowsOf = lift arrayFns.getNumOfRows

numOfColsOf = lift arrayFns.getNumOfColumns

innerArraysOf = lift (arrays) -> arrays

sizeOf = lift arrayFns.getSize

checkSizesMatch = (a1, a2) ->
  size1 = arrayFns.getSize a1
  size2 = arrayFns.getSize a2
  expect(size1, 'Matrix size').to.equal size2

plus = lift2 (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.add a1, a2

module.exports =
  createMatrix: createMatrix
  createImmutableMatrix: createImmutableMatrix
  createIdentityMatrix: createIdentityMatrix
  createBlankMatrix: createBlankMatrix
  get: get
  set: set
  plus: plus
  sizeOf: sizeOf
  innerArraysOf: innerArraysOf
  numOfRowsOf: numOfRowsOf
  numOfColsOf: numOfColsOf
