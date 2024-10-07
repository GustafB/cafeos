{ config, pkgs, ...}:
{	home.packages = with pkgs; [
	  (python312.withPackages (
	  	ps:
			with ps; [
              jupyter
			  jupyterlab
			  ipython
			  ipykernel
			  # DS
			  matplotlib
			  numpy
			  plotly
			  scikit-learn-extra
			  scipy
			  seaborn
              pandas
			  # formatter
			  black
              ruff
			  # other
			  virtualenv
			])
	)
  ];
}
