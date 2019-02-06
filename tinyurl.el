;;; tinyurl.el --- playing tinyurls
;; Copyright (C) 2019 Lars Magne Ingebrigtsen

;; Author: Lars Magne Ingebrigtsen <larsi@gnus.org>
;; Keywords: extensions, processes

;; tinyurl.el is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; tinyurl.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Put the following in your .emacs:

;; (push "~/src/tinyurl.el" load-path)
;; (autoload 'tinyurl "tinyurl" nil t)

;;; Code:

(defun tinyurl ()
  "Get a tinyurl.com URL from the contents of the kill ring.
The result is pushed onto the kill ring."
  (interactive)
  (let ((old (current-kill 0))
	new)
    (unless old
      (error "The kill ring is empty"))
    (with-current-buffer (url-retrieve-synchronously
			  (format "https://tinyurl.com/api-create.php?url=%s"
				  old))
      (goto-char (point-min))
      (when (search-forward "\n\n" nil t)
	(setq new (buffer-substring (point) (point-max))))
      (kill-buffer (current-buffer)))
    (unless new
      (error "No response from tinyurl"))
    (kill-new new)
    (message "Copied %s" new)))

(provide 'tinyurl)

;;; tinyurl.el ends here
