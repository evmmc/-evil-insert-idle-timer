;;; +evil-insert-idle-timer.el --- Auto-revert to Evil normal mode when idle -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 ev
;;
;; Author: ev <ev@evelyn.bz>
;; Created: January 04, 2026
;; Version: 1.0.0
;; Keywords: evil idle timer convenience
;; URL: https://github.com/evmmc/+evil-insert-idle-timer
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; Automatically switches Evil state from Insert to Normal after a set period of inactivity.
;; Usage: (require '+evil-insert-idle-timer)
;;        (+evil-insert-idle-timer-mode 1)
;;
;;; Code:

(require 'evil)

(defgroup +evil-insert-idle-timer nil
  "Auto-revert to Evil normal mode after idle delay."
  :group 'evil
  :prefix "+evil-insert-idle-timer-")

(defcustom +evil-insert-idle-timer-delay 10
  "Seconds of idle time before reverting to Normal state."
  :type 'integer
  :group '+evil-insert-idle-timer)

(defvar +evil-insert-idle-timer--timer nil
  "Internal timer object.")

(defun +evil-insert-idle-timer--action ()
  "Switch to Normal state if currently in Insert state and buffer is valid."
  (when (and (bound-and-true-p evil-local-mode)
             (not (minibufferp))
             (evil-insert-state-p))
    (evil-normal-state)
    (message "Auto-reverted to Normal state.")))

(defun +evil-insert-idle-timer-enable ()
  "Enable the idle timer."
  (when +evil-insert-idle-timer--timer
    (cancel-timer +evil-insert-idle-timer--timer))
  (setq +evil-insert-idle-timer--timer
        (run-with-idle-timer +evil-insert-idle-timer-delay t #'+evil-insert-idle-timer--action))
  (message "Evil Auto-Normal enabled (Delay: %ds)" +evil-insert-idle-timer-delay))

(defun +evil-insert-idle-timer-disable ()
  "Disable the idle timer."
  (when +evil-insert-idle-timer--timer
    (cancel-timer +evil-insert-idle-timer--timer)
    (setq +evil-insert-idle-timer--timer nil))
  (message "Evil Auto-Normal disabled."))

;;;###autoload
(defun +evil-insert-idle-timer-toggle (&optional arg)
  "Toggle auto-switch to normal mode.
With numeric prefix ARG (e.g., C-u 5), set the delay to ARG seconds and enable.
If ARG is 0 or negative, disable the timer.
If no ARG is provided, toggle the current state."
  (interactive "P")
  (let ((num-arg (if arg (prefix-numeric-value arg) nil)))
    (cond
     ((and num-arg (> num-arg 0))
      (setq +evil-insert-idle-timer-delay num-arg)
      (+evil-insert-idle-timer-enable))
     ((and num-arg (<= num-arg 0))
      (+evil-insert-idle-timer-disable))
     (+evil-insert-idle-timer--timer
      (+evil-insert-idle-timer-disable))
     (t
      (+evil-insert-idle-timer-enable)))))

;;;###autoload
(define-minor-mode +evil-insert-idle-timer-mode
  "Global minor mode to automatically switch to Normal state when idle."
  :global t
  :group '+evil-insert-idle-timer
  (if +evil-insert-idle-timer-mode
      (+evil-insert-idle-timer-enable)
    (+evil-insert-idle-timer-disable)))

(provide '+evil-insert-idle-timer)
;;; +evil-insert-idle-timer.el ends here
