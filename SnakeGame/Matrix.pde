class Matrix{
  int rows;
  int cols;
  float[][] matrix;
 
  //----------------------------------------
  Matrix(int newRows, int newCols){
    matrix = new float[newRows][newCols];
    rows = newRows;
    cols = newCols;
  }
  
  //---------------------------------------
  Matrix(float[][] newMatrix){
    matrix = newMatrix;
    rows = newMatrix.length;
    cols = newMatrix[0].length;
  }
  
  //---------------------------------------
  Matrix(float[] array){
    matrix = new float[array.length][1];
    rows = array.length;
    cols = 1;
    
    for (int i = 0; i < rows; i++) {
      matrix[i][0] = array[i];   
    }
  }
  
  //---------------------------------------
  void output(){
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        print(matrix[i][j], ' ');  
      }
      println(' ');
    }
    println();
  }
  
  //---------------------------------------
  void multiply(float n){
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] *= n;   
      }
    }
  }
  
  //---------------------------------------
  void add(float n){
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] += n;   
      }
    } 
  }
  
  //---------------------------------------
  void sub(float n){
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] -= n;   
      }
    } 
  }
  
  //---------------------------------------
  Matrix dot(Matrix n){
    Matrix result = new Matrix(rows, n.cols);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < n.cols; j++) {
        result.matrix[i][j] = 0;
        for (int k = 0; k < cols; k++) {
          result.matrix[i][j] += matrix[i][k] * n.matrix[k][j];  
        }
      }
    }
    
    return result;
  }
  
  //---------------------------------------
  void  randomize(){
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] = random(2) - 1;  
      }
    }
  }
  
  //---------------------------------------
  Matrix clone(){
    Matrix result = new Matrix(rows, cols);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result.matrix[i][j] = matrix[i][j]; 
      }
    }
    
    return result;
  }
  
  //---------------------------------------
  Matrix transpose(){
    Matrix result = new Matrix(cols, rows);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result.matrix[j][i] = matrix[i][j];  
      }
    }
    
    return result;
  }
  
  //---------------------------------------
  Matrix createSingleColumnMatrixFromArray(float[] arr){
    Matrix result = new Matrix(arr.length, 1);
    
    for (int i = 0; i < arr.length; i++) {
      result.matrix[i][0] = arr[i];  
    }
    
    return result;
  }
  
  //---------------------------------------
  float[] toArray(){
    float[] array = new float[rows];
    
    for (int i = 0; i < rows; i++) {
      array[i] = matrix[i][0];  
    }
    
    return array;
  }
  
  //---------------------------------------
  Matrix addBias(){
    Matrix result = new Matrix(rows + 1, 1);
    
    for (int i = 0; i < rows; i++) {
      result.matrix[i][0] = matrix[i][0];  
    }
    result.matrix[rows][0] = 1;
    
    return result;
  }
  
  //---------------------------------------
  float sigmoid(float x){
    float y = 1/(1 + pow((float)Math.E, -x));
    return y;
  }
  
  //---------------------------------------
  Matrix activate(){
    Matrix result = new Matrix(rows, cols);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result.matrix[i][j] = sigmoid(matrix[i][j]);  
      }
    }
    
    return result;
  }
  
  //---------------------------------------
  Matrix crossover(Matrix parthner){
    Matrix child = new Matrix(rows, cols);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (random(1) < 0.5) {
          child.matrix[i][j] = matrix[i][j];  
        } else {
          child.matrix[i][j] = parthner.matrix[i][j];  
        }
      }
    }
    
    return child;
  }
  
  //---------------------------------------
  void mutate(float mutationRate){
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
          if (random(1) < mutationRate) {
            matrix[i][j] += randomGaussian()/5;
            
            if (matrix[i][j] > 1) {
              matrix[i][j] = 1;  
            } else if (matrix[i][j] < -1) {
              matrix[i][j] = -1;  
            }
          }
      }
    }
  }
}
