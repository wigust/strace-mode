;;; guix.scm --- Guix package for Emacs-Guix

;; Copyright © 2017 Oleg Pykhalov <go.wigust@gmail.com>

;; This file is part of Emacs-Guix.

;; Emacs-Guix is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; Emacs-Guix is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with Emacs-Guix.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Based on Alex Kost <alezost@gmail.com> from guix.el project.

;; This file contains Guix package for development version of
;; Emacs-strace-mode.  To build or install, run:
;;
;;   guix build --file=guix.scm
;;   guix package --install-from-file=guix.scm

;;; Code:

(use-modules (ice-9 popen)
             (ice-9 rdelim)
             (guix build utils)
             (guix gexp)
             (guix git-download)
             (guix packages)
             (guix build-system emacs)
             ((guix licenses) #:prefix license:))

(define %source-dir (dirname (current-filename)))

(define (git-output . args)
  "Execute 'git ARGS ...' command and return its output without trailing
newspace."
  (with-directory-excursion %source-dir
    (let* ((port   (apply open-pipe* OPEN_READ "git" args))
           (output (read-string port)))
      (close-port port)
      (string-trim-right output #\newline))))

(define (current-commit)
  (git-output "log" "-n" "1" "--pretty=format:%H"))


(define emacs-strace-mode
  (let ((commit (current-commit)))
    (package
      (name "emacs-strace-mode")
      (version (string-append "0.0.1" "-" (string-take commit 7)))
      (source (local-file %source-dir
                          #:recursive? #t
                          #:select? (git-predicate %source-dir)))
      (build-system emacs-build-system)
      (home-page "https://github.com/wigust/strace-mode")
      (synopsis "Major Emacs mode for @code{strace} logs")
      (description "@code{strace-mode} provides an Emacs major mode
that prettifies @code{strace} log files.")
      (license license:gpl3+))))

emacs-strace-mode

;;; guix.scm ends here
