Matrix = require '../src/matrix'

emptyMatrix = new Matrix()
oneMatrix = new Matrix([[3]])
singleRowMatrix = new Matrix([[5, 6, 9]])
singleColumnMatrix = new Matrix([[1]
                                 [2]])
m1 = new Matrix([[1, 2, 3]
                 [4, 5, 6]])
m2 = new Matrix([[ 7, 8]
                 [ 9, 10]
                 [11, 12]])
squareMatrix = new Matrix([[1, 2]
                           [3, 4]])
fiveMatrix = new Matrix([[4, 7, 7, 2, 0]
                         [3, 4, 8, 8, 0]
                         [1, 5, 2, 9, 6]
                         [6, 1, 2, 2, 1]
                         [6, 4, 8, 2, 8]])
singularMatrix = new Matrix([[0, 1]
                             [0, 1]])

describe 'Matrix', ->
  describe 'Dimensions', ->
    it 'should return correct dimensions', ->
      expect(m1.getDimensions() ).to.eql([2, 3])
    it 'should return correct dimensions for an empty matrix', ->
      expect(emptyMatrix.getDimensions() ).to.eql([0, 0])
    it 'should return the correct number of columns', ->
      expect(m1.getNumOfColumns() ).to.equal(3)
    it 'should return the correct number of rows', ->
      expect(m1.getNumOfRows() ).to.equal(2)
    it 'should return the correct number of columns for an empty matrix', ->
      expect(emptyMatrix.getNumOfColumns() ).to.equal(0)
    it 'should return the correct number of rows for an empty matrix', ->
      expect(emptyMatrix.getNumOfRows() ).to.equal(0)

  describe 'isSquare()', ->
    it 'should return true if the matrix is square', ->
      expect(squareMatrix.isSquare() ).to.be.true
    it 'should return false if the matrix isn\'t square', ->
      expect(m1.isSquare() ).to.be.false

  describe 'isLowerTriangular()', ->
    it 'should return no for empty matrix', ->
      expect(emptyMatrix.isLowerTriangular()).to.equal no
    it 'should return yes for one by one matrix', ->
      expect(oneMatrix.isLowerTriangular()).to.equal yes
    it 'should return yes for a three by three L matrix', ->
      threeLowerTriangularMatrix = new Matrix([[1, 0, 0]
                                               [1, 3, 0]
                                               [7, 5, 9]])
      expect(threeLowerTriangularMatrix.isLowerTriangular()).to.equal yes
    it 'should return no for an almost three by three L matrix', ->
      threeAlmostLowerTriangularMatrix = new Matrix([[1, 0, 1]
                                                     [1, 3, 0]
                                                     [7, 5, 9]])
      expect(threeAlmostLowerTriangularMatrix.isLowerTriangular()).to.equal no
    it 'should return yes for rectangular lower triangular matrix', ->
      rectangularLowerTriangularMatrix = new Matrix([[1, 0, 0, 0]
                                                     [5, 8, 0, 0]])
      expect(rectangularLowerTriangularMatrix.isLowerTriangular()).to.equal yes
    it 'should return yes for single column matrix', ->
      expect(singleColumnMatrix.isLowerTriangular()).to.equal yes
    it 'should return no for single row matrix of all non-zero values', ->
      expect(singleRowMatrix.isLowerTriangular()).to.equal no

  describe 'isUpperTriangular()', ->
    it 'should return no for empty matrix', ->
      expect(emptyMatrix.isUpperTriangular()).to.equal no
    it 'should return yes for one by one matrix', ->
      expect(oneMatrix.isUpperTriangular()).to.equal yes
    it 'should return yes for a three by three U matrix', ->
      threeUpperTriangularMatrix = new Matrix([[1, 1, 7]
                                               [0, 3, 5]
                                               [0, 0, 9]])
      expect(threeUpperTriangularMatrix.isUpperTriangular()).to.equal yes
    it 'should return no for an almost three by three U matrix', ->
      rectangularUpperTriangularMatrix = new Matrix([[1, 1, 7]
                                                     [0, 3, 5]
                                                     [1, 0, 9]])
    it 'should return yes for single row matrix', ->
      expect(singleRowMatrix.isUpperTriangular()).to.equal yes
    it 'should return no for single column matrix of all non-zero values', ->
      expect(singleColumnMatrix.isUpperTriangular()).to.equal no
    it 'should return yes for rectangular upper triangular matrix', ->
      rectangularUpperTriangularMatrix = new Matrix([[1, 5]
                                                     [0, 8]
                                                     [0, 0]])
      expect(rectangularUpperTriangularMatrix.isUpperTriangular()).to.equal yes

  describe 'createIdentityMatrix()', ->
    it 'should create an identity matrix', ->
      expect(Matrix.createIdentityMatrix(3)).to.eql new Matrix([[1, 0, 0]
                                                                [0, 1, 0]
                                                                [0, 0, 1]])
    it 'should create an empty identity matrix', ->
      expect(Matrix.createIdentityMatrix(0) ).to.eql new Matrix()
    it 'should return illegal argument exception if size < 0', ->
      expect(-> Matrix.createIdentityMatrix( - 1) ).to.throw /.*Matrix size.*/

  describe 'createBlankMatrix()', ->
    it 'should create an empty matrix when given zero size', ->
      expect(Matrix.createBlankMatrix(0) ).to.eql new Matrix()

    it 'should create a 2x2 matrix of all zeros', ->
      expect(Matrix.createBlankMatrix(2, 2)).to.eql new Matrix([[0, 0]
                                                                [0, 0]])
    it 'should return illegal argument exception if size < 0', ->
      expect(-> Matrix.createBlankMatrix( - 1) ).to.throw /.*Number of rows.*/
    it 'should return illegal argument exception if size < 0', ->
      expect(-> Matrix.createBlankMatrix(1, - 1) ).to.throw /.*Number of columns.*/
    it 'should create a square matrix when given one parameter', ->
      expect(Matrix.createBlankMatrix(2)).to.eql new Matrix([[0, 0]
                                                             [0, 0]])

  describe 'equals()', ->
    it 'should return true for equal matrices', ->
      expect(m1.equals(new Matrix([[1, 2, 3]
                                   [4, 5, 6]]) ) ).to.be.true
    it 'should return false for non-equal matrices', ->
    expect(m1.equals(m2) ).to.be.false

  describe 'copy()', ->
    it 'should copy itself', ->
      expect(m1.copy()).to.eql(m1)
    it 'should create a copy rather than a reference', ->
      copy = m1.copy()
      copy.set(0, 0).to 16
      expect(m1.get(0, 0)).to.eql(1)

  describe 'get()', ->
    it 'should get the correct entry', ->
      expect(m1.get(0, 1) ).to.equal(2)

  describe 'set', ->
    describe 'set().to()', ->
      it 'should set an entry in the matrix', ->
        m = m1.copy()
        m.set(0, 1).to(6)
        expect(m.get(0, 1) ).to.equal(6)

    describe 'set().plusEquals()', ->
      it 'should be equivalent to +=', ->
        m = m1.copy()
        m.set(0, 1).plusEquals(4)
        expect(m.get(0, 1) ).to.equal(6)

  describe 'increment()', ->
    it 'should increment by 1', ->
      m = m1.copy()
      m.increment(0, 1)
      expect(m.get(0, 1) ).to.equal(3)

  describe 'Basic arithmetic', ->
    describe 'Addition', ->
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> m1.plus(m2) ).to.throw "Can't add a 2x3 matrix to a 3x2 matrix."
      it 'should add two 2x3 matrices', ->
        expect(m1.plus(m1) ).to.eql new Matrix([[2, 4, 6]
                                                [8, 10, 12]])

    describe 'Subtraction', ->
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> m1.minus(m2) ).to.throw "Can't subtract a 3x2 matrix from a 2x3 matrix."
      it 'should add two 2x3 matrices', ->
        expect(m1.minus(m1) ).to.eql new Matrix([[0, 0, 0]
                                                [0, 0, 0]])

    describe 'Multiplication', ->
      it "should throw an error if the number of rows/columns don't match", ->
        expect(-> m1.times(emptyMatrix) ).to.throw "Can't multiply a 2x3 matrix by a 0x0 matrix."
      it 'should multiply two matrices of different sizes', ->
        expect(m1.times(m2)).to.eql new Matrix([[ 58, 64]
                                                [139, 154]])
      it 'should multiply a 3x3 by a 3x1 matrix to form a non-square matrix', ->
        threeByThree = new Matrix([[0, 0, 1]
                                   [0, 1, 0]
                                   [1, 0, 0]])
        threeByOne = new Matrix([[6]
                                 [ - 4]
                                 [27]])
        expect(threeByThree.times(threeByOne)).to.eql new Matrix([[27]
                                                                  [ - 4]
                                                                  [6]])

  describe 'LU Decomposition', ->
    it 'should decompose an empty matrix into empty {l,u,p}', ->
      {l, u, p} = emptyMatrix.decompose()
      expect(l).to.be.empty
      expect(u).to.be.empty
      expect(p).to.be.empty
    it 'should return {l,u,p} where LU == PA for integer solutions', ->
      {l, u, p} = squareMatrix.decompose()
      expect(l.times(u) ).to.eql(p.times(squareMatrix) )
    it 'should return {l,u,p} where LU ~= PA for floating point solutions', ->
      {l, u, p} = fiveMatrix.decompose()
      expect(l.times(u) ).to.almost.eql(p.times(fiveMatrix), 14)
    it 'should return a lower triangular matrix', ->
      {l, u, p} = squareMatrix.decompose()
      expect(l.get(0, 1)).to.equal(0)
    it 'should return an upper triangular matrix', ->
      {l, u, p} = squareMatrix.decompose()
      expect(u.get(1, 0)).to.equal(0)
    it 'should throw an exception for non-square matrices', ->
      expect(-> m1.decompose() ).to.throw("LU Decomposition not implemented for non-square matrices.")
    describe 'Singular matrix handling', ->
      it 'should throw an exception for singular matrices', ->
        expect(-> singularMatrix.decompose() ).to.throw("Singular matrix")
      it 'should throw an exception which contains the problem matrix', ->
        try
          singularMatrix.decompose()
        catch error
          expect(error).to.have.ownProperty 'cause'
          expect(error.cause).to.eql singularMatrix

  describe 'Equation solver', ->
    it 'should solve a matrix equation of the form Ax=b for x', ->
      A = new Matrix([[1, 1, 1]
                      [0, 2, 5]
                      [2, 5, - 1]])
      b = new Matrix([[6]
                      [ - 4]
                      [27]])
      expect(Matrix.solve(A, b) ).to.eql new Matrix([[5]
                                                     [3]
                                                     [ - 2]])
