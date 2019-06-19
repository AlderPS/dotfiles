;;; .emacs --- Initialization file for Emacs
;;; Commentary:
;;;     This is my personal configuration. It is personally written for my use of GNU/Emacs as a
;;; software development environment, as a general text editor and for notes with OrgMode. 
;;;
;;; --------------------------------------------------------------------------------------
;;;
;;;     Remembering keys:
;;;     ¶ Lists all buffers running: 'C-x C-b';
;;;     ¶ Activates the menu bar: 'F10';
;;;     ¶ Saves buffer to a different file: 'C-x C-w';
;;;     ¶ Shows the Emacs FAQ info page: 'C-h i';
;;;     ¶ Move forward or backward by s-expression: 'C-M-f', 'C-M-b';
;;;     ¶ Move forward or backward by paragraph: 'M-}', 'M-{';
;;;     ¶ Scroll down one page: 'C-v';
;;;     ¶ Scroll up one page: 'M-v';
;;;     ¶ 'C-x 8 C-h' will display a list of keys commands and its symbols;
;;;     ¶ View subtree on Orgmode: 'C-x n s'
;;;     ¶ Zoom out: 'C+x n w'
;;;     ¶ NeoTree:
;;; 	¶ C-c C-n Create a file or create a directory if filename ends with a ‘/’;
;;; 	¶ C-c C-d Delete a file or a directory.
;;;		¶ C-c C-r Rename a file or a directory.
;;; 	¶ C-c C-p Copy a file or a directory.
;;;		¶ C-x h	Select entire buffer.
;;;
;;; --------------------------------------------------------------------------------------
;;; 'byte-compile-file' this file
;;; --------------------------------------------------------------------------------------

;;; Autor: AlderPS

;;; Code:

;; These lines should be first, so Emacs doesn't blink nor does it resize its window on startup:
(setq initial-frame-alist '((width . 105)))				; Window size;
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))	; hide scroll bar;
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))		; hide menu bar;
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))		; hide toolbar;
(setq inhibit-startup-screen t)
(set-face-attribute 'default nil
					:family "Hack" :height 85
					:weight 'normal :width 'normal)		; Set default font and size;
