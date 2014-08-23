matrixy = require '../src/matrixy'
{createMatrix} = matrixy

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

  describe 'Basic arithmetic:', ->
    twoByThree = createMatrix [[1, 2, 3]
                               [4, 5, 6]]
    threeByTwo = createMatrix [[1, 2]
                               [3, 4]
                               [5, 6]]
    describe 'Addition', ->
      {plus} = matrixy
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> twoByThree plus threeByTwo ).to.throw /.*Matrix size.*/
      it 'should add two 2x3 matrices', ->
        result = twoByThree plus twoByThree
        expect(result() ).to.eql [[2, 4, 6]
                                  [8, 10, 12]]
