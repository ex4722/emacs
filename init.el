(setq inhibit-startup-message t)


(tool-bar-mode -1)
(menu-bar-mode -1) 
(toggle-scroll-bar -1) 

(defalias 'yes-or-no-p 'y-or-n-p)

;; Options
(column-number-mode)
(global-display-line-numbers-mode t)


;;(global-set-key ["M-'"] counsel-M-x)   
(setq custom-file "~/.config/emacs/custom-vars.el")
(load custom-file 'noerror 'nomessage)

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))





(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(use-package counsel
  :config (setq ivy-initial-inputs-alist nil))
(use-package swiper :ensure t)
(use-package command-log-mode)
(use-package ivy-rich
  :init( ivy-rich-mode 1))
(use-package ivy
  :diminish ; Don't show in mode list
  :bind(
	("C-s" . swiper)
	:map ivy-minibuffer-map
	("C-j" . ivy-next-line)
	("C-k" . ivy-previous-line)
	)
  :config
  )
(ivy-mode 1)
(counsel-mode 1)

					; Themeing 

;;(use-package solarized-theme)
;;(load-theme 'solarized-dark t)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 200)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package doom-themes)
(load-theme 'doom-solarized-dark t)

					; Eye Candy
(use-package which-key
  :init ( which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-deplay 0))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-epand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("h" . meow-left)
   '("j" . meow-next)
   '("k" . meow-prev)
   '("l" . meow-right)
   '("i" . meow-insert)
   '("'" . repeat)

   '("<escape>" . ignore)))

;(require 'meow)
;(meow-setup)
;(meow-global-mode
(use-package general)
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration t)
  (setq evil-want-Y-yank-to-eol t)

  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  ;;  (define-key evil-insert-state-map (kbd "jk") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-)

  )

(general-define-key
 "C-p" (lambda () (interactive) (evil-paste-from-register ?+))
 ;;clipboard-kill-ring-save to copy 
 )


(use-package key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


(use-package hydra)

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
jfdksl
