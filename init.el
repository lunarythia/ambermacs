(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)))

  (setq org-confirm-babel-evaluate nil)

  (with-eval-after-load 'org
    (require 'org-tempo)

    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))))

(set-input-method 'english-dvorak)   ; change the keyboard layout to dvorak (lol sorry, QWERTY)

(setq make-backup-files nil)

(setq gc-cons-threshold (* 100 1000 1000))

(setq vc-follow-symlinks nil)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
(require 'package)
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(custom-set-variables
 '(custom-safe-themes   '("da53441eb1a2a6c50217ee685a850c259e9974a8fa60e899d393040b4b8cc922" default))
 '(org-hide-emphasis-markers t)
 '(package-selected-packages
   '(visual-fill-column visual-fill org-bullets magit general doom-themes ivy-rich which-key rainbow-delimiters doom-modeline counsel swiper ivy org-roam ##)))
(custom-set-faces
 '(bold-italic ((t (:overline t :weight bold))))
 '(italic ((t (:overline t :slant italic)))))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(setq visible-bell t)   ; use visible bell

(column-number-mode)    ; add column numbers

; display line numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers 't)

; hide line numbers for certain modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
        (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq inhibit-splash-screen t)   ; get rid of that nasty splash screen

(tool-bar-mode -1)     ; disable toolbar
(tooltip-mode -1)      ; disable tooltips
(set-fringe-mode 10)   ; a bit more room
(menu-bar-mode -1)     ; disable menubar

; Word wrapping
(global-visual-line-mode 1)

; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

; Rainbow mode (show colours)

(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(defun aw/font-setup ()
    (set-frame-font "Fira Code 11" nil t)
    (set-face-attribute 'fixed-pitch nil :font "Fira Code")
    (set-face-attribute 'variable-pitch nil :font "PT Sans" :height 118))

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (setq doom-modeline-icon t)
                (with-selected-frame frame
                  (aw/font-setup))))
    (aw/font-setup))

(use-package doom-themes
:config
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)
(setq doom-themes-treemacs-theme "doom-colors")
(doom-themes-treemacs-config)
(doom-themes-org-config))

(load-theme 'ambria t)   ; change theme to a dark theme (and also just a better theme lol)

(defun aw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode))

(defun aw/org-font-setup ()
  (with-eval-after-load 'org-faces
; Change font of title
    (set-face-attribute 'org-document-title nil :font "Roboto Slab" :weight 'bold :height 1.65)
; Make the Heading fonts a different size
    (dolist (face '((org-level-1 . 1.55)
                    (org-level-2 . 1.525)
                    (org-level-3 . 1.5)
                    (org-level-4 . 1.475)
                    (org-level-5 . 1.45)
                    (org-level-6 . 1.4)
                    (org-level-7 . 1.35)
                    (org-level-8 . 1.3)))
    (set-face-attribute (car face) nil :font "Roboto Slab" :height (cdr face)))
; Make sure some things are still monospaced
    (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-block-begin-line nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-block-end-line nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-table nil :inherit 'fixed-pitch)))

(use-package org
  :hook (org-mode . aw/org-mode-setup)
  :bind (("C-o" . org-open-at-point))
  :config
  (setq org-ellipsis " ▼")
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-agenda-files
        '("~/orgroam/20220109100907.org"
          "~/orgroam/20220109114152.org"
          "~/orgroam/20220106002944.org"))
  (setq org-refile-targets
        '(("~/orgroam/20220109130559.org" :maxlevel . 1)
          ("~/orgroam/20220106002944.org" :maxlevel . 1)
          ("~/orgroam/20220109100907.org" :maxlevel . 1)
          ("~/orgroam/20220109131107.org" :maxlevel . 1)))
  ; Make sure that all of the org files are saved every time you refile something
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-capture-templates
        '(("t" "Task" entry (file+olp "~/orgroam/20220109100907.org" "Inbox")
           "* TODO %?\n %U\n %a\n %i" :empty-lines 1)
          ("j" "Journal" entry (file+olp+datetree "~/orgroam/20220109145805.org")
           "\n* %<%I:%M %p> - Journal\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)))

  (aw/org-font-setup))

; center org mode stuff
(defun aw/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . aw/org-mode-visual-fill))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("❀" "❁" "♡" "♥" "●" "○" "▲")))

; change bullets to look like ✧
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "✧"))))))
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([+]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "✧"))))))

(use-package org-roam
  :after org
  :commands org-roam-node-find
  :ensure t
  :custom
  (org-roam-directory "~/orgroam")
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :bind (;("C-C n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(use-package org-tree-slide
  :commands org-tree-slide-mode
  :custom
  (org-tree-slide-in-effect n)
  (org-tree-slide-activate-message "Presentation started.")
  (org-tree-slide-deactivate-message "Presentation finished")
  (org-tree-slide-breadcrumbs " » ")
  (org-image-actual-width nil))

(use-package org-mime
  :after mu4e
  :config
  (setq org-mime-export-options '(
                                  :section-numbers nil
                                  :with-author nil
                                  :with-toc nil)))

(add-hook 'message-send-hook 'org-mime-htmlize)

(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "p" (format "color: %s"
                         "#140023"))))
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "h1" (format "color: %s"
                          "#140023"))))
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "h2" (format "color: %s"
                          "#140023"))))
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "h3" (format "color: %s"
                          "#140023"))))
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "h4" (format "color: %s"
                          "#140023"))))
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "h5" (format "color: %s"
                          "#140023"))))
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "h6" (format "color: %s"
                          "#140023"))))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-clients-typescript-tls-path "~/.nvm/versions/node/v17.3.0/bin/typescript-language-server"))

