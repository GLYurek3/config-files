;;; early-init.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Gerald Lee Yurek III
;;
;; Author: Gerald Lee Yurek III <g3@yurek.me>
;; Maintainer: Gerald Lee Yurek III <g3@yurek.me>
;; Created: October 21, 2022
;; Modified: October 21, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/jy/early-init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(setq tool-bar-mode nil
      menu-bar-mode nil
      scroll-bar-mode nil)
(modify-all-frames-parameters '((vertical-scroll-bars)))

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
(setq use-dialog-box nil)
;;; early-init.el ends here
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(set-face-attribute 'default nil :font "Fira Code Retina" :height 150)
(setq-default tab-width 4
              tab-always-indent 'complete
              indent-tabs-mode t)

;;Stealing this from bmacs, which stole the from doom emacs
(eval-and-compile
  (defun gmacs-enlist (exp)
    "Return EXP wrapped in a list, or as-is if already a list."
    (if (listp exp) exp (list exp)))

  (defun doom-unquote (exp)
    "Return EXP unquoted."
    (while (memq (car-safe exp) '(quote function))
      (setq exp (cadr exp)))
    exp)

  (defvar gmacs-evil-state-alist
    '((?n . normal)
      (?v . visual)
      (?i . insert)
      (?e . emacs)
      (?o . operator)
      (?m . motion)
      (?r . replace))
    "A list of cons cells that map a letter to a evil state symbol.")

  ;; Register keywords for proper indentation (see `map!')
  (put ':after        'lisp-indent-function 'defun)
  (put ':desc         'lisp-indent-function 'defun)
  (put ':leader       'lisp-indent-function 'defun)
  (put ':local        'lisp-indent-function 'defun)
  (put ':localleader  'lisp-indent-function 'defun)
  (put ':map          'lisp-indent-function 'defun)
  (put ':map*         'lisp-indent-function 'defun)
  (put ':mode         'lisp-indent-function 'defun)
  (put ':prefix       'lisp-indent-function 'defun)
  (put ':textobj      'lisp-indent-function 'defun)
  (put ':unless       'lisp-indent-function 'defun)
  (put ':when         'lisp-indent-function 'defun)

;; specials
  (defvar gmacs--keymaps nil)
  (defvar gmacs--prefix  nil)
  (defvar gmacs--defer   nil)
  (defvar gmacs--local   nil)

(defun gmacs--keybind-register (key desc &optional modes)
  "Register a description for KEY with `which-key' in MODES.

  KEYS should be a string in kbd format.
  DESC should be a string describing what KEY does.
  MODES should be a list of major mode symbols."
  (if modes
      (dolist (mode modes)
        (which-key-add-major-mode-key-based-replacements mode key desc))
    (which-key-add-key-based-replacements key desc)))

(defun gmacs--keyword-to-states (keyword)
  "Convert a KEYWORD into a list of evil state symbols.

For example, :nvi will map to (list 'normal 'visual 'insert). See
`gmacs-evil-state-alist' to customize this."
  (cl-loop for l across (substring (symbol-name keyword) 1)
           if (cdr (assq l gmacs-evil-state-alist))
             collect it
           else
             do (error "not a valid state: %s" l)))

(defmacro map! (&rest rest)
  "A nightmare of a key-binding macro that will use `evil-define-key*',
`define-key', `local-set-key' and `global-set-key' depending on context and
plist key flags (and whether evil is loaded or not). It was designed to make
binding multiple keys more concise, like in vim.

If evil isn't loaded, it will ignore evil-specific bindings.

States
    :n  normal
    :v  visual
    :i  insert
    :e  emacs
    :o  operator
    :m  motion
    :r  replace

    These can be combined (order doesn't matter), e.g. :nvi will apply to
    normal, visual and insert mode. The state resets after the following
    key=>def pair.

    If states are omitted the keybind will be global.

    This can be customized with `gmacs-evil-state-alist'.

    :textobj is a special state that takes a key and two commands, one for the
    inner binding, another for the outer.

Flags
    (:mode [MODE(s)] [...])    inner keybinds are applied to major MODE(s)
    (:map [KEYMAP(s)] [...])   inner keybinds are applied to KEYMAP(S)
    (:map* [KEYMAP(s)] [...])  same as :map, but deferred
    (:prefix [PREFIX] [...])   assign prefix to all inner keybindings
    (:after [FEATURE] [...])   apply keybinds when [FEATURE] loads
    (:local [...])             make bindings buffer local; incompatible with keymaps!

Conditional keybinds
    (:when [CONDITION] [...])
    (:unless [CONDITION] [...])

Example
    (map! :map magit-mode-map
          :m \"C-r\" 'do-something           ; assign C-r in motion state
          :nv \"q\" 'magit-mode-quit-window  ; assign to 'q' in normal and visual states
          \"C-x C-r\" 'a-global-keybind

          (:when IS-MAC
           :n \"M-s\" 'some-fn
           :i \"M-o\" (lambda (interactive) (message \"Hi\"))))"
  (let ((gmacs--keymaps gmacs--keymaps)
        (gmacs--prefix  gmacs--prefix)
        (gmacs--defer   gmacs--defer)
        (gmacs--local   gmacs--local)
        key def states forms desc modes)
    (while rest
      (setq key (pop rest))
      (cond
       ;; it's a sub expr
       ((listp key)
        (push (macroexpand `(map! ,@key)) forms))

       ;; it's a flag
       ((keywordp key)
        (cond ((eq key :leader)
               (push 'gmacs-leader-key rest)
               (setq key :prefix
                     desc "<leader>"))
              ((eq key :localleader)
               (push 'gmacs-localleader-key rest)
               (setq key :prefix
                     desc "<localleader>")))
        (pcase key
          (:when    (push `(if ,(pop rest)       ,(macroexpand `(map! ,@rest))) forms) (setq rest '()))
          (:unless  (push `(if (not ,(pop rest)) ,(macroexpand `(map! ,@rest))) forms) (setq rest '()))
          (:after   (push `(after! ,(pop rest)   ,(macroexpand `(map! ,@rest))) forms) (setq rest '()))
          (:desc    (setq desc (pop rest)))
          (:map*    (setq gmacs--defer t) (push :map rest))
          (:map
            (setq gmacs--keymaps (gmacs-enlist (pop rest))))
          (:mode
            (setq modes (gmacs-enlist (pop rest)))
            (unless gmacs--keymaps
              (setq gmacs--keymaps
                    (cl-loop for m in modes
                             collect (intern (format "%s-map" (symbol-name m)))))))
          (:textobj
            (let* ((key (pop rest))
                   (inner (pop rest))
                   (outer (pop rest)))
              (push (macroexpand `(map! (:map evil-inner-text-objects-map ,key ,inner)
                                        (:map evil-outer-text-objects-map ,key ,outer)))
                    forms)))
          (:prefix
            (let ((def (pop rest)))
              (setq gmacs--prefix `(vconcat ,gmacs--prefix (kbd ,def)))
              (when desc
                (push `(gmacs--keybind-register ,(key-description (eval gmacs--prefix))
                                                ,desc ',modes)
                      forms)
                (setq desc nil))))
          (:local
           (setq gmacs--local t))
          (_ ; might be a state gmacs--prefix
           (setq states (gmacs--keyword-to-states key)))))

       ;; It's a key-def pair
       ((or (stringp key)
            (characterp key)
            (vectorp key)
            (symbolp key))
        (unwind-protect
            (catch 'skip
              (when (symbolp key)
                (setq key `(kbd ,key)))
              (when (stringp key)
                (setq key (kbd key)))
              (when gmacs--prefix
                (setq key (append gmacs--prefix (list key))))
              (unless (> (length rest) 0)
                (user-error "map! has no definition for %s key" key))
              (setq def (pop rest))
              (when desc
                (push `(gmacs--keybind-register ,(key-description (eval key))
                                              ,desc ',modes)
                      forms))
              (cond ((and gmacs--local gmacs--keymaps)
                     (push `(lwarn 'gmacs-map :warning
                                   "Can't local bind '%s' key to a keymap; skipped"
                                   ,key)
                           forms)
                     (throw 'skip 'local))
                    ((and gmacs--keymaps states)
                     (dolist (keymap gmacs--keymaps)
                       (push `(,(if gmacs--defer 'evil-define-key 'evil-define-key*)
                               ',states ,keymap ,key ,def)
                             forms)))
                    (states
                     (dolist (state states)
                       (push `(define-key
                                ,(intern (format "evil-%s-state-%smap" state (if gmacs--local "local-" "")))
                                ,key ,def)
                             forms)))
                    (gmacs--keymaps
                     (dolist (keymap gmacs--keymaps)
                       (push `(define-key ,keymap ,key ,def) forms)))
                    (t
                     (push `(,(if gmacs--local 'local-set-key 'global-set-key) ,key ,def)
                           forms))))
          (setq states '()
                gmacs--local nil
                desc nil)))

       (t (user-error "Invalid key %s" key))))
    `(progn ,@(nreverse forms)))))
