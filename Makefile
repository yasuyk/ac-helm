EMACS=emacs
SRC=ac-helm.el

check-package-format:
	emacs $(SRC) --batch -l package -f package-buffer-info

bump-version: $(SRC) check-package-format
	@if [ "$(NEW_VERSION)" = "" ]; then \
	  echo NEW_VERSION argument not provided.; \
	  echo Usage: make bump-version NEW_VERSION=0.4.1; \
	  exit 1; \
	fi
	sed -i "" -e 's/^;; Version: .*/;; Version: $(NEW_VERSION)/' $(SRC)
	echo "Bump version to $(NEW_VERSION)"
	git commit -am "Bump version to $(NEW_VERSION)"
	git tag -a $(NEW_VERSION) -m $(NEW_VERSION)
