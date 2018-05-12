
(setq package-archives
      `(("localelpa" . ,(expand-file-name "~/.emacs.d/localelpa"))
        ("gnu"   . "https://elpa.emacs-china.org/gnu/")
        ("melpa" . "https://elpa.emacs-china.org/melpa/")
        ("melpa-stable" . "https://elpa.emacs-china.org/melpa-stable/")))
(package-initialize)
;;(package-refresh-contents)

;;update the dired file timling
(global-auto-revert-mode 1)
(set-language-environment "utf-8")

;;(add-to-list 'load-path "~/.emacs.d/swiper/")
(require 'ivy)
(require 'counsel)
(require 'swiper)
(ivy-mode 1)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c k") 'counsel-ag)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)


(set-face-attribute 'default nil :height 130)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)


(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-x") 'counsel-M-x)
(setq x-select-enable-clipboard t)

;;(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(global-undo-tree-mode)

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(enable-theme 'solarized)
 
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 8)
(setq-default tab-width 8)

;;(add-to-list 'load-path "~/.emacs.d/emacs-counsel-gtags")
;;(setq counsel-gtags-auto-update t)
(defvar hong/counsel-gtags-file-size-too-big 50)

(defun hong/counsel-gtags-find-definition-nowait (tagname)
  (interactive
   (list (if (>
              (nth 7 (file-attributes
                      (concat (file-name-as-directory
                               (counsel-gtags--default-directory))
                              "GTAGS")))
              (* hong/counsel-gtags-file-size-too-big 1024 1024))
             (read-string "Pattern: " (thing-at-point 'symbol t))
           (counsel-gtags--read-tag 'definition))))
  (counsel-gtags--select-file 'definition tagname))

(defadvice counsel-gtags--collect-candidates (after hong/cgcc activate)
  (when (not ad-return-value)
    (error "No Result")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (treemacs git-timemachine multi-term bing-dict rainbow-delimiters smex ggtags flycheck tramp-term find-file-in-project wgrep iedit avy counsel-gtags))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)

(with-eval-after-load 'counsel-gtags
;;  (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-t") 'hong/counsel-gtags-find-definition-nowait)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))


;;(add-to-list 'load-path "~/.emacs.d/evil-surround")
(require 'evil-surround)
;;enable flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'smex)
(smex-initialize)



;;multi-term

(autoload 'multi-term-prev "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(autoload 'multi-term "multi-term" nil t)
(setq multi-term-program "/bin/bash")

(add-hook 'term-mode-hook                                                                                                                         
           (lambda ()
             ;; compatiable
             (setq-local evil-move-cursor-back nil)
             (setq-local evil-escape-inhibit t)
             ;; term
             (setq multi-term-switch-after-close nil)
             (setq multi-term-dedicated-select-after-open-p t)
             (setq multi-term-scroll-to-bottom-on-output 'others)
             (setq term-buffer-maximum-size 0)
             ;; multi-term keybinding
             (term-set-escape-char ?\C-c)
             (setq term-unbind-key-list '("C-x"))
             (setq term-bind-key-alist
                   '(("M-:" . eval-expression)
                     ("M-w" . kill-ring-save)
                     ("C-y" . term-paste)
                     ("<C-backspace>" . term-send-raw-meta)
                     ("M-d" . term-send-forward-kill-word)
                     ("M-x" . execute-extended-command)
                     ("M-]" . multi-term-next)
                     ("TAB" . (lambda () (interactive)
                                 (term-send-raw-string "\t")))
                     ("<escape>" . (lambda () (interactive)
                                      (term-send-raw-string "^[")))))
             ))


(require 'ggtags)
(setq backup-directory-alist (quote (("." . "~/.backups"))))
