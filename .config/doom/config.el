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
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12))

;; Emoji fallback: JetBrains Mono (even Nerd Font) has no color emoji glyphs.
(after! doom-ui
  (set-fontset-font t 'emoji (font-spec :family "Noto Color Emoji") nil 'prepend))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(setq scroll-margin 8)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/vault/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

(defvar my/session-search-roots '("~/repos")
  "Directories `my/session--fd-directories' searches for the session switcher.")

(defvar my/session-fd-max-depth 1
  "Max depth fd descends under each of `my/session-search-roots'.")

(defvar my/session-candidates--meta nil
  "Hash table mapping a candidate display string to a plist (:kind :name :path).
Rebuilt on every `my/session-switcher' invocation; the plain-string keys (not text
properties) are what survive `completing-read', so lookups use `gethash' on the
returned string rather than `get-text-property'.")

(defvar my/session-switcher-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-<return>") #'my/session-use-typed-text)
    (define-key map (kbd "C-t") #'my/session-force-new-from-candidate)
    map))

(defvar my/session-switcher-exit-action nil
  "Set by the special keybindings to signal *how* the minibuffer was exited.")

(defun my/session-use-typed-text ()
  "Ignore any highlighted candidate; use exactly what's typed as a new bare-name session."
  (interactive)
  (setq my/session-switcher-exit-action 'literal)
  (exit-minibuffer))

(defun my/session-force-new-from-candidate ()
  "Force-create a new terminal at whatever candidate is currently highlighted."
  (interactive)
  (when (fboundp 'vertico-insert) (vertico-insert)) ; pulls highlighted candidate into the input
  (setq my/session-switcher-exit-action 'force-new)
  (exit-minibuffer))

(defun my/session--fd-directories ()
  "Return directories found by fd under `my/session-search-roots'."
  (seq-uniq
   (seq-mapcat
    (lambda (root)
      (let ((root (expand-file-name root)))
        (when (file-directory-p root)
          (split-string
           (shell-command-to-string
            (format "fd . %s --type d --max-depth %d --exclude .git --exclude node_modules"
                    (shell-quote-argument root)
                    my/session-fd-max-depth))
           "\n" t))))
    my/session-search-roots)))

(defun my/session-candidates ()
  "Build fuzzy-search candidates: open workspaces + known Projectile projects + fd dirs.
Populates `my/session-candidates--meta' as a side effect."
  (setq my/session-candidates--meta (make-hash-table :test #'equal))
  (let (cands)
    (dolist (name (+workspace-list-names))
      (let ((disp (format "%s  [workspace]" name)))
        (puthash disp (list :kind 'workspace :name name :path nil) my/session-candidates--meta)
        (push disp cands)))
    (dolist (proj (and (fboundp 'projectile-relevant-known-projects)
                        (projectile-relevant-known-projects)))
      (let* ((dir (directory-file-name proj))
             (name (file-name-nondirectory dir))
             (disp (format "%s  [project] %s" name proj)))
        (puthash disp (list :kind 'project :name name :path proj) my/session-candidates--meta)
        (push disp cands)))
    (dolist (dir (my/session--fd-directories))
      (let* ((name (file-name-nondirectory (directory-file-name dir)))
             (disp (format "%s  [dir] %s" name dir)))
        (unless (gethash disp my/session-candidates--meta)
          (puthash disp (list :kind 'dir :name name :path dir) my/session-candidates--meta)
          (push disp cands))))
    (nreverse cands)))

(defun my/session--unique-name (name)
  "Return NAME, or NAME suffixed with a random number if it collides with an open workspace."
  (if (member name (+workspace-list-names))
      (concat name "-" (number-to-string (random 1000)))
    name))

(defun my/session--dispatch (choice)
  "Plain-RET behavior: switch to CHOICE if it names an open workspace, otherwise
create+switch to a new workspace and vterm for the project/directory it names."
  (let* ((meta (gethash choice my/session-candidates--meta))
         (kind (plist-get meta :kind)))
    (cond
     ((eq kind 'workspace)
      (+workspace-switch (plist-get meta :name) t))
     ((memq kind '(project dir))
      (+workspace-switch (my/session--unique-name (plist-get meta :name)) t)
      (let ((default-directory (plist-get meta :path))) (vterm)))
     (t
      ;; typed text matching no known candidate: same as C-RET
      (+workspace-switch (my/session--unique-name choice) t)
      (vterm)))))

(defun my/session-switcher ()
  (interactive)
  (let* ((candidates (my/session-candidates))
         (my/session-switcher-exit-action nil)
         (cwd default-directory)
         (choice
          (minibuffer-with-setup-hook
              (:append (lambda ()
                         (use-local-map
                          (make-composed-keymap my/session-switcher-map (current-local-map)))))
            (completing-read "Session: " candidates nil nil))))
    (pcase my/session-switcher-exit-action
      ('literal
       ;; C-RET: exactly what you typed, new session at current dir, no path/candidate logic
       (+workspace-switch (my/session--unique-name choice) t)
       (let ((default-directory cwd)) (vterm)))
      ('force-new
       ;; C-t: highlighted candidate, but always spin up a fresh terminal there
       (let* ((meta (gethash choice my/session-candidates--meta))
              (dir (or (plist-get meta :path) cwd))
              (base-name (or (plist-get meta :name)
                              (file-name-nondirectory (directory-file-name dir)))))
         (+workspace-switch (my/session--unique-name base-name) t)
         (let ((default-directory dir)) (vterm))))
      (_
       ;; plain RET: switch-or-create dispatch
       (my/session--dispatch choice)))))

(map! :leader :desc "Session switcher" "TAB TAB" #'my/session-switcher)
