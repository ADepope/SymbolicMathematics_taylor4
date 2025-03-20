# Deep Learning for Symbolic Mathematics learning of 4th order Taylor Expansion

This repository extends the features of [facebookresearch/SymbolicMathematics](https://github.com/facebookresearch/SymbolicMathematics) by adding generation of funciton and their 4th order Taylor expansion. Additionally, it offers Mathematica code for this generation task, but the code is less customizable.

In the following paragraphs we focus solely on the Taylor expansion learning functionality - for an extensive list of all options that this repository gives, please consult the original respository.
This repository contains code for:
- **Data generation**
    - Functions f with their fourth order Taylor expansion taylor_f

## Dependencies

- Python 3
- [NumPy](http://www.numpy.org/)
- [SymPy](https://www.sympy.org/)
- [PyTorch](http://pytorch.org/) (tested on version 1.3)
- [Apex](https://github.com/nvidia/apex#quick-start) (for fp16 training)

## Data generation

If you want to use your own dataset / generator, it is possible to train a model by generating data on the fly.
However, the generation process can take a while, so we recommend to first generate data, and export it into a dataset that can be used for training. This can easily be done by setting `--export_data true`:

```bash
python main.py --export_data true

## main parameters
--batch_size 32
--cpu true
--exp_name prim_taylor4_data
--num_workers 20               # number of processes
--tasks prim_taylor4           # task 
--env_base_seed -1             # generator seed (-1 for random seed)

## generator configuration
--n_variables 1                # number of variables (x, y, z)
--n_coefficients 0             # number of coefficients (a_0, a_1, a_2, ...)
--leaf_probs "0.75,0,0.25,0"   # leaf sampling probabilities
--max_ops 12                   # maximum number of operators (at generation, but can be much longer after derivation)
--max_int 5                    # max value of sampled integers
--positive true                # sign of sampled integers
--max_len 512                  # maximum length of generated equations

## considered operators, with (unnormalized) sampling probabilities
--operators "add:10,sub:3,mul:10,pow2:4,pow3:2,pow4:1,pow5:1,exp:4,sin:4,cos:4,tan:4,asin:1,acos:1,atan:1,sinh:1,cosh:1,tanh:1,asinh:1"

## other generations parameters can be found in `main.py` and `src/envs/char_sp.py`
```

Data will be exported in the prefix and infix formats to:
- `./dumped/prim_bwd_data/EXP_ID/data.prefix`
- `./dumped/prim_bwd_data/EXP_ID/data.infix`

`data.prefix` and `data.infix` are two parallel files containing the same number of lines, with the same equations written in prefix and infix representations respectively. In these files, each line contains an input (e.g. the function to integrate) and the associated output (e.g. an integral) separated by a tab. In practice, the model only operates on prefix data. The infix data is optional, but more human readable, and can be used for debugging purposes.

If you generate your own dataset, you will notice that the generator generates a lot of duplicates (which is inevitable if you parallelize the generation). In practice, we remove duplicates using:
```bash
cat ./dumped/prim_taylor4_data/3ef736k3du/data.prefix \
| awk 'BEGIN{PROCINFO["sorted_in"]="@val_num_desc"}{c[$0]++}END{for (i in c) print i}' \
> data.prefix.expressions
```
The resulting format is the following:
```
input1_prefix    output1_prefix
input2_prefix    output2_prefix
...
```

## References

[**Deep Learning for Symbolic Mathematics**](https://arxiv.org/abs/1912.01412) (ICLR 2020) - Guillaume Lample * and François Charton *

```
@article{lample2019deep,
  title={Deep learning for symbolic mathematics},
  author={Lample, Guillaume and Charton, Fran{\c{c}}ois},
  journal={arXiv preprint arXiv:1912.01412},
  year={2019}
}
```

## License

See the [LICENSE](LICENSE) file for more details.
