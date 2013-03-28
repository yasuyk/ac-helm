EMACS=emacs
SRC=ac-helm.el

check-package-format:
	emacs $(SRC) --batch -l package -f package-buffer-info
