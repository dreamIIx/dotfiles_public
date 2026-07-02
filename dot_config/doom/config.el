;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
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
(setq doom-theme 'doom-dark+)
(setq doom-modeline-enable-word-count nil)
(setq auto-window-vscroll nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Highlights the word/symbol at point and any other occurrences in
;; view. Also allows to jump to the next or previous occurrence.
;; https://github.com/nschum/highlight-symbol.el
(use-package highlight-symbol
  ; :ensure t
  :config
  (setq highlight-symbol-on-navigation-p t)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

;; Emacs minor mode that highlights numeric literals in source code.
;; https://github.com/Fanael/highlight-numbers
(use-package highlight-numbers
  ; :ensure t
  :config
  (add-hook 'prog-mode-hook 'highlight-numbers-mode))

(font-lock-add-keywords 'c++-mode
 `((,(concat
   "\\<[_a-zA-Z][_a-zA-Z0-9]*\\>"       ; Object identifier
   "\\s *"                              ; Optional white space
   "\\(?:\\.\\|->\\)"                   ; Member access
   "\\s *"                              ; Optional white space
   "\\<\\([_a-zA-Z][_a-zA-Z0-9]*\\)\\>" ; Member identifier
   "\\s *"                              ; Optional white space
   "(")                                 ; Paren for method invocation
   1 'font-lock-function-name-face t)))

(dolist (mode-iter '(c-mode c++-mode glsl-mode java-mode javascript-mode rust-mode))
  (font-lock-add-keywords
    mode-iter
    '(("\\([~^&\|!<>=,.\\+*/%-]\\)" 0 'font-lock-operator-face keep)))
  ;; (font-lock-add-keywords
  ;;   mode-iter
  ;;   '(("\\([\]\[}{)(:;]\\)" 0 'font-lock-delimit-face keep)))
  ;; functions
  (font-lock-add-keywords
    mode-iter
    '(("\\([_a-zA-Z][_a-zA-Z0-9]*\\)\s*(" 1 'font-lock-function-name-face keep))))

;; .h files to open in c++-mode rather than c-mode.
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;; emacs-fu: don’t indent inside of C++ namespaces
;; http://brrian.tumblr.com/post/9018043954/emacs-fu-dont-indent-inside-of-c-namespaces
(c-set-offset 'innamespace 0)

;; Spaces instead of tabs when indenting.
(setq-default indent-tabs-mode t)
(setq c-default-style "bsd")
(add-hook 'c-mode-hook (lambda () (c-set-style "bsd")))
(add-hook 'cpp-mode-hook (lambda () (c-set-style "bsd")))
(setq c-basic-indent 4)
(setq c-basic-offset 4)

(beacon-mode 1)

;; enable word-wrap (almost) everywhere
(+global-word-wrap-mode +1)



(setq lsp-enable-symbol-highlighting t)

(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

; (setq scroll-preserve-screen-position 'always)

(after! dap-mode
  (require 'dap-cpptools))

;; (modify-syntax-entry ?_ "w")

;; source: https://tech.tonyballantyne.com/2023/01/23/whitespace-mode/
(use-package! whitespace
  :config
  (setq
    whitespace-style '(face tabs tab-mark spaces space-mark trailing newline newline-mark)
    whitespace-display-mappings '(
      (space-mark   ?\     [?\u00B7]     [?.])
      (space-mark   ?\xA0  [?\u00A4]     [?_])
      (newline-mark ?\n    [182 ?\n])
      (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t])))
  (global-whitespace-mode +1))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(setq lsp-inlay-hint-enable t)

(add-hook 'c-mode-common-hook
          (lambda () (modify-syntax-entry ?_ "w")))


;; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (add-hook 'after-save-hook org-update-statistics-cookies t 'make-it-local)))
(setq org-checkbox-hierarchical-statistics t)
(setq org-html-checkbox-type 'html)

;; author: Derek Taylor (distrotube)
(after! org
  (setq org-directory "~/Documents/org"
        ;; org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("●" "◉" "◌" "✿" "✽" "❆" "◈")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-log-done 'note
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"           ; A task that is ready to be tackled
             "INPROGRESS(i)"
             "BLOCKED(b)"
             "PROJ(p)"           ; A project that contains other tasks
             "PLANNED(l)"
             "WAIT(w)"           ; Something is holding up this task
             "|"                 ; The pipe necessary to separate "active" states and "inactive" states
             "DONE(d)"           ; Task has been completed
             "CANCELLED(c)" ))
	org-todo-keyword-faces
	'(("TODO" . "#6be8a5")
	  ("PLANNED" . "#6be8a5")
	  ("BLOCKED" . "#ff4a4a")
	  ("PROJ" . "#4747ff")
	  ("WAIT" . "#fff98f")
	  ("INPROGRESS" . "#5ec4ff")
	  ("CANCELED" . (:foreground "blue" :weight bold)))
	  )) ; Task has been cancelled

;; author: Derek Taylor (distrotube)
(after! org
  (setq org-agenda-files '("~/Documents/org/agenda.org")))

;; author: Derek Taylor (distrotube)
(setq
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

;; author: Derek Taylor (distrotube)
(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Normal-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo "")))))

(add-hook 'org-agenda-mode-hook 'org-fancy-priorities-mode)
;; (setq org-fancy-priorities-mode 1)

(use-package org-roam
  ; :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/org/roam")
  :bind (("C-c r n" . org-roam-buffer-toggle)
	 ("C-c r f" . org-roam-node-find)
	 ("C-c r i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


(defun update-magit-dirs (&rest _)
  (setq magit-repository-directories (mapcar (lambda (x) `(,x . 2)) projectile-known-projects)))
