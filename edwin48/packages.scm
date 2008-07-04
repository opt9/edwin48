;;; -*- mode: scheme; scheme48-package: (config) -*-

(define-structures
    ((edwin:basic-command    edwin:basic-command/interface)
     (edwin:buffer           edwin:buffer/interface)
     (edwin:bufferset        edwin:bufferset/interface)
     (edwin:command          edwin:command/interface)
     (edwin:command-table    edwin:command-table/interface)
     (edwin:current-state    edwin:current-state/interface)
     (edwin:display-imaging  edwin:display-imaging/interface)
     (edwin:display-type     edwin:display-type/interface)
     (edwin:editor           edwin:editor-definition/interface)
     (edwin:group            edwin:group/interface)
     (edwin:keys             edwin:keys/interface)
     (edwin:kill-command     edwin:kill-command/interface)
     (edwin:mark             edwin:mark/interface)
     (edwin:mode             edwin:mode/interface)
     (edwin:modeline         edwin:modeline/interface)
     (edwin:motion           edwin:motion/interface)
     (edwin:region           edwin:region/interface)
     (edwin:screen           edwin:screen/interface)
     (edwin:simple-editing   edwin:simple-editing/interface)
     (edwin:text-property    edwin:text-property/interface)
     (edwin:undo             edwin:undo/interface)
     (edwin:variable         edwin:variable/interface)
     (edwin:variable/private (export set-variable-%default-value!
                                     set-variable-%value!))
     (edwin:window           edwin:window/interface))
    (open (modify scheme  (hide integer->char string-fill! vector-fill!))
          (modify sorting (rename (vector-sort sort)))
          (modify ascii   (alias  (ascii->char integer->char)))
          aliases define-opt define-record-type* errors event-distributor fixnum
          (modify interrupts (expose call-after-gc!))
          io-support pathname rb-tree soosy weak-pair
          srfi-1 srfi-9 srfi-13 srfi-14 srfi-23 srfi-43 srfi-69
          edwin:doc-string edwin:ring edwin:string-table edwin:utilities)
  (for-syntax (open scheme errors macro-helpers))
  (files (scsh macros) ;; macros need to be looked at first
         struct
         grpops
         txtprp
         regops
         motion
         ;; search
         image
         comman
         comtab
         modes
         buffer
         bufset
         display
         screen

         ;; window system begins here
         window
         utlwin
         bufwin
         bufwfs
         bufwiu
         bufwmc
         comwin
         modwin
         buffrm
         edtfrm

         calias
         edtstr
         ;; editor
         curren
         modlin
         simple 
         undo
         kilcom
         wincom))

(define-structure edwin:string-table edwin:string-table/interface
  (open scheme aliases define-record-type* define-opt
        (modify sorting (rename (vector-sort sort)))
        mit-regexp srfi-13 srfi-43)
  (files strtab))

(define-structure edwin:utilities edwin:utilities/interface
 (open scheme i/o
       aliases errors fixnum pathname util weak-pair
       srfi-13 srfi-14)
   (files utils))

(define-structure edwin:ring edwin:ring/interface
  (open scheme aliases errors srfi-1)
  (files ring))

(define-structure edwin:doc-string edwin:doc-string/interface
  (open scheme aliases fixnum errors define-opt i/o pathname io-support srfi-13
        fixme
        edwin:paths)
  (files docstr))

(define-structure edwin:paths edwin:paths/interface
  (open scheme aliases errors pathname io-support)
  (files paths))

(define-structure edwin:command-table edwin:command-table/interface
  (open scheme (modify sorting (rename (vector-sort sort)))
        aliases define-record-type* define-opt errors fixnum
        srfi-1 srfi-14 edwin:string-table edwin:utilities)
  (files comtab))

(define-structure edwin:terminal-screen edwin:terminal-screen/interface
  (open aliases
        define-record-type*
        edwin:display-type
        edwin:keys
        edwin:screen
        event-distributor
        errors
        fixnum
        io-support
        scheme
        srfi-1
        srfi-6
        srfi-13
        terminal-support
        terminfo)
  (files terminal))

