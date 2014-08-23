arrayFns = require './arrays'
{expect} = require 'chai'
{compose, createLiftFunctions} = require './functional_utils'

{liftInput, lift2} = createLiftFunctions {
  wrap: (arrays) -> createMatrix arrays
  unwrap: (matrix) -> matrix()
}

createMatrix = (arrays) ->
  expect(arrays, 'createMatrix').to.not.be.empty
  expect(arrays[0], 'createMatrix').to.not.be.empty
  wrapper = (op) ->
    op?(wrapper) or arrays

createImmutableMatrix = (arrays) ->
  wrapper = (op) ->
    op?(wrapper) or arrayFns.copy arrays

createIdentityMatrix = compose createMatrix, arrayFns.createIdentity

createBlankMatrix = compose createMatrix, arrayFns.createBlank

copy = (matrix) ->
  createMatrix arrayFns.copy matrix()

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

numOfRowsOf = liftInput arrayFns.getNumOfRows

numOfColsOf = liftInput arrayFns.getNumOfColumns

innerArraysOf = liftInput (arrays) -> arrays

sizeOf = liftInput arrayFns.getSize

checkSizesMatch = (a1, a2) ->
  size1 = arrayFns.getSize a1
  size2 = arrayFns.getSize a2
  expect(size1, 'Matrix size').to.equal size2

checkCanMultiply = (a1, a2) ->
  numOfColsIn1 = arrayFns.getNumOfColumns a1
  numOfRowsIn2 = arrayFns.getNumOfRows a2
  if numOfColsIn1 isnt numOfRowsIn2
    size1 = arrayFns.getSize a1
    size2 = arrayFns.getSize a2
    throw {
      name: 'IllegalArgumentException'
      message: "Can't multiply a #{size1} matrix by a #{size2} matrix."
    }

plus = lift2 (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.add a1, a2

minus = lift2 (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.subtract a1, a2

times = lift2 (a1, a2) ->
  checkCanMultiply a1, a2
  arrayFns.multiply a1, a2

module.exports =
  createMatrix: createMatrix
  createImmutableMatrix: createImmutableMatrix
  createIdentityMatrix: createIdentityMatrix
  createBlankMatrix: createBlankMatrix
  copy: copy
  get: get
  set: set
  plus: plus
  minus: minus
  times: times
  sizeOf: sizeOf
  innerArraysOf: innerArraysOf
  numOfRowsOf: numOfRowsOf
  numOfColsOf: numOfColsOf
