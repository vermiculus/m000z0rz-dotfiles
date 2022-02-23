(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(eval-when-compile
  (require 'use-package))

;; maybe ensure by default?
;;(setq use-package-always-ensure t)

;; Copied mostly from blog.sumtypeofway.com/posts/emacs-config.html
(setq
 sentence-end-double-space nil
 ring-bell-function 'ignore
 use-dialog-box nil
 ;;mark-even-if-inactive nil
 kill-whole-line t ;; Let C-k delete the entire line
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

(require 'recentf)
(add-to-list 'recentf-exclude "\\elpa")

(unbind-key "C-z") ;; suspend-frame

(if ( version< "27.0" emacs-version ) ; )
    (set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)
    (warn "This Emacs version is too old to properly support emoji."))

(ignore-errors (set-frame-font "Menlo-10"))
(use-package all-the-icons
  :ensure t)
;; (use-package all-the-icons-dired
;;   :ensure t
;;   :after all-the-icons
;;   :hook (dired-mode . all-the-icons-dired-mode))

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

;; maybe in the future, i don't know mcuha bout it yet
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

(use-package deadgrep
  :ensure t
  :bind (("C-c h" . #'deadgrep)))

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
  
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (typescript-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(lsp-mode magit deadgrep use-package helpful ample-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-verbatim ((t (:inherit shadow :foreground "gold")))))

;; (load-theme 'ample t t)
(load-theme 'ample-flat t t)
;; (load-theme 'ample-light t t)
(enable-theme 'ample-flat)



;; initial window setup
(setq inhibit-startup-screen t)
(defun my-default-window-setup ()
  (split-window-right)
  (other-window 1)
  (find-file "C:/Users/bbaker/OneDrive - epic.com/Documents/notes/questions.org")
  (other-window 1))
  (find-file "C:/Users/bbaker/OneDrive - epic.com/Documents/notes/emacs1.org")
(add-hook 'emacs-startup-hook #'my-default-window-setup)
