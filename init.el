;;; init.el --- Configuration for Emacs
;;
;;; Commentary:
;;
;; Configuration for Emacs
;;
;;; Code:


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(setq package-enable-at-startup nil)
(package-initialize)

;; Recompile .el file(s) if changes occur
(byte-recompile-directory (expand-file-name "~/.emacs.d/kiran") 0)

;; Record the start time
(setq *emacs-load-start* (current-time))

(global-auto-revert-mode 1)

;; Disable VC hooks
;; http://stackoverflow.com/questions/6724471/git-slows-down-emacs-to-death-how-to-fix-this
(setq vc-handled-backends nil)

;; Turn off mouse interface early in startup to avoid momentary display
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; language
(setq current-language-environment "English")

;; UTF-8 UTF-8 everywhere!
(setq default-file-name-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

(setq confirm-kill-emacs #'y-or-n-p)

;; do not make backup files
(setq make-backup-files nil)

;; Turn off bell
(setq ring-bell-function #'ignore)

;; https://www.emacswiki.org/emacs/ExecPath
(add-to-list 'exec-path "/usr/local/bin")

;; Disable key bypass (ex: M-h) to system
(setq mac-pass-command-to-system nil)

;; Prevent loading of outdated .elc files
(setq load-prefer-newer t)

(add-to-list 'load-path "~/.emacs.d/kiran/")

(require 'init-packages)
(require 'use-package)

(require 'init-looks)
(require 'init-editing)
(require 'init-dired)
(require 'init-kbd)
(require 'init-ido)
(require 'init-helm)
(require 'init-ibuffer)
(require 'init-company)
(require 'init-keychord)
(require 'init-parens)
(require 'init-python)
(require 'init-clojure)
(require 'init-elisp)
(require 'init-org)
(require 'init-yasnippet)
(require 'init-modeline)
(require 'init-shell)
(require 'efuns)
(require 'init-magit)
;;(require 'init-projectile)
;;(require 'init-solarized)
;;(require 'init-mu4e)
(eval-after-load 'markdown-mode '(require 'init-markdown))
;;(eval-after-load 'c-mode '(require 'init-c))
;;(eval-after-load 'web-mode '(require 'init-web))
;;(eval-after-load 'prolog-mode '(require 'init-prolog))
;;(eval-after-load 'sml-mode '(require 'init-sml))

;; Custom configuration set by Emacs
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(fringe-mode 15)

;; set exec-path according to the system's PATH
;; This is primarily for OS X, where starting Emacs in GUI mode
;; doesn't inherit the shell's environment. This ensures that
;; any command we can call from a shell, we can call inside Emacs.
;; (use-package exec-path-from-shell
;;   :config
;;   (when (memq window-system '(mac ns))
;;     (exec-path-from-shell-initialize)))

(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Save minibuffer history
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)

;; Remove autocomplete (and use company-mode instead)
(require 'auto-complete)
(global-auto-complete-mode -1)

;; turn beep off
(setq visible-bell nil)

;; disable backup
(setq backup-inhibited t)

;; turn auto-save off
(setq-default auto-save-default nil)

;; don't show trailing whitespace
(setq-default show-trailing-whitespace nil)

;; Create intermediate directories
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it? " dir)))
                  (make-directory dir t))))))

;; Toggle frame split (see efuns.el)
(global-set-key (kbd "C-x |") 'toggle-frame-split)

;; Clean view of major mode keybindings
(global-set-key (kbd "C-h C-m") 'discover-my-major)

;; Completion ignores filenames ending in any string in this list.
(setq completion-ignored-extensions
      '(".o" ".elc" "~" ".bin" ".class" ".exe" ".ps" ".abs" ".mx"
        ".~jv" ".rbc" ".pyc" ".beam" ".aux" ".out" ".pdf" ".hbc"))

;; Use M-w to copy line containing cursor if no region
;; is selected.
(defadvice kill-ring-save
    (before slick-copy activate compile)
    "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning)
             (region-end))
     (message "Line copied")
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; Follow compiler ouput
(setq compilation-scroll-output t)

;; Spell checking in text mode
;;(remove-hook 'text-mode-hook 'turn-on-flyspell)

;; Comment a line from anywhere in that line
;; (use-package smart-comment
;;   :config
;;   (global-set-key (kbd "M-;") 'smart-comment-line))

(use-package neotree
  :defer t
  :init
  (setq neo-smart-open t)
  (setq-default neo-dont-be-alone t)
  (setq neo-hidden-files-regexp
        "^\\.\\|~$\\|^#.*#$\\|^target$\\|^pom\\.*\\|^__pycache__$\\|^env$")
  :config
  ;; (local-set-key (kbd "M-<up>") 'neotree-select-up-node)
  ;; (local-set-key (kbd "M-<down>") 'neotree-select-down-node)
  (global-set-key [f9] 'neotree-toggle))

(use-package flycheck
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package aggressive-indent
  :commands (aggressive-indent-mode)
  :config
  ;;(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode))

(use-package paradox
  :config
  (setq-default paradox-github-token nil
                paradox-execute-asynchronously t))

;;; =====================================
;;; Experimental Stuff
;;; =====================================

;; Use spotlight instead of locate
(setq locate-command "mdfind")

;; Allow pasting selection outside of Emacs
(setq x-select-enable-clipboard t
      save-interprogram-paste-before-kill t)

;; Learn about HTTP headers, media-types, methods, relations and status codes
;;(use-package know-your-http-well)

;;(use-package fancy-narrow)

;; (use-package swiper-helm
;;   :config
;;   (global-unset-key (kbd "C-s"))
;;   (global-unset-key (kbd "C-r"))
;;   (global-set-key (kbd "C-s") 'swiper-helm)
;;   (global-set-key (kbd "C-r") 'swiper-helm))

;; (set-default 'cursor-type 'box)
;; (add-hook 'after-init-hook (lambda () (setq cursor-type '(bar . 2))))

;; Display a tip from the Pragmatic Programmer!
;; Based on https://github.com/sfrapoport/daily-pragmatic-tip
;;
;; (defun pc/be-pragmatic ()
;;   "Display a tip from the Pragmatic Prvogrammer!"
;;   (let* ((revert-without-query '("pragmatic.*\\.org"))
;;          (url "http://tinyurl.com/q4tbobl")
;;          (buffer (url-retrieve-synchronously url))
;;          n text)
;;     (switch-to-buffer buffer)
;;     (re-search-forward "^$" nil t 1)
;;     (forward-line)
;;     (delete-region (point) (point-min))
;;     (setq n (count-lines (point-min) (point-max)))
;;     (forward-line (random 70))
;;     (setq text (buffer-substring-no-properties
;;                 (line-beginning-position)
;;                 (line-end-position)))
;;     (delete-non-matching-lines text (point-min) (point-max))
;;     (write-file (make-temp-file "pragmatic" nil ".org"))
;;     (revert-buffer-with-coding-system 'utf-8-hfs-dos t)
;;     (fill-paragraph)
;;     (save-buffer)))

;; Hook it up to be called on an idle timer, every day
;;(pc/run-with-timer-when-idle 1 120 86400 'pc/be-pragmatic)

(setenv "PATH" (concat "/Library/TeX/texbin" (getenv "PATH")))
(setq exec-path (cons "/Library/TeX/texbin"  exec-path))

;; Hide cursor in inactive windows
(setq cursor-in-non-selected-windows t)

;; Focus on help windows
(setq help-window-select t)

(defalias 'find-grep 'ag)

;; (use-package github-pullrequest)

;;(set-cursor-color "ff0000")

;; ====== Don't GC when in minibuffer =======
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)
;; ==========================================

;; (setq org-latex-create-formula-image-program 'convert)

;;; =================================================================

;; Start emacs server
(server-start)

;; (add-to-list 'default-frame-alist '(height . 41))
;; (add-to-list 'default-frame-alist '(width . 120))

(add-to-list 'default-frame-alist '(height . 38))
(add-to-list 'default-frame-alist '(width . 85))

;; Write out a message indicating how long it took to process the init script
(require 'cl)
(message "init.el loaded in %ds"
         (destructuring-bind (hi lo ms ps) (current-time)
           (- (+ hi lo)
              (+ (first *emacs-load-start*)
                 (second *emacs-load-start*)))))

(provide `.emacs)

;;; init.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
