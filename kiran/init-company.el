(use-package company
  :ensure t
  :diminish ""
  :init
  ;; (add-hook 'prog-mode-hook 'company-mode)
  ;; (add-hook 'comint-mode-hook 'company-mode)
  :config
  (global-company-mode)
  ;; Quick-help (popup documentation for suggestions).
  ;; (use-package company-quickhelp
  ;;   :if window-system
  ;;   :init (company-quickhelp-mode 1))
  ;; Company settings.
  (setq company-tooltip-limit 20)
  (setq company-idle-delay 0.2)
  (setq company-echo-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-require-match nil)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-align-annotations t)
  ;; weight by frequency
  (setq company-transformers '(company-sort-by-occurrence))
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)

  ;; =======================
  ;; Adding company backends
  ;; =======================

  ;; Python auto completion
  (use-package company-jedi
    :ensure t
    :config
    (add-to-list 'company-backends 'company-jedi))

  ;; HTML completion
  (use-package company-web
    :ensure t
    :bind (("C-c w" . company-web-html))
    :config
    (add-to-list 'company-backends 'company-web-html))

  ;; Python auto completion
  (use-package company-anaconda
    :ensure t
    :config
    (add-to-list 'company-backends
                 '(company-anaconda :with company-capf)))

  ;; C code completion
  (use-package company-irony
    :ensure t
    :config
    (add-to-list 'company-backends 'company-irony)))

;;(company-quickhelp-mode 1)

(provide 'init-company)
;;; init-company.el ends here
