###*
 * API for dealing with matrices as simple 2D arrays.
 * @module arrays
###

###
 * Internal reference to module.exports.
 * @private
###
t = @

###*
 * @param {!Integer} size
 * @return {Array.<Array.<Number>>} The identity 2D array of given size.
###
@createIdentity = (size) ->
  if size is 0
    return [[]]
  arrays = new Array(size)
  for i in [0...size]
    arrays[i] = new Array(size)
    for j in [0...size]
      arrays[i][j] = if i is j then 1 else 0

###*
 * @param {!Integer} numOfRows
 * @param {Integer} [numOfCols=numOfRows]
 * @return {Array.<Array.<Number>>} The blank (zeros) 2D array of given size.
###
@createBlank = (numOfRows, numOfCols = numOfRows) ->
  if numOfRows is 0 or numOfCols is 0
    return [[]]
  b = new Array(numOfRows)
  for i in [0...numOfRows]
    b[i] = new Array(numOfCols)
    for j in [0...numOfCols]
      b[i][j] = 0

###*
 * @param {!Array.<Array.<Number>>} arrays - 2D array to copy.
 * @return {Array.<Array.<Number>>}
###
@copy = (arrays) ->
  newMatrix = new Array(t.getNumOfRows arrays)
  for row, i in arrays
    newMatrix[i] = new Array(t.getNumOfColumns arrays)
    for e, j in row
      newMatrix[i][j] = e

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Boolean}
###
@isEmpty = (arrays) ->
  if arrays.length is 0 or arrays[0].length is 0
    yes
  else
    no

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Boolean}
###
@isSquare = (arrays) ->
  if t.isEmpty arrays
    no
  else
    t.getNumOfRows(arrays) is t.getNumOfColumns(arrays)

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Integer}
###
@getNumOfColumns = (arrays) ->
  if arrays.length is 0
    0
  else
    arrays[0].length

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Integer}
###
@getNumOfRows = (arrays) ->
  if t.isEmpty arrays
    0
  else if arrays[0].length > 0
    arrays.length

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Array.<Integer>} e.g. [2, 3] for a 2x3 matrix
###
@getDimensions = (arrays) ->
  [t.getNumOfRows(arrays), t.getNumOfColumns(arrays) ]

###*
 * Get a string representation of the 2D array size.
 * @param {!Array.<Array.<Number>>} arrays
 * @return {String}
###
@getSize = (arrays) ->
  [numOfRows, numOfCols] = t.getDimensions(arrays)
  "#{numOfRows}x#{numOfCols}"

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Boolean}
###
@isLowerTriangular = (arrays) ->
  [numOfRows, numOfColumns] = t.getDimensions arrays
  return no if numOfRows is 0 or numOfColumns is 0
  return yes if numOfColumns is 1

  for i in [0...numOfRows]
    for j in [(i + 1)...numOfColumns]
      return no if arrays[i][j] isnt 0
  return yes

###*
 * @param {!Array.<Array.<Number>>} arrays
 * @return {Boolean}
###
@isUpperTriangular = (arrays) ->
  [numOfRows, numOfColumns] = t.getDimensions arrays
  return no if numOfRows is 0 or numOfColumns is 0
  return yes if numOfRows is 1

  for i in [1...numOfRows]
    rowToCountTo = Math.min(i - 1, numOfColumns - 1)
    for j in [0..rowToCountTo]
      return no if arrays[i][j] isnt 0
  return yes

###
 * Create a new 2D array from a combination of two.
 * @private
 * @param {!Array.<Array.<Number>>} a1
 * @param {!Array.<Array.<Number>>} a2
 * @param {function(number, number): number} f
 * @return {Array.<Array.<Number>>}
###
combine = (a1, a2, f) ->
  r = new Array(t.getNumOfRows a1 )
  for i in [0...t.getNumOfRows a1 ]
    r[i] = new Array(t.getNumOfColumns a1 )
    for j in [0...t.getNumOfColumns a1]
      r[i][j] = f a1[i][j], a2[i][j]

###*
 * Add two 2D arrays and return the result.
 * @param {Array.<Array.<Number>>} a1
 * @param {Array.<Array.<Number>>} a2
 * @return {Array.<Array.<Number>>}
###
@add = (a1, a2) ->
  combine a1, a2, (n1, n2) -> n1 + n2

###*
 * Subtract a2 from a1 and return the result.
 * @param {Array.<Array.<Number>>} a1
 * @param {Array.<Array.<Number>>} a2
 * @return {Array.<Array.<Number>>}
###
@subtract = (a1, a2) ->
  combine a1, a2, (n1, n2) -> n1 - n2

###*
 * Multiply two 2D arrays and return the result.
 * @param {Array.<Array.<Number>>|Number} a1
 * @param {Array.<Array.<Number>>|Number} a2
 * @return {Array.<Array.<Number>>}
###
@multiply = (a1, a2) ->
  if (typeof a1 is 'number' and typeof a2 is 'number') then return [[a1 * a2]]
  if (typeof a1 is 'number') then return map ((e) -> e * a1), a2
  if (typeof a2 is 'number') then return map ((e) -> e * a2), a1

  r = new Array(t.getNumOfRows a1 )
  for i in [0...t.getNumOfRows a1 ]
    r[i] = new Array(t.getNumOfColumns a2 )
    for j in [0...t.getNumOfColumns a2 ]
      r[i][j] = 0
      for k in [0...t.getNumOfColumns a1 ]
        r[i][j] += a1[i][k] * a2[k][j]
  return r

