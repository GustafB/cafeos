{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (python313.withPackages (
      ps: with ps; [
        setuptools
        jupyter
        jupyterlab
        ipython
        ipykernel
        # DS
        matplotlib
        numpy
        plotly
        scikit-learn
        scipy
        seaborn
        pandas
        networkx
        # formatter
        black
        # other
        virtualenv
        requests
      ]
    ))
  ];
}
