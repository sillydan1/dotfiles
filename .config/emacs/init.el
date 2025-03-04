;; Performance hacks (taken from lionyxml/emacs-kick)
(setq gc-cons-threshold #x40000000)
(setq read-process-output-max (* 1024 1024 4))
(setq custom-file "~/.config/emacs/custom.el") ; Don't touch my shit

;; ======================== package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; The toolbar and menubar are ugly, remove them.
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; ======================== packages
(unless (package-installed-p 'evil) (package-install 'evil))
(unless (package-installed-p 'catpuccin-theme) (package-install 'catppuccin-theme))
(unless (package-installed-p 'neotree) (package-install 'neotree))
(unless (package-installed-p 'evil-leader) (package-install 'evil-leader))

;; ======================== configuration
(setq-default display-line-numbers 'relative)
(require 'evil-leader)
(global-evil-leader-mode)
(require 'evil)
(evil-mode 1)
(evil-leader/set-leader "<SPC>")
(load-theme 'catppuccin :no-confirm)
(require 'neotree)

;; ======================== keybinds
; NOTE: non-<leader> keymaps: (global-set-key [f8] 'neotree-toggle)
(add-hook 'neotree-mode-hook ; neotree evil mappings
	  (lambda ()
	    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
	    (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
	    (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
	    (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
	    (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
	    (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
	    (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))
(evil-leader/set-key "o" 'neotree-toggle)