(use-package lsp-ui
:hook (lsp-mode . lsp-ui-mode)
:custom
(lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

; ivy autocomplete
(use-package ivy
  :diminish
  :defer 0
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :custom (ivy-use-selectable-prompt t))
(ivy-mode 1)

(with-eval-after-load 'ivy
  (use-package ivy-rich
    :after ivy)
  (ivy-rich-mode 1))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; rebind keys
(use-package general
  :config
  (general-create-definer aw/leadkey
    :keymaps '(normal)
    :prefix "SPC"
    :global-prefix "C-a")
  (aw/leadkey
    "" 'nil
    "SPC" '(counsel-M-x :which-key "command")

    "a" '(org-agenda :which-key "agenda")

    "e" '(mu4e :which-key "mu4e")

    "g" '(magit-status :which-key "git")
    )

  (general-create-definer aw/leadkey/buffer
    :keymaps '(normal)
    :prefix "SPC b")
  (aw/leadkey/buffer
    "" '(:which-key "buffer")
    "k" '(kill-buffer :which-key "kill buffer")
    "b" '(switch-to-buffer :which-key "switch buffer"))

  (general-create-definer aw/leadkey/capture
    :keymaps '(normal)
    :prefix "SPC c")
  (aw/leadkey/capture
    "" '(:which-key "capture")
    "j" '((lambda () (interactive) (org-capture nil "j")) :which-key "journal")
    "t" '((lambda () (interactive) (org-capture nil "t")) :which-key "task"))

  (general-create-definer aw/leadkey/file
    :keymaps '(normal)
    :prefix "SPC f")
  (aw/leadkey/file
    "" '(:which-key "file")
    "f" '(find-file :which-key "open file")
    "s" '(save-buffer :which-key "save buffer"))

  (general-create-definer aw/leadkey/help
    :keymaps '(normal)
    :prefix "SPC h")
  (aw/leadkey/help
    "" '(:which-key "help")
    "f" '(describe-function :which-key "describe function")
    "k" '(describe-key :which-key "describe keybinding")
    "v" '(describe-variable :which-key "describe variable"))

  (general-create-definer aw/leadkey/roam
    :keymaps '(normal)
    :prefix "SPC r")
  (aw/leadkey/roam
    "" '(:which-key "org roam")
    "f" '(org-roam-node-find :which-key "find node")
    "i" '(org-roam-node-insert :which-key "insert node"))

  (general-create-definer aw/leadkey/toggle
    :keymaps '(normal)
    :prefix "SPC t")
  (aw/leadkey/toggle
    "" '(:which-key "toggle / change")
    "i" '(set-input-method :which-key "input method")
    "t" '(counsel-load-theme :which-key "choose theme"))

  (general-create-definer aw/leadkey/mu4e
    :states 'normal
    :keymaps 'mu4e-compose-mode-map
    :prefix "SPC m")
  (aw/leadkey/mu4e
    "" '(:which-key "mu4e compose")
    "f" '(message-send-and-exit :which-key "finish")
    "c" '(mu4e-message-kill-buffer :which-key "cancel"))

  ;; Org-specific bindings
  (general-create-definer aw/leadkey/org
    :states 'normal
    :keymaps 'org-mode-map
    :prefix "SPC m")
  (aw/leadkey/org
    "" '(:which-key "org")
    "o" '(org-open-at-point :which-key "open")
    "t" '(org-babel-tangle :which-key "tangle"))
  (general-create-definer aw/leadkey/org/capture
    :states 'normal
    :keymaps 'org-capture-mode-map
    :prefix "SPC m m")
  (aw/leadkey/org/capture
    "" '(:which-key "capture")
    "c" '(org-capture-kill :which-key "cancel")
    "f" '(org-capture-finalize :which-key "finish"))

  ;; With-editor-specific bindings
  (general-create-definer aw/leadkey/witheditor
    :states 'normal
    :keymaps 'with-editor-mode-map
    :prefix "SPC m")
  (aw/leadkey/witheditor
    "" '(:which-key "with-editor")
    "c" '(with-editor-cancel :which-key "cancel")
    "f" '(with-editor-finish :which-key "finish"))
  (general-define-key
   "C-x b" 'counsel-switch-buffer)
  (general-define-key
   "C-C n f" 'org-roam-node-find))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 5)
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "exit" :exit t))
(aw/leadkey
  "ts" '(hydra-text-scale/body :which-key "scale-text"))

(defun aw/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "/home/[redacted]/emacs.org"))

    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'aw/org-babel-tangle-config)))

(setq gc-cons-threshold (* 2 1000 1000))
