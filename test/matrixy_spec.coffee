matrixy = require '../src/matrixy'
{createMatrix} = matrixy

a2x3 = createMatrix [[1, 2, 3]
                     [4, 5, 6]]
b2x3 = createMatrix [[1, 1, 1]
                     [1, 1, 1]]
a2x2 = createMatrix [[1, 2]
                     [3, 4]]
a3x2 = createMatrix [[7, 8]
                     [9, 10]
                     [11, 12]]

describe 'matrixy:', ->
  describe 'Matrix creation', ->
    describe 'createMatrix', ->
      it 'should take an array of arrays and return a Function', ->
        expect(createMatrix [[5]] ).to.be.a 'Function'

      it 'should throw an exception if the arrays are empty', ->
        expect(-> createMatrix [[]] ).to.throw /.*createMatrix.*/

      it 'should throw an exception for a single-dimension array', ->
        expect(-> createMatrix [] ).to.throw /.*createMatrix.*/

    describe 'createImmutableMatrix', ->
      {createImmutableMatrix} = matrixy
      it 'should not modify the original when the underlying array is modified', ->
        original = [[1, 2]]
        immutableMatrix = createImmutableMatrix original
        immutableMatrix()[0][0] = 23
        expect(immutableMatrix() ).to.eql original
      it 'should not let operations modify the matrix', ->
        {set} = matrixy
        original = [[1, 2]]
        immutableMatrix = createImmutableMatrix original
        immutableMatrix set(0, 0).to 23
        expect(immutableMatrix() ).to.eql original

    describe 'createIdentityMatrix', ->
      {createIdentityMatrix} = matrixy
      it 'should create an identity matrix', ->
        identity2x2 = createIdentityMatrix 2
        expect(identity2x2() ).to.eql [[1, 0]
                                       [0, 1]]

    describe 'createBlankMatrix', ->
      {createBlankMatrix} = matrixy
      it 'should create a blank matrix', ->
        blank2x2 = createBlankMatrix 2
        expect(blank2x2() ).to.eql [[0, 0]
                                    [0, 0]]

  describe 'matrix wrapper', ->
    describe 'matrix()', ->
      it 'should return the inner arrays when given no args', ->
        matrix = createMatrix [[5, 5]]
        expect(matrix() ).to.eql [[5, 5]]

    describe 'matrix(f)', ->
      it 'should call the given function with itself as a param', ->
        matrix = createMatrix [[1, 2]]
        p = null
        matrix (param) -> p = param
        expect(p ).to.eql matrix
        expect(p() ).to.eql matrix()

  describe 'Getting dimensions', ->
    describe 'numOfRowsOf(matrix)', ->
      {numOfRowsOf} = matrixy
      it 'should return the number of rows in a matrix', ->
        n = numOfRowsOf a2x3
        expect(n).to.equal 2

    describe 'numOfColsOf(matrix)', ->
      {numOfColsOf} = matrixy
      it 'should return the number of columns in a matrix', ->
        n = numOfColsOf a2x3
        expect(n).to.equal 3

    describe 'sizeOf(matrix)', ->
      {sizeOf} = matrixy
      it 'should return a string describing the size of a matrix', ->
        size = sizeOf a2x3
        expect(size).to.equal '2x3'

    describe 'getDimensionsOf(matrix)', ->
      {getDimensionsOf} = matrixy
      it 'should return an array describing the size of a matrix', ->
        size = getDimensionsOf a2x3
        expect(size).to.eql [2, 3]

  describe 'Detecting triangular matrices', ->
    describe 'isLowerTriangular(matrix)', ->
      {isLowerTriangular} = matrixy
      it 'should detect when lower triangular', ->
        lower = createMatrix [[1, 0]
                              [3, 4]]
        expect(isLowerTriangular lower).to.equal yes
      it 'should detect when not lower triangular', ->
        lower = createMatrix [[1, 2]
                              [0, 4]]
        expect(isLowerTriangular lower).to.equal no

    describe 'isUpperTriangular(matrix)', ->
      {isUpperTriangular} = matrixy
      it 'should detect when upper triangular', ->
        upper = createMatrix [[1, 2]
                              [0, 4]]
        expect(isUpperTriangular upper).to.equal yes
      it 'should detect when not upper triangular', ->
        upper = createMatrix [[1, 0]
                              [3, 4]]
        expect(isUpperTriangular upper).to.equal no

  describe 'LU decomposition', ->
    {decompose, times} = matrixy
    squareMatrix = createMatrix [[1, 2]
                                 [3, 4]]
    it 'should return {l,u,p} where LU == PA for integer solutions', ->
      {l, u, p} = decompose squareMatrix
      lu = l times u
      pa = p times squareMatrix
      expect(lu() ).to.eql(pa() )

  describe 'copy(matrix)', ->
    {copy} = matrixy
    it 'should make a copy of a matrix', ->
      m = createMatrix [[1, 2]]
      c = copy m
      expect(c()).to.eql m()
    it 'should return a copy, not a reference', ->
      {set, get} = matrixy
      m = createMatrix [[1, 2]]
      c = copy m
      m set(0, 0).to 23
      expect(c get(0, 0)).to.eql 1

  describe 'get()', ->
    {get} = matrixy
    it 'should get the correct entry', ->
      m = createMatrix [[1, 2, 3]]
      expect(m get(0, 1) ).to.equal 2

  describe 'set', ->
    {set, get} = matrixy
    describe 'set().to()', ->
      it 'should set an entry in the matrix', ->
        m = createMatrix [[1, 2, 3]]
        m set(0, 1).to(6)
        expect(m get(0, 1) ).to.equal 6

    describe 'set().plusEquals()', ->
      it 'should be equivalent to +=', ->
        m = createMatrix [[1, 2, 3]]
        m set(0, 1).plusEquals(4)
        expect(m get(0, 1) ).to.equal 6

  describe 'Basic arithmetic:', ->
    describe 'Addition', ->
      {plus} = matrixy
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> a2x3 plus a3x2 ).to.throw /.*Matrix size.*/
      it 'should add two 2x3 matrices', ->
        result = a2x3 plus a2x3
        expect(result() ).to.eql [[2, 4, 6]
                                  [8, 10, 12]]

    describe 'Subtraction', ->
      {minus} = matrixy
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> a2x3 minus a3x2 ).to.throw /.*Matrix size.*/
      it 'should subtract two 2x3 matrices', ->
        result = a2x3 minus b2x3
        expect(result() ).to.eql [[0, 1, 2]
                                  [3, 4, 5]]

    describe 'Multiplication', ->
      {times} = matrixy
      it "should throw an error if the number of rows/columns don't match", ->
        expect(-> a2x3 times a2x2 ).to.throw "Can't multiply a 2x3 matrix by a 2x2 matrix."
      it 'should multiply two matrices of different sizes', ->
        result = a2x3 times a3x2
        expect(result() ).to.eql [[ 58, 64]
                                  [139, 154]]
      it 'should multiply a 3x3 by a 3x1 matrix to form a non-square matrix', ->
        a3x3 = createMatrix [[0, 0, 1]
                             [0, 1, 0]
                             [1, 0, 0]]
        a3x1 = createMatrix [[6]
                             [ - 4]
                             [27]]
        result = a3x3 times a3x1
        expect(result() ).to.eql [[27]
                                  [ - 4]
                                  [6]]

      it 'should multiply a matrix by an integer', ->
        ones = createMatrix [[1, 1]
                             [1, 1]]
        result = ones times 2
        expect(result() ).to.eql [[2, 2]
                                  [2, 2]]

  describe 'transpose()', ->
    {transpose} = matrixy
    it 'should transpose a matrix', ->
      m = createMatrix [[1, 2, 3]
                        [4, 5, 6]]
      t = transpose m
      expect(t() ).to.eql [[1, 4]
                           [2, 5]
                           [3, 6]]

  describe 'invert()', ->
    {invert} = matrixy
    it 'should invert a matrix', ->
      invertable = createMatrix [[2, -1, 0]
                                 [-1, 2, -1]
                                 [0, -1, 2]]
      inverted = invert invertable

      expect(inverted() ).to.almost.eql [[0.75, 0.5, 0.25]
                                         [0.5, 1, 0.5]
                                         [0.25, 0.5, 0.75]], 10

  describe 'Equation solver', ->
    {solve} = matrixy
    it 'should solve a matrix equation of the form Ax=b for x', ->
      A = createMatrix [[1, 1, 1]
                        [0, 2, 5]
                        [2, 5, - 1]]
      b = createMatrix [[6]
                        [ - 4]
                        [27]]
      x = solve A, b
      expect(x() ).to.eql [[5]
                           [3]
                           [ - 2]]

  describe 'determinant()', ->
    {determinantOf} = matrixy
    it 'should find the determinant of matrix', ->
      m = createMatrix [[1, 0, 2, -1]
                        [3, 0, 0, 5]
                        [2, 1, 4, -3]
                        [1, 0, 5, 0]]
      expect(determinantOf m ).to.equal 30
