class Neural {
  int iNodes;
  int hNodes;
  int oNodes;
  
  Matrix whi;
  Matrix whh;
  Matrix woh;
  
  //----------------------------------------
  Neural(int newInputs, int newHidden, int newOutputs){
    iNodes = newInputs;
    hNodes = newHidden;
    oNodes = newOutputs;
    
    whi = new Matrix(hNodes, iNodes + 1);
    whh = new Matrix(hNodes, hNodes + 1);
    woh = new Matrix(oNodes, hNodes + 1);
    
    whi.randomize();
    whh.randomize();
    woh.randomize();
  }
  
  //----------------------------------------
  void mutate(float mutationRate){
    whi.mutate(mutationRate);  
    whh.mutate(mutationRate);  
    woh.mutate(mutationRate);  
  }
  
  //----------------------------------------
  Neural crossover(Neural parthner){
    Neural child = new Neural(iNodes, hNodes, oNodes);
    child.whi = whi.crossover(parthner.whi);
    child.whh = whh.crossover(parthner.whh);
    child.woh = woh.crossover(parthner.woh);
    return child;
  }
  
  Neural clone(){
    Neural clone = new Neural(iNodes, hNodes, oNodes);
    clone.whi = whi.clone();
    clone.whh = whh.clone();
    clone.woh = woh.clone();
    return clone;
  }
  
  //----------------------------------------
  float[] calculate(float[] inputsArr){
    Matrix inputs = new Matrix(inputsArr);
    inputs = inputs.addBias();
    
    //first
    Matrix hiddenInputs = whi.dot(inputs);
    Matrix hiddenOutputs = hiddenInputs.activate();
    hiddenOutputs = hiddenOutputs.addBias();
    
    //second
    hiddenInputs = whh.dot(hiddenOutputs);
    hiddenOutputs = hiddenInputs.activate();
    hiddenOutputs = hiddenOutputs.addBias();
    
    Matrix outputInputs = woh.dot(hiddenOutputs);
    Matrix outputOutputs = outputInputs.activate();
    
    return outputOutputs.toArray();
  }
}
