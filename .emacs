;; Package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
;; Autocomplete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
;; No welcome screen
(setq inhibit-splash-screen t)
(setq mac-command-modifier 'meta)
(setq-default cursor-type 'box)
;; Indent
(setq c-default-style "linux"
      c-basic-offset 2)
;; Auto-save
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
;; Web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.cpp?\\'" . whitespace-mode))
(add-to-list 'auto-mode-alist '("\\.cpp?\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(require 'emmet-mode)
(setq-default indent-tabs-mode nil)
;; F11 = Full Screen
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
      (if (equal 'fullboth current-value)
        (if (boundp 'old-fullscreen) old-fullscreen nil)
        (progn (setq old-fullscreen current-value)
          'fullboth)))))
(global-set-key [f11] 'toggle-fullscreen)

;; Make C-h delete
(global-set-key "\C-h" 'backward-delete-char)
(normal-erase-is-backspace-mode 1)
(defun my-backward-delete-fun() "backward delete a char or delete selected region automic" (interactive) (if (and transient-mark-mode mark-active) (call-interactively 'kill-region) (call-interactively 'backward-delete-char-untabify)))
(global-set-key [backspace] 'my-backward-delete-fun)
;; ENABLE IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)
(setq ido-use-filename-at-point 'guess)
;; Make backspace delete region
;;(setq delete-active-region nil)
;;(delete-selection-mode nil)
;; Show matching parenthesis
(show-paren-mode t)
(setq show-paren-style 'expression)
;; do not blink cursor
(blink-cursor-mode -1)
;; make bars disappear
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
;; bind f3 to undo
(global-set-key [f3] 'undo)
;; goto line
(global-set-key "\M-l" 'goto-line)
;; prevent creating backup files
(setq make-backup-files nil)
;; make ENTER indent
(global-set-key "\C-j" 'newline-and-indent)
(global-set-key (kbd "C-<return>") 'newline-and-indent)
;; f1 toggle
(global-set-key [f1] 'hs-toggle-hiding)
;; goto EOF
(global-set-key "\M-e" 'end-of-buffer)
;; display column number
(setq column-number-mode t)

;; other window
(global-set-key "\C-x\C-n" 'other-window)

;; back to previous window
(defun other-window-backward()  ;; defun + functionName(para list)
  "select the previous window." ;; docstring
  (interactive )
  (other-window -1))            ;; function body
(global-set-key "\C-x\C-p" 'other-window-backward)

;; avoid symlink  can use lambda
(defun read-only-if-symlink ()
  (if (file-symlink-p buffer-file-name)
      (progn  ;; evaluates the following TWO expressions before return
	(setq buffer-read-only t)
	(message "File is a symlink"))))
(add-hook 'find-file-hooks 'read-only-if-symlink)

;; togle hs hiding
(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
          (hs-toggle-hiding)
          (error t))
          (hs-show-all))
    (toggle-selective-display column)))
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)

(global-set-key [f1] 'hs-toggle-hiding)

;; Trailing whitespace is pure evil
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq auto-mode-alist (cons '("\\.c0" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.js" . js2-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.html" . web-mode) auto-mode-alist))
(defun xah-syntax-color-hex ()
"Syntax color hex color spec such as 「#ff1100」 in current buffer."
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[abcdef[:digit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-fontify-buffer)
  )
(global-set-key (kbd "C-c d") 'insert-date)
(add-hook 'css-mode-hook 'xah-syntax-color-hex)
(add-hook 'html-mode-hook 'xah-syntax-color-hex)

;;(setq emmet-preview-default nil)
(global-set-key [C-tab] 'emmet-expand-line)
;; whitespace
(require 'whitespace)
(setq whitespace-style '(face tabs lines tab-mark))
(add-hook 'c-mode-hook
  (function (lambda ()
              (whitespace-mode t))))
(add-hook 'c++-mode-hook
  (function (lambda ()
              (whitespace-mode t))))
(add-hook 'python-mode-hook
  (function (lambda ()
              (whitespace-mode t))))
(add-hook 'sml-mode-hook
  (function (lambda ()
              (whitespace-mode t))))

(global-hl-line-mode 1)

(global-set-key (kbd "M-1") 'delete-window)
(global-set-key (kbd "M-0") 'delete-other-windows)
