# module.exports
t = @

t.createIdentity = (size) ->
  if size is 0
    return [[]]
  arrays = new Array(size)
  for i in [0...size]
    arrays[i] = new Array(size)
    for j in [0...size]
      arrays[i][j] = if i is j then 1 else 0

# @param arrays [Array<Array<Number>>] Matrix to copy.
# @return [Array<Array<Number>>]
t.copy = (arrays) ->
  newMatrix = new Array(t.getNumOfRows arrays)
  for row, i in arrays
    newMatrix[i] = new Array(t.getNumOfColumns arrays)
    for e, j in row
      newMatrix[i][j] = e

# @param arrays [Array<Array<Number>>]
# @return [Boolean]
t.isEmpty = (arrays) ->
  if arrays.length is 0 or arrays[0].length is 0
    yes
  else
    no

# @param arrays [Array<Array<Number>>]
# @return [Boolean]
t.isSquare = (arrays) ->
  if t.isEmpty arrays
    no
  else
    t.getNumOfRows(arrays) is t.getNumOfColumns(arrays)

# @return [Integer]
t.getNumOfColumns = (arrays) ->
  if arrays.length is 0
    0
  else
    arrays[0].length

# @param arrays [Array<Array<Number>>]
# @return [Integer]
t.getNumOfRows = (arrays) ->
  if t.isEmpty arrays
    0
  else if arrays[0].length > 0
    arrays.length

# @param arrays [Array<Array<Number>>]
# @return [Array<Integer>]
t.getDimensions = (arrays) ->
  [t.getNumOfRows(arrays), t.getNumOfColumns(arrays) ]

# Get a string representation of the matrix size.
# @param arrays [Array<Array<Number>>]
# @return [String]
t.getSize = (arrays) ->
  [numOfRows, numOfCols] = t.getDimensions(arrays)
  "#{numOfRows}x#{numOfCols}"

# @param arrays [Array<Array<Number>>]
# @return [Boolean]
t.isLowerTriangular = (arrays) ->
  [numOfRows, numOfColumns] = t.getDimensions arrays
  return no if numOfRows is 0 or numOfColumns is 0
  return yes if numOfColumns is 1

  for i in [0...numOfRows]
    for j in [(i + 1)...numOfColumns]
      return no if arrays[i][j] isnt 0
  return yes

# @param arrays [Array<Array<Number>>]
# @return [Boolean]
t.isUpperTriangular = (arrays) ->
  [numOfRows, numOfColumns] = t.getDimensions arrays
  return no if numOfRows is 0 or numOfColumns is 0
  return yes if numOfRows is 1

  for i in [1...numOfRows]
    rowToCountTo = Math.min(i - 1, numOfColumns - 1)
    for j in [0..rowToCountTo]
      return no if arrays[i][j] isnt 0
  return yes

combine = (a1, a2, f) ->
  r = new Array(t.getNumOfRows a1 )
  for i in [0...t.getNumOfRows a1 ]
    r[i] = new Array(t.getNumOfColumns a1 )
    for j in [0...t.getNumOfColumns a1]
      r[i][j] = f a1[i][j], a2[i][j]

# @param a1 [Array<Array<Number>>]
# @param a2 [Array<Array<Number>>]
# @return [Array<Array<Number>>]
t.add = (a1, a2) ->
  combine a1, a2, (n1, n2) -> n1 + n2

# @param a1 [Array<Array<Number>>]
# @param a2 [Array<Array<Number>>]
# @return [Array<Array<Number>>]
t.subtract = (a1, a2) ->
  combine a1, a2, (n1, n2) -> n1 - n2

# @param a1 [Array<Array<Number>>]
# @param a2 [Array<Array<Number>>]
# @return [Array<Array<Number>>]
t.multiply = (a1, a2) ->
  r = new Array(t.getNumOfRows a1 )

  for i in [0...t.getNumOfRows a1 ]
    r[i] = new Array(t.getNumOfColumns a2 )
    for j in [0...t.getNumOfColumns a2 ]
      r[i][j] = 0
      for k in [0...t.getNumOfColumns a1 ]
        r[i][j] += a1[i][k] * a2[k][j]
  return r

# Decompose this matrix into lower and upper triangular matrices.
# @param arrays [Array<Array<Number>>]
# @throw [SingularMatrixException]
# @return [LUP] Lower and upper triangular matrices, and a permutation matrix.
t.decompose = (arrays) ->
  if t.isEmpty arrays
    return {l: [[]], u: [[]], p: [[]] }
  if not t.isSquare arrays
    throw {
      name: 'NotImplementedException',
      message: 'LU Decomposition not implemented for non-square matrices.'
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
