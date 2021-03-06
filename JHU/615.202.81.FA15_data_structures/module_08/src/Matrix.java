import java.lang.Exception;
import java.lang.IndexOutOfBoundsException;

/** A Matrix of <code>int</code> precision.
  *
  * <p>The matrix is implemented as an integer array
  *     with an arbitrary maximum size.  The restriction to
  *     int type is based off of the supplied input data, which
  *     only specified input of int type.  Additionally,
  *     matrices created with this interface are restricted
  *     to square arrays.
  * </p>
  * <p>Methods to determine the minor and determinate of the
  *    matrix are included as methods on the object itself.
  * </p>
  *
  * @author Justin Ely
  * @version 0.0.1
  * @license BSD 3-clause
  */
public class Matrix{
  private int[][] data;

  /**Construct matrix with both order and data arguments
    *
    *<p>The data array will be loaded from the given 1D array
    *   using the loadData method.
    *</p>
    *
    *@param int order - the order n of the nxn matrix
    *@param int[] values - a 1D array of input values (flattened from 2d array)
    */
  public Matrix(int order, int[] values){
    if (order < 0) {
      throw new BadMatrix("Negative order given.");
    }

    data = new int[order][order];
    try {
      loadData(values);
    } catch (Exception e){
      System.err.println(e);
    }
  }

  /**Construct matrix with just order argument
    *
    *<p> Data will be initialized to 0 according to java
    *    language specifications.
    *</p>
    *
    *@param int order - the order n of the nxn matrix
    */
  public Matrix(int order){
    if (order < 0) {
      throw new BadMatrix("Negative order given.");
    }
    data = new int[order][order];
  }

  /**Construct default matrix
    *
    *<p> Matrix of order 1 will be initialized to 0 according to java
    *    language specifications.
    *</p>
    */
  public Matrix(){
    this(1);
  }

  /**Calculate Determinate of a matrix.
    *
    *<p> Matrix determinate is calculated according to the method supplied
    *    in the lab instructions.
    *</p>
    *<p> det(a) = 1 if n = 1 </p>
    *<p> det(a) = sum(pow(-1, i+j) * a[i,j] * det(minor(a[i, j]))) of all
    *    elements in a given row or column.
    *</p>
    *@param Matrix mat - matrix object on which to calculate determinate.
    */
  public static long Determinate(Matrix mat){
    int[][] subData = mat.getData();
    if (subData.length == 1){
      //Hit trivial case and halt recursion.
      return subData[0][0];
    } else {
      long sum = 0;
      int y = 0;
      //loop over columns, recursively calling determinate on the minor matrix.
      for (int x=0; x<subData.length; x++){
        Matrix minorMatrix = mat.Minor(x, y);
        sum = sum + ((long) Math.pow(-1, x+y) * (long) subData[x][y] * Determinate(minorMatrix));
      }
    return sum;
    }

  }

  /**Print matrix content to STDOUT
    *
    *<p> Convenience function to display matrix contents
    *    To the screen.  Will iterate over array indeces and
    *    display each row on a new line.  Columns will be separated
    *    by spaces.  Termination will be in a newline character.
    *</p>
    */
  public void Print(){
    int size = data.length;
    for (int y=0; y<size; y++){
      for (int x=0; x<size; x++){
        System.out.print(" " + data[x][y] + " ");
      }
      System.out.print("\n");
    }
  }

  /** Fetch core 2d data array.
    *
    *@return int[][] data - the core data of the matrix
    */
  public int[][] getData(){
    return data;
  }


  /** Load values into the matrix data structure
    *
    *<p> Input data should be the same size as the matrix,
    *    but in 1D form represented as concatenated
    *    rows.  If too few values are input, the rest of the
    *    values will be padded with zeros.  If too many
    *    values are suppled, an exception will be thrown.
    *</p>
    *
    *@param int[] values - the 1d representation of the 2d input array.
    */
  public void loadData(int[] values) throws Exception{
    int size = data.length;
    int inSize = values.length;

    if (size*size > inSize){
      System.out.println("WARNING: not enough values provided, padding with 0");
    } else if (size*size < inSize){
      throw new Exception("Too many values provided to matrix");
    } else{
      for (int i=0; i<values.length; i++){
        data[i%size][i/size] = values[i];
      }
    }
  }

  /** Pull out the Minor of the matrix.
    *
    *<p>For a specific row,column (i,j), return the minor
    *   matrix for that position.  All data in row i or column j
    *   will be removed, and the returned matrix will be of order
    *   1 smaller than the input matrix.
    (</p>)
    *
    *@param int i - row of the Minor
    *@param int j - column of the Minor
    *@return Matrix - minor matrix of order n-1
    */
  public Matrix Minor(int i, int j) {
    int insize = data.length;
    int outsize = insize - 1;
    int[] out_data = new int[outsize*outsize];

    // Throw error if trying to calculate minor outside of the array bounds.
    if ((i > insize) || (i < 0)) {
      throw new IndexOutOfBoundsException(i + " out of bounds for matrix.");
    }

    if ((j > insize) || (j < 0)) {
      throw new IndexOutOfBoundsException(j + "out of bounds for matrix.");
    }

    for (int x=0; x<insize; x++){
      for (int y=0; y<insize; y++){
        if ((x == i) || (y == j)){
          continue;
        }

        /* If indexed past the input row/column, dectrement the output
         * coordinate to fit in the dimensions of the output array.
         */
        int tmp_x = x;
        int tmp_y = y;
        if (x > i){
          tmp_x--;
        }
        if (y > j){
          tmp_y--;
        }

        out_data[tmp_x + tmp_y*outsize] = data[x][y];
      }
    }
    return new Matrix(outsize, out_data);
  }

}
