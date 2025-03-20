binaryOps = {Plus, Subtract, Times};
unaryOps = {Sin, Cos, Exp, Tan};

(* Function to randomly generate a binary-unary tree of depth d *)
ClearAll[generateRandomFunction]
generateRandomFunction[0, var_] := var (* Base case: return the variable *)
generateRandomFunction[d_, var_] := 
 Which[RandomReal[] < 0.5, (* 50% probability for unary operation *)
  RandomChoice[unaryOps][generateRandomFunction[d - 1, var]], 
  True, (* Otherwise, choose a binary operation *)
  RandomChoice[binaryOps][generateRandomFunction[d - 1, var], 
   generateRandomFunction[d - 1, var]]]

(* Generate a list of random functions *)
numFunctions = 100000;
randomFunctions = Table[generateRandomFunction[3, x], {numFunctions}];

(* Filter out constant functions and functions exceeding 250 characters *)
filteredFunctions = 
  Select[randomFunctions, 
   !(FreeQ[#, x]) && StringLength[ToString[#]] <= 250 &];

(* Compute Taylor series expansions at x=0 up to the fourth order *)
taylorExpansions = Normal[Series[#, {x, 0, 4}]] & /@ filteredFunctions;

(* Combine and export dataset (Function, TaylorExpansion) *)
dataset = Transpose[{filteredFunctions, taylorExpansions}];
Export["/Users/adepope/Documents/symbolic_py/random_functions_taylor_4th_100000.csv", dataset, "CSV"]