(normal-erase-is-backspace-mode 1)

                                        ; -=[ Package repositories:

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.milkbox.net/packages/"))
(package-initialize)

                                        ; -=[ Packages declarations:

(require 'dashboard)
(require 'helm)
(require 'powerline)
(require 'airline-themes)
(require 'highline)
(require 'neotree)
(require 'all-the-icons)
(require 'move-text)
(require 'autopair)
(require 'auto-complete-config)
(require 'fill-column-indicator)
(require 'cc-mode)

                                       ; -= [ General packages configurations:

;; Emacs Dashboard:
(dashboard-setup-startup-hook)
(setq dashboard-center-content t)
(setq dashboard-set-heading-icons t)	;show icons on head titles
(setq dashboard-set-file-icons t)
(setq dashboard-show-shortcuts nil)		;hide shortcut indicators
(setq dashboard-startup-banner '2)		;'official, 'logo, '1, '2, '3
(setq dashboard-items '((recents . 5)
						(bookmarks . 5)
						(agenda . 5)))

;; Helm:
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-x") 'helm-M-x)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z")  'helm-select-action)
(defun helm-display-mode-line (source &optional force) (setq powerline t))

;; Powerline:
(powerline-default-theme)
(setq powerline-default-separator 'zigzag) 
;; Values: alternate, arrow, arrow-fade, bar, box, brace, butt, chamfer, contour, curve, rounded,
;; roundstub, wave, zigzag, utf-8.

;; Airline themes:
(load-theme 'airline-molokai t)

;; Highlight current line:
(global-highline-mode t)

;; Neotree:
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; Move text:
(move-text-default-bindings)

;; Autopair:
(autopair-global-mode 1)
(setq autopair-autowrap t)

;; Actual theme:
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)

;; Auto-complete:
(ac-config-default)

                                        ; -=[ Function definitions:

;; Create a new empty buffer:
(defun open-new-buffer ()
  "Open a empty buffer on the same frame."
  (interactive)
  (let ((buffer (generate-new-buffer "untitled")))
    (set-buffer-major-mode buffer)
    (display-buffer buffer '(display-buffer-same-window . nil))))

(global-set-key (kbd "C-c n") #'open-new-buffer)

;; Create a new org empty buffer:
(defun open-empty-org-buffer ()
  "Open a empty buffer with 'org-mode' on  major mode."
  (interactive)
  (let ((buffer (generate-new-buffer "untitled")))
    (set-buffer-major-mode buffer)
    (with-current-buffer buffer
      (org-mode))
    (display-buffer buffer '(display-buffer-same-window . nil))))

(global-set-key (kbd "C-c o") #'open-empty-org-buffer)

;; Comment or uncomment region like Eclipse:
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))

(global-set-key (kbd "C-/") 'comment-or-uncomment-region-or-line)

                                        ; -=[ General customizations:

;; Some faces configurations:
(custom-theme-set-faces
 'user
 '(highline-face ((t (:background "gray20"))))
 '(linum-highlight-face ((t (:inherit default :foreground "#66D9EF"))))
 '(org-level-1 ((t (:foreground "#E7DB74" :weight normal :height 85 :family "Hack"))))
 '(org-level-2 ((t (:foreground "#67D8EF" :weight normal :height 85 :family "Hack"))))
 '(org-level-3 ((t (:foreground "#A6E22C" :weight normal :height 85 :family "Hack"))))
 '(org-level-4 ((t (:foreground "#F92472" :weight normal :height 85 :family "Hack"))))
 '(show-paren-match ((t (:background "#66D9EF" :foreground "transparent" :weight bold))))
 '(dashboard-text-banner ((t (:foreground "#66D9EF" :weight bold))))
 '(dashboard-heading ((t (:foreground "#E7DB74" :weight bold))))
 '(minibuffer-prompt ((t (:background "gray20" :foreground "#E7DB74")))))

                                        ; -=[ General configurations:

;; Shows current buffer name at title bar:
(setq frame-title-format '("%b"))

;; Line number column:
(add-hook 'c-mode-hook (lambda () (linum-mode 1)))
(add-hook 'lisp-mode-hook (lambda () (linum-mode 1)))
(add-hook 'java-mode-hook (lambda () (linum-mode 1)))
(add-hook 'emacs-lisp-mode-hook (lambda () (linum-mode 1)))

;; Current line number highlight:
(hlinum-activate)

;; Show paren mode, delay dactivated first:
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Change "yes or no" to "y or n":
(fset 'yes-or-no-p 'y-or-n-p)

;; Change Point from bean to bar:
(setq-default cursor-type 'bar)

;; Don't blink the cursor:
(blink-cursor-mode 0)

;; C-z undo:
(global-set-key (kbd "C-z") 'undo)

;; Replaces region with typed text:
(delete-selection-mode 1)

;; Directory for backup files:
(setq backup-directory-alist '(("." . "~/.emacs_bkp_files")))

;; Go to line like Eclipse:
(global-set-key (kbd "C-l") 'goto-line)

;; Uppercases the region: 'C-x C-u';
(global-set-key (kbd "C-S-x") 'upcase-region)

;; Lowercases the region: 'C-x C-l';
(global-set-key (kbd "C-S-y") 'downcase-region)

                                         ; -= [ Org mode configuration:

;; The following lines are always needed:
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

;; Multi-state workflows for Org mode:
(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)")
        (sequence "FIXME(f)" "BUG(b)" "|" "FIXED(x)")))

;; Enable select with 'Shift':
(setq org-support-shift-select t)

                                        ; -=[ General programming configurations:

;; Foldthis:
(global-set-key (kbd "C-c C-f") 'fold-this-all)
(global-set-key (kbd "C-c C-F") 'fold-this)
(global-set-key (kbd "C-c M-f") 'fold-this-unfold-all)

;; Margin column:
(setq fci-rule-column 100)
(setq fci-rule-color "gray20")
(add-hook 'c-mode-hook (lambda ()
						 (fci-mode 1)))
(add-hook 'emacs-lisp-mode-hook (lambda ()
						 (fci-mode 1)))
(add-hook 'lisp-mode-hook (lambda ()
						 (fci-mode 1)))
(add-hook 'java-mode-hook (lambda ()
						 (fci-mode 1)))

                                         ; -=[ C/C++ configuration:

;; Set 'C' coding style:
(setq-default c-basic-offset 4 c-default-style "k&r")
(setq-default tab-width 4 indent-tabs-mode t)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

;; Compile and run 'C' code:
(defun compile_and_run_c ()
  "Call the 'gcc' over the current buffer name and execute the compiled file..."
  (interactive)
  (defvar c-foo)
                                        ; On 'Windows' './a.out' should be 'a.exe'.
  (setq c-foo (concat "gcc " (buffer-name) " && ./a.out" ))
  (shell-command c-foo))
                                        ; Uses 'F5' key to call this:
(global-set-key [f5] 'compile_and_run_c)

										; -=[ Unused configs:

;; (setq initial-frame-alist '((width . 115) (height . 50)))	; Window size;
;; (global-linum-mode t)	; shows line number everywhere;

(provide '.emacs)
;;; .emacs ends here
