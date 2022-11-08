(setq user-full-name "Eddie Xiao"
      user-mail-address "eddie.j.xiao@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))



;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

(setq display-line-numbers-type 'relative)
(global-visual-line-mode nil)
(setq global-hl-line-modes nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Settings
(setq confirm-kill-emacs nil)
(setq auto-save-default t
      make-backup-files t)

(remove-hook 'tty-setup-hook 'doom-init-clipboard-in-tty-emacs-h)
(setq select-enable-clipboard nil)

( use-package! evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  :config
  (define-key evil-insert-state-map (kbd "C-p") (lambda () (interactive) (evil-paste-from-register ?+)))
  (define-key evil-normal-state-map (kbd "C-p") (lambda () (interactive) (evil-paste-from-register ?+)))
  (define-key evil-visual-state-map (kbd "C-p") (lambda () (interactive) (evil-paste-from-register ?+)))
  )
(defun copy-to-clipboard-visual()
  (interactive)
  (setq select-enable-clipboard t)
  (kill-ring-save (region-beginning) (region-end))
  (setq select-enable-clipboard nil))

(evil-define-operator evil-yank-fake (beg end type register yank-handler)
  "Save the characters in motion into the kill-ring."
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (message "changed clipboard")
  (setq select-enable-clipboard t)
  (let ((evil-was-yanked-without-register
         (and evil-was-yanked-without-register (not register))))
    (cond
     ((and (fboundp 'cua--global-mark-active)
           (fboundp 'cua-copy-region-to-global-mark)
           (cua--global-mark-active))
      (cua-copy-region-to-global-mark beg end))
     ((eq type 'block)
      (evil-yank-rectangle beg end register yank-handler))
     ((memq type '(line screen-line))
      (evil-yank-lines beg end register yank-handler))
     ((evil-yank-characters beg end register yank-handler)
      (goto-char beg))))
  (message "changing back")
  (setq select-enable-clipboard nil))

(define-key evil-visual-state-map "Y" 'copy-to-clipboard-visual)
(define-key evil-normal-state-map "Y" 'evil-yank-fake)
                                        ; Global for all buffers
(global-set-key (kbd "C-p") (lambda () (interactive) (evil-paste-from-register ?+)))
(setq-default evil-escape-key-sequence "jk")

(use-package! org
  :config
  (setq org-ellipsis " ▾")
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-files
        '("~/.config/emacs/orgfiles/tasks.org"))
  (setq org-log-done 'time)
  (setq org-log-drawer t)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

                                        ; ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))))

  (setq org-tag-alist
        '((:startgroup)
                                        ; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i)))

  (setq org-refile-targets
        '(("orgfiles/archive.org" :maxlevel . 1)
          ("orgfiles/tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  )

(defun ex/org-mode-visual-fill ()
  (setq visual-fill-column-width 200
    visual-fill-column-center-text t)
  (setq-default visual-fill-column-width 103)
  (setq-default display-line-number-mode nil)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . ex/org-mode-visual-fill))

(org-babel-do-load-languages
'org-babel-load-languages
'((emacs-lisp . t)
  (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; Automatically tangle our Emacs.org config file when we save it
(defun ex/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
              (expand-file-name "~/.config/doom/config.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'ex/org-babel-tangle-config)))
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python3"))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package! evil-collection)
  (use-package! dired
  :ensure nil
  :init
 (setq dired-listing-switches "-aBhl  --group-directories-first")
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

  (use-package! magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started