###*
 * @typedef module:arrays.LUP
 * @type {object}
 * @property {Array.<Array.<Number>>} l - Lower triangular matrix.
 * @property {Array.<Array.<Number>>} u - Upper triangular matrix.
 * @property {Array.<Array.<Number>>} p - Permutation matrix.
###

###*
 * Decompose this 2D array into lower and upper triangular 2D arrays.
 * @param {Array.<Array.<Number>>} arrays
 * @throws {SingularMatrixException}
 * @return {LUP} Lower and upper triangular 2D arrays, and a permutation 2D array.
###
@decompose = (arrays) ->
  if t.isEmpty arrays
    return {l: [[]], u: [[]], p: [[]] }
  if not t.isSquare arrays
    throw {
      name: 'NotImplementedException',
      message: 'LU Decomposition not implemented for non-square 2D arrays.'
    }

  size = t.getNumOfRows(arrays)

  l = t.createIdentity size
  u = t.copy arrays
  p = t.createIdentity size

  ###
  Gaussian elimination w / partial pivoting
  ###
  for i in [0...size - 1] # reduce size of square subset each iteration
    # choose pivot
    pivotRowIndex = i
    maxFirstElement = u[i][i]
    for r in [i...size] # for rows in sub-square
      if u[r][i] > maxFirstElement
        maxFirstElement = u[r][i]
        pivotRowIndex = r
    if maxFirstElement is 0
      throw {
        name: 'SingularMatrixException',
        message: 'Singular matrix'
        cause: arrays
      }

    # row swap
    if pivotRowIndex isnt i
      for e in [i...size] # swap rows in u
        [u[i][e], u[pivotRowIndex][e]] = [u[pivotRowIndex][e], u[i][e]]
      for e in [0...i] # swap rows in l
        [l[i][e], l[pivotRowIndex][e]] = [l[pivotRowIndex][e], l[i][e]]
      [p[i], p[pivotRowIndex]] = [p[pivotRowIndex], p[i]]

    # Gaussian Elimination
    for j in [i + 1...size] # for every row in this sub-square
      l[j][i] = u[j][i] / u[i][i] # work out the factor to make first element zero
      for k in [i...size] # for each element in row in sub-square
        u[j][k] -= l[j][i] * u[i][k] # row = row - factor*topRowInSubset

  return {l: l, u: u, p: p }

###*
 * Solve the matrix equation Ax = b for x with matrix size N.
 * @param {Array.<Array.<Number>>} A - NxN
 * @param {Array.<Array.<Number>>} b - Nx1
 * @return {Array.<Array.<Number>>} Nx1
###
@solve = (A, b) ->
  # TODO assert sizes are correct
  {l, u, p} = t.decompose A
  solve {l, u, p} , b

###*
 * @private
 * @param  {LUP} lup
 * @param  {Array.<Array.<Number>>} b
 * @return {Array.<Array.<Number>>}
###
solve = ({l, u, p} , b) ->
  size = t.getNumOfRows b

  pb = t.multiply p, b
  y = t.createBlank size, 1

  ###
  TODO optimise by treating x (and y) as a single array, then copy into a 1 column matrix?
  ###

  # Solve Ly = Pb where y = Ux using forward substitution
  for rowIndex in [0...size]
    y[rowIndex][0] = pb[rowIndex][0]
    for colIndex in [0...rowIndex]
      y[rowIndex][0] -= l[rowIndex][colIndex] * y[colIndex][0]
    y[rowIndex][0] /= l[rowIndex][rowIndex]

  x = t.createBlank size, 1

  # Solve Ux = y using backward substitution
  for rowIndex in [size - 1..0]
    x[rowIndex][0] = y[rowIndex][0]
    for colIndex in [rowIndex + 1...size]
      x[rowIndex][0] -= u[rowIndex][colIndex] * x[colIndex][0]
    x[rowIndex][0] /= u[rowIndex][rowIndex]

  x

###*
 * Return a transposed version of the given 2D array.
 * @param {Array.<Array.<Number>>} arrays
 * @return {Array.<Array.<Number>>}
###
@transpose = (arrays) ->
  trans = new Array()
  for i in [0...t.getNumOfColumns arrays]
    trans[i] = new Array()
    for j in [0...t.getNumOfRows arrays]
      trans[i][j] = arrays[j][i]

###*
 * Return an inverted version of the given 2D array.
 * @param {Array.<Array.<Number>>} arrays
 * @return {Array.<Array.<Number>>}
###
@invert = (arrays) ->
  size = t.getNumOfRows arrays
  identity = t.createIdentity size
  {l, u, p} = t.decompose arrays

  columns = new Array()
  for i in [0...size]
    columnOfIdentity = t.transpose [identity[i]]
    columns[i] = solve({l, u, p}, columnOfIdentity)[0]

  t.transpose columns

map = (f, arrays) ->
  r = new Array(t.getNumOfRows arrays )

  for i in [0...t.getNumOfRows arrays ]
    r[i] = new Array(t.getNumOfColumns arrays )
    for j in [0...t.getNumOfColumns arrays ]
      r[i][j] = f arrays[i][j]

  return r
