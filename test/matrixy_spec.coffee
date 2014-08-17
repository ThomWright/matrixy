matrixy = require '../src/matrixy'
{createMatrix} = require '../src/matrixy'

describe 'matrixy:', ->
  describe 'createMatrix', ->
    it 'should take an array of arrays and return a Function', ->
      expect(createMatrix [[5]] ).to.be.a 'Function'

    it 'should throw an exception if the arrays are empty', ->
      expect(-> createMatrix [[]] ).to.throw /.*createMatrix.*/

    it 'should throw an exception for a single-dimension array', ->
      expect(-> createMatrix [] ).to.throw /.*createMatrix.*/

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

