# ac-helm.el

Auto Complete with Helm. A `ac-anything.el` fork.

## Installation

If you choose not to use one of the convenient packages in
[Melpa][melpa], you'll need to add the
directory containing `ac-helm.el` to your `load-path`, and then `(require 'ac-helm)`.

## Usage

### configuration

Add the following to your emacs init file:

    (require 'ac-helm)  ;; Not necessary if using ELPA package
    (define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)

### command

The following command is defined:

#### ac-complete-with-helm

Select [`auto-complete`][auto-complete] candidates by [`helm`][helm].
It is useful to narrow candidates.

[melpa]: http://melpa.milkbox.net
[auto-complete]:https://github.com/auto-complete/auto-complete
[helm]:https://github.com/emacs-helm/helm
