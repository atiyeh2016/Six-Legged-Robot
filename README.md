# Six Legged Robot

A six-legged robot with 24 degrees of freedom is designed in MATLAB/SimMechanics. To extract the robot's dynamic equations, the Denavit-Hartenberg representation and the Lagrange approach are used. Also, SimMechanics is employed to validate the model.

To control the robot to follow a designed path, an end-to-end neural network that gets the desired polynomial path and returns the desired motor outputs was trained. The controller performance is validated and compared with the PID controller by introducing new paths to the network. 

Paths are generated using 5-degree polynomials.

Dynamic equations, path planning, and the SimMechanics model are provided.
![My Image](https://github.com/atiyeh2016/Six-Legged-Robot/blob/main/SimmechanicsModelling.png)
![My Image](https://github.com/atiyeh2016/Six-Legged-Robot/blob/main/SimmechanicsModel.png)
