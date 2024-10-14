{
    pkgs,
    ...
}:
pkgs.python311.withPackages (ps: with ps; [
  setuptools
  jupyter
  jupyterlab
  ipython
  ipykernel
  # DS
  matplotlib
  numpy
  plotly
  #scikit-learn-extra
  scipy
  seaborn
  pandas
  # formatter
  black
  # other
  virtualenv
])

