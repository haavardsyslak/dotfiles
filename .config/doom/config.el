;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(defvar +org-capture-todo-file "agenda.org")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Håvard Syslak"
      user-mail-address "haavard.syslak@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "Liberation Mono" :size 14))
      ;(doom-variable-pitch-font (font-spec :family "monospace" :size 13)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-pro)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-comment-face :slant italic))
  ;; '(flycheck-error nil :underline '(color: "#CC6666" :style nil)))


;
;(set-foreground-color "#282828")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(after! org
  (add-hook 'org-mode-hook (lambda ()(org-bullets-mode 1)))
  (setq org-directory "~/uisfiles/org/"
        org-agenda-files '("~/uisfiles/org/agenda.org")
        org-ellipsis " ↓↓ "
        org-log-done 'time
        )
  ;; Capture templates
  (setq org-capture-templates
        '(("t" "Task Entry" entry
           (file+olp "~/uisfiles/org/agenda.org" "Inbox")
           "* TODO %?\n:PROPERTIES:\n:CREATED:%U\n:END:\n%i\n"
           :kill-buffer t)
          ))
  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("agenda.org" :maxlevel . 1)))

  (advice-add 'org-refile :after 'org-save-all-org-buffers)

)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'. Default was t'
(setq display-line-numbers-type `relative)

;; Shell
;; (setq shell-file-name "/usr/bin/fish")
(setq shell-file-name "/usr/bin/zsh")


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys


;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Dired

(map! :leader
      :desc "Dired"
      "d d" #'dired
      :leader
      :desc "Dired jump to current"
      "d j" #'dired-jump
      (:after dired
        (:map dired-mode-map
         :leader
         :desc "Peep-dired image previews"
         "d p" #'peep-dired
         :leader
         :desc "Dired view file"
         "d v" #'dired-view-file)))
;; Make 'h' and 'l' go back and forward in dired. Much faster to navigate the directory structure!
(evil-define-key 'normal dired-mode-map
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file) ; use dired-find-file instead if not using dired-open package
;; If peep-dired is enabled, you will get image previews as you go up/down with 'j' and 'k'
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)

(map! :leader
      :desc "Lsp describe thing at point"
      "k k" #'lsp-describe-thing-at-point
      :leader
      :desc "Dash lookup"
      "k d" #'+lookup:dash)


;; (add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;; Get file icons in dired

;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

 ;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
 ;;(set-frame-parameter (selected-frame) 'alpha <both>)
 (set-frame-parameter (selected-frame) 'alpha '(98 . 94))
 (add-to-list 'default-frame-alist '(alpha . (98 . 94)))

;; Latex auxtex
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)

;; Enable PDF from DVI creation
;; (setq TeX-PDF-from-DVI "Dvips")

(after! company-mode
  (setq company-idle-delay 0.0))

(after! lsp-mode
        (setq lsp-enable-symbol-highlighting nil)
        (setq lsp-completion-enable-additional-text-edit nil)
        ;;(setq lsp-pyls-disable-warnings t)
        (setq lsp-pyls-plugins-jedi-signature-help-enabled nil)
        (setq lsp-pyls-plugins-yapf-enabled t)
        (setq lsp-pyls-plugins-autopep8-enabled nil)
        (setq lsp-pyls-plugins-pycodestyle-enabled nil)
        )
(after! lsp-ui
  (setq lsp-ui-doc-position 'bottom))


;; DAP mode
(map! :leader
      :desc "Dap toggle breakpoint"
      "q b" #'dap-breakpoint-toggle
      :leader
      :desc "Dap-start debugger"
      "q s" #'dap-debug
      :leader
      :desc "Dap debug last"
      "q q" #'dap-debug-last
      :leader
      :desc "Dap restart debugger"
      "q r" #'dap-debug-restart)



(use-package dap-mode
  :commands dap-debug)

(require 'dap-python)

(after! python-mode
  (dap-python-debugger 'debugpy))
