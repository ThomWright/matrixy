# module.exports
t = @

# @param arrays [Array<Array<Number>>] Matrix to copy.
# @return [Array<Array<Number>>]
t.copy = (arrays) ->
  newMatrix = new Array(t.getNumOfRows arrays)
  for row, i in arrays
    newMatrix[i] = new Array(t.getNumOfColumns arrays)
    for e, j in row
      newMatrix[i][j] = e
  return newMatrix

t.isEmpty = (arrays) ->
  if arrays.length is 0 or arrays[0].length is 0
    yes
  else
    no

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

# @return [Integer]
t.getNumOfRows = (arrays) ->
  if t.isEmpty arrays
    0
  else if arrays[0].length > 0
    arrays.length

# @return [Array<Integer>]
t.getDimensions = (arrays) ->
  [t.getNumOfRows(arrays), t.getNumOfColumns(arrays) ]

# Get a string representation of the matrix size.
# @return [String]
t.getSize = (arrays) ->
  [numOfRows, numOfCols] = t.getDimensions(arrays)
  "#{numOfRows}x#{numOfCols}"

t.add = (a1, a2) ->
  size1 = t.getSize a1
  size2 = t.getSize a2
  if size1 isnt size2
    throw {
      name: 'IllegalArgumentException'
      message: "Can't add a #{size1} matrix to a #{size2} matrix."
    }

  r = new Array(t.getNumOfRows a1 )

  for i in [0...t.getNumOfRows a1 ]
    r[i] = new Array(t.getNumOfColumns a1 )
    for j in [0...t.getNumOfColumns a1]
      r[i][j] = a1[i][j] + a2[i][j]
  return r
