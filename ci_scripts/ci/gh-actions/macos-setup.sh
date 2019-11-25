#!/bin/bash

echo "Installing CMake"
brew install cmake

echo "Installing make"
brew install make

echo "Installing GCC"
brew install gcc

echo "Installing OpenMPI"
brew install openmpi

echo "Installing swig"
brew install swig

echo "Installing VTK"
brew install vtk

echo "Installing numpy and mpi4py"
pip3 install numpy mpi4py