(advice-add 'magit-status :before 'update-magit-dirs)
(advice-add 'magit-list-repositories :before 'update-magit-dirs)

; (after! magit
;   (setq magit-git-executable (executable-find "git")))
;   (setq magit-repository-directories
;         '(("/path/to/project" . 2)))

(setq git-commit-cd-to-toplevel t)

;; (add-hook 'with-editor-mode-hook
;;           (lambda ()
;;             (corfu-mode -1)))
; (setq magit-process-connection-type t)  ; Force PTY
; (setq magit-git-debug t)  ; Enable git command debugging
; (setq magit-process-verbose t)

;; (use-package exec-path-from-shell
;;   ;; :ensure t
;;   :if (memq window-system '(mac ns x))
;;   :config
;;   (setq exec-path-from-shell-variables '("PATH"))
;;   (exec-path-from-shell-initialize))
;; (setq session-name-disable-regexp "\\(?:\\`'\\.git/[A-Z_]+\\'\\)")
;; (with-eval-after-load 'pointback
;;   (lambda ()
;;     (when (or git-commit-mode git-rebase-mode)
;;       (pointback-mode -1))))
;; (after! dired
;;   (setq diff-hl-dired-ignored-backends (append
;;                                         '((Git) (RCS)))))

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

; Openwith
(openwith-mode t)
(setq openwith-associations
      (list (list (openwith-make-extension-regexp '("pdf"))
                  "okular" '(file))
            (list (openwith-make-extension-regexp '("flac" "mp3" "wav"))
                  "audacious" '(file))
            (list (openwith-make-extension-regexp '("avi" "flv" "mov" "mp4"
                                                    "mpeg" "mpg" "ogg" "wmv"))
                  "mpv" '(file))
            ;; (list (openwith-make-extension-regexp '("bmp" "jpeg" "jpg" "png"))
            ;;       "feh" '(file))
            (list (openwith-make-extension-regexp '("doc" "docx" "odt"))
                  "libreoffice" '("--writer" file))
            (list (openwith-make-extension-regexp '("ods" "xls" "xlsx"))
                  "libreoffice" '("--calc" file))
            (list (openwith-make-extension-regexp '("odp" "pps" "ppt" "pptx"))
                  "libreoffice" '("--impress" file))
            ))

(org-babel-do-load-languages
    'org-babel-load-languages
    '((mermaid . t)
      (scheme . t)))

(setq catppuccin-flavor 'macchiato) ;; or 'latte, 'macchiato, or 'mocha

(after! centaur-tabs
      (setq centaur-tabs-set-bar 'right))
