;;; ac-helm.el --- Auto Complete with Helm

;; Copyright (C) 2009  rubikitch
;; Copyright (C) 2013  Yasuyuki Oka <yasuyk@gmail.com>

;; Author: rubikitch <rubikitch@ruby-lang.org>
;;         Yasuyuki Oka <yasuyk@gmail.com>
;; Maintainer: Yasuyuki Oka <yasuyk@gmail.com>
;; Version: 1.7
;; Package-Requires: ((helm "20130328")(auto-complete "20130324")(popup "20130324"))
;; Keywords: completion, convenience, helm

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Auto Complete with Helm.  It enables us to narrow candidates
;; with helm interface.  If you have helm-match-plugin.el,
;; candidates can be narrowed many times.

;; Commands:
;;
;; Below are complete command list:
;;
;;  `ac-complete-with-helm'
;;    Select auto-complete candidates by `helm'.
;;
;; Customizable Options:
;;
;; Below are customizable option list:
;;

;; Installation:

;; Add below code in your ~/.emacs
;;
;; (require 'ac-helm)
;; (define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)

;; That's all.

;;; History:

;; Version 1.7  2013/03/29 Yasuyuki Oka <yasuyk@gmail.com>
;; * port to helm.
;;   The original source code is below:
;;   http://www.emacswiki.org/cgi-bin/wiki/download/ac-anything.el
;;
;; $Log: ac-anything.el,v $
;; Revision 1.6  2009/11/11 17:13:11  rubikitch
;; Use pulldown.el if available
;;
;; Revision 1.5  2009/11/11 17:08:16  rubikitch
;; Replace ac-prefix with (anything-attr 'ac-prefix)
;;
;; Revision 1.4  2009/04/18 21:08:49  rubikitch
;; Remove attribute `ac-point'
;;
;; Revision 1.3  2009/04/18 21:03:51  rubikitch
;; * Auto Document
;; * Use anything-show-completion.el if available
;;
;; Revision 1.2  2009/02/09 21:24:44  rubikitch
;; *** empty log message ***
;;
;; Revision 1.1  2009/02/09 21:09:16  rubikitch
;; Initial revision
;;

;;; Code:

(require 'helm)
(require 'helm-match-plugin nil t)
(require 'helm-elisp)
(require 'auto-complete)
(require 'popup)

(defun ac-complete-with-helm ()
  "Select `auto-complete' candidates by `helm'.
It is useful to narrow candidates."
  (interactive)
  (when ac-completing
    (with-helm-show-completion (point) (point)
     (helm :sources 'helm-source-auto-complete-candidates
           :buffer  "*helm auto-complete*"))))

(defun helm-auto-complete-init ()
  (helm-attrset 'ac-candidates ac-candidates)
  (helm-attrset 'menu-width
                (popup-preferred-width ac-candidates))
  (helm-attrset 'ac-prefix ac-prefix)
  (ac-abort))

(defun helm-auto-complete-action (string)
  (delete-backward-char (length (helm-attr 'ac-prefix)))
  (insert string)
  (prog1 (let ((action (get-text-property 0 'action string)))
           (if action (funcall action)))
    ;; for GC
    (helm-attrset 'ac-candidates nil)))

(defun helm-auto-complete-candidates ()
  (loop for x in (helm-attr 'ac-candidates) collect
        (cons
         (helm-aif (get-text-property 0 'action x)
             (format "%s%s <%s>"
                     x
                     ;; padding
                     (make-string (- (helm-attr 'menu-width) (length x)) ? )
                     ;; action function name
                     it)
           x)
         x)))

(defvar helm-source-auto-complete-candidates
  '((name . "Auto Complete")
    (init . helm-auto-complete-init)
    (candidates . helm-auto-complete-candidates)
    (action . helm-auto-complete-action)
    (ac-candidates)
    (menu-width)))

(provide 'ac-helm)

;;; ac-helm.el ends here
