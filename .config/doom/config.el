(setq user-full-name "håvard syslak"
      user-mail-address "haavard.syslak@gmail.com")
(set-frame-parameter (selected-frame) 'alpha '(98 . 94))
(add-to-list 'default-frame-alist '(alpha . (98 . 94)))
(add-to-list 'load-path "/home/syslak/.local/bin")

(setq doom-font (font-spec :family "Liberation Mono" :size 13))
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

(setq org-directory "~/uisfiles/org/")

(after! org
  (add-hook 'org-mode-hook (lambda ()(org-bullets-mode 1)))
  (setq org-agenda-files '("~/uisfiles/org/agenda.org")
        org-ellipsis " ↓↓ "
        org-log-done 'time
        org-latex-caption-above nil
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
(defvar +org-capture-todo-file "agenda.org")
(setq org-roam-directory "~/uisfiles/org/roam")

(setq org-latex-pdf-process '("latexmk -shell-escape -f -pdf -%latex -interaction=nonstopmode -output-directory=%o %f"))
(setq org-latex-listings 'minted)

(setq display-line-numbers-type `relative
      shell-file-name "/usr/bin/zsh")

(setq x-select-enable-clipboard nil)
; (define-key evil-mode-map "y" "\S-2 y")
;(define-key evil-mode-map (kbd "S-2 "))

; (map! :leader
      ; :desc "Yank from / to clipboard"
     ;

(setq! lsp-clients-python-command "/home/syslak/.local/bin/pylsp")
(setq! lsp-pylsp-server-command "/home/syslak/.local/bin/pylsp")
(after! lsp-mode
        (setq lsp-enable-symbol-highlighting nil)
        (setq lsp-completion-enable-additional-text-edit nil)
        ;;(setq lsp-pyls-disable-warnings t)
        (setq lsp-pylsp-plugins-jedi-signature-help-enabled nil)
;        (setq lsp-pylsp-plugins-yapf-enabled t)
        (setq lsp-pylsp-plugins-autopep8-enabled nil)
        (setq lsp-pylsp-plugins-pycodestyle-enabled nil)
        (setq lsp-pylsp-plugins-pycodestyle-max-line-length 150)
        (setq lsp-pylsp-plugins-flake8-max-line-length 150)
        (setq lsp-pylsp-plugins-docstyle-max-line-length 150)
        (setq lsp-signature-render-documentation nil)
        (setq lsp-pylsp-plugins-pydocstyle-enabled nil)
        (setq lsp-pylsp-plugins-flake8-ignore "E302")
        )
(after! lsp-ui
  (setq lsp-ui-doc-position 'bottom)
  (setq lsp-lens-enable nil))

(map! :leader
      :desc "Lsp describe thing at point"
      "k k" #'lsp-describe-thing-at-point
      :leader
      :desc "Dash lookup"
      "k d" #'+lookup:dash)

(after! company-mode
  (setq company-idle-delay 0.0))

;; (map! :leader
;;       :desc "Dap toggle breakpoint"
;;       "q b" #'dap-breakpoint-toggle
;;       :leader
;;       :desc "Dap-start debugger"
;;       "q s" #'dap-debug
;;       :leader
;;       :desc "Dap debug last"
;;       "q q" #'dap-debug-last
;;       :leader
;;       :desc "Dap restart debugger"
;;       "q r" #'dap-debug-restart)

;; (use-package dap-mode
;;   :commands dap-debug)

;; ; (require 'dap-python)
;; (require 'dap-cpptools)
;; (require 'dap-lldb)
;; (require 'dap-gdb-lldb)

;; ;(after! python-mode
;; ;  (dap-python-debugger 'debugpy))

;;   (dap-register-debug-template
;;    "Rust::LLDB Run Configuration"
;;    (list :type "lldb"
;;          :request "launch"
;;          :name "LLDB::Run"
;; 	 :gdbpath "rust-lldb"
;;          :target nil
;;          :cwd nil))

;; (dap-register-debug-template "Rust::GDB Run Configuration"
;;                              (list :type "gdb"
;;                                    :request "launch"
;;                                    :name "GDB::Run"
;;                            :gdbpath "rust-gdb"
;;                                    :target nil
;;                                    :cwd nil))
;(dap-register-debug-template
   ;"rinit::Run"
   ;(list :type "gdb"
         ;:request "launch"
         ;:name "GDB::Run"
         ;:gdbpath "rust-gdb"
         ;:target "${workspaceFolder}/target/debug/rinit"
         ;:cwd "${worksapceFolder}"))

(after! cc-mode
  (define-key c-mode-base-map (kbd "<tab>") 'tab-to-tab-stop)
  (define-key c-mode-base-map [tab] 'tab-to-tab-stop))

(map! :leader
      :desc "Dired"
      "d d" #'dired
      :leader
      :desc "Dired jump to current"
      "d j" #'dired-jump
      :leader
      :desc "mkdir"
      "d m" #'make-directory
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

(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

(setq yas-triggers-in-field t)
