(unless (package-installed-p 'autothemer)
  (package-refresh-contents)
  (package-install 'autothemer))

(autothemer-deftheme
 ambria "AmberWing's theme"

 ((((class color) (min-colors #xFFFFFF)))

  (aw-dark        "#140023")
  (aw-dark-2      "#1d0432")
  (aw-dark-3      "#210038")
  (aw-dark-4      "#2d004d")
  (aw-light       "#fccece")
  (aw-light-2     "#e3779d")
  (aw-light-3     "#d23e79")
  (aw-light-4     "#d2356b")
  (aw-2-light     "#d97dfb")
  (aw-2-light-2   "#ce6ff0")
  (aw-2-light-3   "#c243e2")
  (aw-2-light-4   "#b73ada")
  (aw-2-light-5   "#a335ce")
  (aw-2-light-6   "#972ac5")
  (aw-accent      "#38005d")
  (aw-builtin     "#e683ff")
  (aw-comments    "#ec8787")
  (aw-string      "#be69ff")
  (aw-vars        "#f835ff")
  )

 ((default                   (:foreground aw-light :background aw-dark))
  (fringe                    (:background aw-dark))
  (cursor                    (:background aw-light))
  (region                    (:background aw-accent))
  (mode-line                 (:background aw-dark-4))
  (mode-line-inactive        (:background aw-dark-3))
  (doom-modeline-bar         (:background aw-light-4))
  (font-lock-builtin-face    (:foreground aw-builtin))
  (font-lock-comment-face    (:foreground aw-comments))
  (font-lock-constant-face   (:foreground aw-vars))
  (font-lock-string-face     (:foreground aw-string))

  ;; Ivy
  (ivy-highlight-face (:background aw-dark-4))

  ;; Magit
  (magit-section-highlight   (:background aw-dark-4))

  ;; Mu4e
  (mu4e-highlight-face (:background aw-dark-4))
  (mu4e-compose-separator-face (:foreground aw-comments))

  ;; Org mode
  (org-block              (:background aw-dark-2))
  (org-block-begin-line   (:foreground aw-comments :background aw-dark-2))
  (org-block-end-line     (:foreground aw-comments :background aw-dark-2))
  (org-document-title     (:foreground aw-2-light))
  (org-ellipsis           (:foreground nil :underline nil))
  (org-level-1            (:foreground aw-2-light-2))
  (org-level-2            (:foreground aw-2-light-3))
  (org-level-3            (:foreground aw-2-light-4))
  (org-level-4            (:foreground aw-light-2))
  (org-level-5            (:foreground aw-light-3))
  (org-level-6            (:foreground aw-light-4))
  (org-level-7            (:foreground aw-2-light-5))
  (org-level-8            (:foreground aw-2-light-6))
  ))

(provide-theme 'ambria)
