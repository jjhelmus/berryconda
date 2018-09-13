nc-config --has-dap      | grep -q yes
nc-config --has-dap2     | grep -q yes
nc-config --has-dap4     | grep -q yes
nc-config --has-nc2      | grep -q yes
nc-config --has-nc4      | grep -q yes
nc-config --has-hdf5     | grep -q yes
nc-config --has-hdf4     | grep -q yes
nc-config --has-logging  | grep -q yes
nc-config --has-cdf5     | grep -q yes

# C++ and Fortran are now separate packages (netcdf-cxx4 and netcdf-fortran)
# nc-config --has-c++      | grep -q no
# nc-config --has-c++4     | grep -q no
# nc-config --has-fortran  | grep -q no

# Parallel is the one we would like to have.
# nc-config --has-parallel | grep -q no

# Not sure if people still uses pnetcdf.
# nc-config --has-pnetcdf  | grep -q no

# We cannot package szip due to its license
# nc-config --has-szlib    | grep -q no