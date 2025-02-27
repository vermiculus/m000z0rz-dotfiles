(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;(eval-when-compile
;;  (require 'use-package))
(setq use-package-enable-imenu-support t)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; maybe ensure by default?
;;(setq use-package-always-ensure t)

;; Copied mostly from blog.sumtypeofway.com/posts/emacs-config.html


(use-package exec-path-from-shell
  :ensure t
  :init (exec-path-from-shell-initialize))

(use-package emacs
  :bind (("M-o" . other-window))
  :hook ((before-save . delete-trailing-whitespace))
  :config
  (setq custom-file "~/.emacs.d/init-custom.el")
  (setq-default major-mode 'org-mode)
  (when (file-readable-p custom-file)
    (load-file custom-file)))

(use-package dired
  :bind (:map dired-mode-map
	      ("/" . dired-up-directory)))

(use-package avy
  :ensure t
  :bind (("C-:" . avy-goto-char)
	 ("C-'" . avy-goto-char-2)
	 ("M-g f" . avy-goto-line)))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
	 ("C-#" . swiper-thing-at-point)))

(use-package counsel
  :ensure t
  :diminish counsel-mode
  :init
  (counsel-mode))

(use-package imenu
  :ensure t
  :bind ("C-c C-," . imenu))

(use-package forge
  :ensure t
  :after magit)

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-M->" . mc/mark-all-like-this)))

(setq
 sentence-end-double-space nil
 ring-bell-function 'ignore
 use-dialog-box nil
 save-interprogram-paste-before-kill t
 ;;mark-even-if-inactive nil
 kill-whole-line t ;; Let C-k delete the entire line
 confirm-kill-processes nil
 )

;; always utf-8 by default
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;;(delete-selection-mode t)
(global-display-line-numbers-mode t)
(column-number-mode)

(require 'hl-line)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)
(set-face-attribute 'hl-line nil :background "gray21")

;; Move Where I Mean
(use-package mwim
  :ensure t ;; stuff
  :bind (("C-a" . 'mwim-beginning)
	 ("C-e" . 'mwim-end)))

(use-package diminish
  :ensure t)

(use-package eldoc
  :ensure t
  :diminish eldoc-mode)

(use-package aggressive-indent
  :ensure t
  :diminish aggressive-indent-mode
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
	 (typescript-mode . aggressive-indent-mode)))

(use-package magit
  :ensure t
  :bind (("M-m" . magit-status)
	 ("C-x g" . magit-list-repositories)))

(use-package magit-delta
  :if (executable-find "delta")
  :ensure t
  :disabled t
  :hook (magit-mode . magit-delta-mode))

(require 'recentf)
(add-to-list 'recentf-exclude "\\elpa")

(unbind-key "C-z") ;; suspend-frame

(if ( version< "27.0" emacs-version ) ; )
    (set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)
    (warn "This Emacs version is too old to properly support emoji."))

(ignore-errors (set-frame-font "Menlo-10"))
(use-package all-the-icons
  :ensure t)
;; NOTE: if icons are broken, you may need to run
;; `all-the-icons-install-fonts`

(use-package all-the-icons-dired
  :ensure t
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

;; window should be fullscreen and maximized by default
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; hide toolbars and junk
(when (window-system)
  (tool-bar-mode -1)
  ;;  (scroll-bar-mode -1)
  ;; (tooltip-mode -1)
  )

;; make it easier to tell which buffer is active
(use-package dimmer
  :ensure t
  :custom (dimmer-fraction 0.1)
  :config (dimmer-mode))


(show-paren-mode)

(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode))
  (electric-pair-mode))



;; make it so dired doesn't open a new buffer for every visited diretotry
(defun dired-up-directory-same-buffer ()
  "Go up in the same buffer."
  (find-alternate-file ".."))

(defun my-dired-mode-hook ()
  (put 'dired-find-alternate-file 'disabled nil) ; Disabled the warning.
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^") 'dired-up-directory-same-buffer))

(add-hook 'dired-mode-hook #'my-dired-mode-hook)

(setq dired-use-ls-dired nil)

;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; maybe in the future, i don't know much about it yet
;; (use-package undo-tree
;;   :diminish
;;   :bind (("C-c _" . undo-tree-visualize))
;;   :config
;;   (global-undo-tree-mode +1)
;;   (unbind-key "M-_" undo-tree-map))

(use-package sudo-edit
    :ensure t)

(use-package keychain-environment
  :ensure t
  :config
  (keychain-refresh-environment))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :bind (("C-h M" . which-key-show-major-mode))
  :config
  (which-key-mode))

(use-package helpful
  :ensure t
  :bind (([remap describe-key] . helpful-key)
	 ("C-c C-d" . #'helpful-at-point)
	 ("C-h f" . #'helpful-callable)
	 ("C-h v" . #'helpful-variable)))

(use-package deadgrep
  :ensure t
  :bind (("C-c h" . #'deadgrep)))

(use-package tree-sitter
  :ensure t
  :hook ((js-mode . tree-sitter-hl-mode)
	 (sh-mode . tree-sitter-hl-mode)
	 (c-mode . tree-sitter-hl-mode)
	 (typescript-mode . tree-sitter-hl-mode)))

(use-package tree-sitter-langs
  :ensure t)

(use-package typescript-mode
  :ensure t)

(use-package csharp-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package fish-mode
  :ensure t)

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (projectile-mode)
  :bind (:map projectile-mode-map
	      ("C-c p" . projectile-command-map)))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (typescript-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ivy
  :ensure t
  :bind (:map lsp-mode-map
	      ("C-c i" . lsp-ivy-workspace-symbol)))

(use-package lsp-ui
  :ensure t)

(use-package prettier
  :ensure t
  :diminish prettier-mode
  :hook ((typescript-mode . prettier-mode)))


(use-package eshell
  :ensure t
  :bind ("C-c s" . eshell))

(use-package ample-theme
  :ensure t)

;; (load-theme 'ample t t)
(load-theme 'ample-flat t t)
;; (load-theme 'ample-light t t)
(enable-theme 'ample-flat)



;; initial window setup
(setq inhibit-startup-screen t)
;;(defun my-default-window-setup ()
;;  (split-window-right)
;;  (other-window 1)
;;  (find-file "C:/Users/bbaker/OneDrive - epic.com/Documents/notes/questions.org")
;;  (other-window 1))
;;  (find-file "C:/Users/bbaker/OneDrive - epic.com/Documents/notes/emacs1.org")
;;(add-hook 'emacs-startup-hook #'my-default-window-setup)
(desktop-save-mode 1)


;; sort of adapted from
;; https://stackoverflow.com/questions/15580913/is-there-a-way-to-toggle-a-string-between-single-and-double-quotes-in-emacs
;; TODO handle escaping "/`
(defun toggle-typescript-interpolated-quote ()
  "Toggle the string containing point between an interpolated
string and a double-quoted string."
  (interactive)
  (save-excursion
    (let* ((syn (syntax-ppss))
	   (in-string (nth 3 syn)))
      (cond ((not in-string)
	     (user-error "Not in a string"))
	    (t
	     (let* (
		    (string-start (nth 8 syn))
		    (old-quote (aref (buffer-substring string-start (+ string-start 1)) 0 ))
		    (new-quote (if (char-equal old-quote ?`) ?\" ?`)))
	       (goto-char string-start)
	       (forward-sexp)
	       (setq string-end (point))
	       (delete-char -1)
	       (insert new-quote)
	       (goto-char string-start)
	       (delete-char 1)
	       (insert new-quote)))))))

;; bind M-` to toggle-typescript-interpolated-quote in typescript-mode
(add-hook 'typescript-mode-hook
	  (lambda ()
	    (local-set-key (kbd "M-`") 'toggle-typescript-interpolated-quote)))

;; https://blog.sumtypeofway.com/posts/emacs-config.html
(defun pt/eol-then-newline ()
  "Go to end of line, then newline-and-indent."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

;; replace C-M-o which previously was just newline whil ekeeping point in place
(bind-key "C-M-<return>" #'pt/eol-then-newline)
