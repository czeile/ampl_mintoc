# ampl_mintoc
Formulating and solving (mixed-integer) optimal control problems in AMPL

## Getting Started
ampl_mintoc is an AMPL code for formulating and solving (mixed-integer) optimal control problems.  It consists of a set of code files that allow an efficient formulation of control problems, which are then solved by off-the-shelf NLP or MINLP solvers interfaced by AMPL.

### File Structure

The root directory contains various generic AMPL files which are used independently of the problem to be formulated. These include the key files mintocPre.mod and mintocPost.mod in which generic variables, parameters, objective functions, constraints, and optimisation problems are defined. Part of this package are a couple of (mixed-integer) optimal control example problems, which are created as respective subfolders, e.g. "lotka" or "calcium". A specific optimal control problem prob can be formulated using ampl_mintoc by means of creating the problem-specific files prob.dat, prob.mod, and prob.run, which provide the problem parameters, constraints/objective, and algorithmic choices, respectively.

### Further Information and Package Purpose
A more detailed description and information on how to use the package can be found in the "doc" folder under "mintoc.pdf" and in the "Sager2021" folder under "readme_sim.pdf".

Please note that this AMPL code stems from an academic project, meaning in this case code documentation and elegance were not the main focus.
ampl_mintoc was also presented in the publication [1], where the developers used this code to discuss and numerically evaluate switching time optimization and partial outer convexification as reformulations of mixed-integer optimal control problems.
You are very welcome to contact the the developers if you have any questions or concerns, in particular related to how to using this package.

[1]: "A numerical study of transformed mixed-integer optimal control problems", Sebastian Sager, Manuel Tetschke, Clemens Zeile,
preprint available under <http://www.optimization-online.org/DB_HTML/2020/03/7698.html> 

### Prerequisites and Installing

You need to have AMPL installed with a valid licence. As soon as AMPL is installed, you can immediately use ampl_mintoc.
  Depending on the optimal control problem at hand, you may want to install further solver programs than the ones coming with AMPL, such as IPOPT or Gurobi.
    
  
## Authors

* **Sebastian Sager** -  [SebastianSager](https://github.com/SebastianSager) - *sager@ovgu.de*
* **Manuel Tetschke** -  [tetschke](https://github.com/tetschke) -  *tetschke@ovgu.de*
* **Clemens Zeile** -  [czeile](https://github.com/czeile) - *clemens.zeile@ovgu.de*
 
## License

This project is licensed under the BSD v3 or later - see the [LICENSE.md](LICENSE.md) file for details.
