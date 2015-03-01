#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {
    # Provoke name search
    catch {package require bogus-package-name}
    set packageNames [package names]

    switch $tcl_platform(platform) {
	windows {
	}
	default {
	    option add *Scrollbar.width 10
	}
    }
    
    # Needs Itcl
    package require Itcl 3.0

    # Needs Itk
    package require Itk 3.0

    # Needs Iwidgets
    package require Iwidgets 4.0

    switch $tcl_platform(platform) {
	windows {
	}
	default {
	    option add *Scrolledhtml.sbWidth    10
	    option add *Scrolledtext.sbWidth    10
	    option add *Scrolledlistbox.sbWidth 10
	    option add *Hierarchy.sbWidth       10
        }
    }
    
}
#############################################################################
# Visual Tcl v1.51 Project
#

#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
proc Window {args} {
    global vTcl
    set cmd     [lindex $args 0]
    set name    [lindex $args 1]
    set newname [lindex $args 2]
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
}

if {![info exists vTcl(sourcing)]} {
proc {vTcl:DefineAlias} {target alias widgetProc top_or_alias cmdalias} {
    global widget

    set widget($alias) $target
    set widget(rev,$target) $alias

    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }

    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target

        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}

proc {vTcl:DoCmdOption} {target cmd} {
    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}

proc {vTcl:FireEvent} {target event} {
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                regsub -all %W $bind_code $target bind_code
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    # break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}

proc {vTcl:Toplevel:WidgetProc} {w args} {
    if {[llength $args] == 0} {
        return -code error "wrong # args: should be \"$w option ?arg arg ...?\""
    }

    ## The first argument is a switch, they must be doing a configure.
    if {[string index $args 0] == "-"} {
        set command configure

        ## There's only one argument, must be a cget.
        if {[llength $args] == 1} {
            set command cget
        }
    } else {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
    }

    switch -- $command {
        "hide" -
        "Hide" {
            Window hide $w
        }

        "show" -
        "Show" {
            Window show $w
        }

        "ShowModal" {
            Window show $w
            raise $w
            grab $w
            tkwait window $w
            grab release $w
        }

        default {
            eval $w $command $args
        }
    }
}

proc {vTcl:WidgetProc} {w args} {
    if {[llength $args] == 0} {
        return -code error "wrong # args: should be \"$w option ?arg arg ...?\""
    }

    ## The first argument is a switch, they must be doing a configure.
    if {[string index $args 0] == "-"} {
        set command configure

        ## There's only one argument, must be a cget.
        if {[llength $args] == 1} {
            set command cget
        }
    } else {
        set command [lindex $args 0]
        set args [lrange $args 1 end]
    }

    eval $w $command $args
}

proc {vTcl:toplevel} {args} {
    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {}
}
}

if {[info exists vTcl(sourcing)]} {
proc vTcl:project:info {} {
    namespace eval ::widgets::.top51 {
        array set save {-menu 1}
    }
    namespace eval ::widgets::.top51.scr53 {
        array set save {-height 1 -textbackground 1 -wrap 1}
    }
    namespace eval ::widgets::.top51.ent51 {
        array set save {-labeltext 1 -textbackground 1 -textvariable 1 -width 1}
    }
    namespace eval ::widgets::.top51.but52 {
        array set save {-command 1 -height 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top51.but53 {
        array set save {-command 1 -height 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top51.com54 {
        array set save {-command 1 -textbackground 1 -textvariable 1 -width 1}
    }
    namespace eval ::widgets::.top51.lab55 {
        array set save {-height 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top51.m57 {
        array set save {-tearoff 1}
    }
    namespace eval ::widgets::.top51.m57.men51 {
        array set save {-tearoff 1}
    }
    namespace eval ::widgets::.top51.m57.men52 {
        array set save {-tearoff 1}
    }
    namespace eval ::widgets::.top51.fra53 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad55 {
        array set save {-height 1 -text 1 -textvariable 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad56 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad57 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad58 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad59 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad60 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad61 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad62 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.lab63 {
        array set save {-text 1 -width 1}
    }
    namespace eval ::widgets::.top51.lab51 {
        array set save {-height 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad52 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad53 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.lab54 {
        array set save {-height 1 -text 1 -width 1}
    }
    namespace eval ::widgets::.top51.ent55 {
        array set save {-clientdata 1 -command 1 -labeltext 1 -textbackground 1 -textvariable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che57 {
        array set save {-command 1 -height 1 -text 1 -textvariable 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.ent59 {
        array set save {-focuscommand 1 -labeltext 1 -textbackground 1 -textvariable 1 -validate 1 -width 1}
    }
    namespace eval ::widgets::.top51.spi60 {
        array set save {-command 1 -decrement 1 -increment 1 -labeltext 1 -textbackground 1 -textvariable 1 -validate 1 -width 1}
    }
    namespace eval ::widgets::.top51.spi61 {
        array set save {-decrement 1 -increment 1 -labeltext 1 -textbackground 1 -textvariable 1 -validate 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad51 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad54 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad63 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.rad64 {
        array set save {-height 1 -text 1 -value 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che65 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che66 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che67 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.ent69 {
        array set save {-labeltext 1 -textbackground 1 -width 1}
    }
    namespace eval ::widgets::.top51.ent71 {
        array set save {-labeltext 1 -textbackground 1 -width 1}
    }
    namespace eval ::widgets::.top51.che72 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che73 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che74 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che75 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che76 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.lab52 {
        array set save {-text 1 -width 1}
    }
    namespace eval ::widgets::.top51.fra55 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top51.fra56 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top51.fra57 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top51.fra58 {
        array set save {-borderwidth 1 -height 1 -relief 1 -width 1}
    }
    namespace eval ::widgets::.top51.che52 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che53 {
        array set save {-command 1 -height 1 -text 1 -textvariable 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che53.che60 {
        array set save {-height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che54 {
        array set save {-command 1 -height 1 -text 1 -textvariable 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che55 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che56 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che58 {
        array set save {-command 1 -height 1 -text 1 -textvariable 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che59 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che61 {
        array set save {-command 1 -height 1 -text 1 -variable 1 -width 1}
    }
    namespace eval ::widgets::.top51.che62 {
        array set save {-command 1 -height 1 -text 1 -textvariable 1 -variable 1 -width 1}
    }
    namespace eval ::widgets_bindings {
        set tagslist {}
    }
}
}
#################################
# USER DEFINED PROCEDURES
#
###########################################################
## Procedure:  file_get

proc {file_get} {} {
.top51.scr53 delete 1.0 end
       set file_types {
               {"Log Files" { .log .LOG .lg .L} }
               {"Text Files" { .txt .TXT } }
               {"All Files" * }
       }
       set filename [tk_getOpenFile -filetypes $file_types -initialdir pwd]
       set filesize [file size $filename]
       set fileid [open $filename r]
       set data [read $fileid $filesize]
       close $fileid
       .top51.scr53 insert end $data
       wm title . $filename
}
###########################################################
## Procedure:  file_save_as

proc {file_save_as} {} {
global filename
       set filename digtext1
       set data [.top51.scr53 get 1.0 {end -1c}]
       set file_types {
               {"Log Files" { .log .LOG .lg .L} }
               {"Text Files" { .txt .TXT} }
               {"All Files" * }
       }

       set filename [tk_getSaveFile -filetypes $file_types -initialdir pwd -initialfile $filename -defaultextension .log]
       wm title . FileSaveAs
       set fileid [open $filename w]
       puts -nonewline $fileid $data
       close $fileid
}
###########################################################
## Procedure:  save

proc {save} {} {
set data [.top51.scr53 get 1.0 {end -1c}]
       set fileid [open $filename w]
       puts -nonewline $fileid $data
       close $fileid
}
###########################################################
## Procedure:  init
###########################################################
## Procedure:  main

proc {main} {argc argv} {
set f [open "/etc/resolv.conf" r]
while {! [eof $f]} {
    set namesrvrs [split [gets $f]] 
    if { [lindex $namesrvrs 0] == "nameserver" } {
        .top51.com54 insert list end [lindex $namesrvrs 1]
    } elseif { [lindex $namesrvrs 0] == "domain" } {
        .top51.ent59 insert end [lindex $namesrvrs 1]
      }         
}
.top51.com54 selection set 0 0
.top51.rad55 select
.top51.rad52 select
.top51.spi60 up
.top51.spi60 up
.top51.spi60 up
.top51.spi60 up
.top51.spi61 up
.top51.spi61 up
.top51.spi61 up
.top51.spi61 up
.top51.che66 select
.top51.che61 select
.top51.che52 select
.top51.che53 select
.top51.che54 select
.top51.che55 select
.top51.che56 select
.top51.che58 select
}

proc init {argc argv} {
global portvar
global dmnname
global namesrvrs
global dnsserver
global tmeout
global revoption
global recursion
global digoptions
global tcpoption
global nssrchoption
global verbinoption
global aaflagoption
global adflagoption
global cdflagoption
global traceoption
global cmdoption
global commentsoption
global questionoption
global answeroption
global answeroption
global authorityoption
global additionaloption
global shortoption
global qroption
global alloption

set portvar 53
set revoption +defname
set digoptions [list ""]
set recursion +recurse
set tcpoption +notcp
set nssrchoption +nonssearch
set verbinoption +defname
set aaflagoption +noaaflag
set adflagoption +noadflag
set cdflagoption +nocdflag
set traceoption +notrace
set cmdoption +cmd
set commentsoption +comments
set questionoption +question
set answeroption +answer
set authorityoption +authority
set additionaloption +additional
set shortoption +noshort
set alloption +all
set qroption +noqr
}

init $argc $argv

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base {container 0}} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    wm focusmodel $base passive
    wm geometry $base 1x1+0+0; update
    wm maxsize $base 1009 738
    wm minsize $base 1 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vtcl.tcl"
    bindtags $base "$base Vtcl.tcl all"
    vTcl:FireEvent $base <<Create>>
    }
    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top51 {base {container 0}} {
    if {$base == ""} {
        set base .top51
    }
    if {[winfo exists $base] && (!$container)} {
        wm deiconify $base; return
    }

    global widget
    vTcl:DefineAlias "$base" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    vTcl:DefineAlias "$base.but52" "Button1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.but53" "Button2" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che52" "Checkbutton11" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che53" "Checkbutton12" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che53.che60" "Checkbutton18" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che54" "Checkbutton13" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che55" "Checkbutton14" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che56" "Checkbutton15" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che57" "Checkbutton1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che58" "Checkbutton16" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che59" "Checkbutton17" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che61" "Checkbutton19" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che62" "Checkbutton20" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che65" "Checkbutton2" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che66" "Checkbutton3" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che67" "Checkbutton4" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che72" "Checkbutton5" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che73" "Checkbutton6" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che74" "Checkbutton7" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che75" "Checkbutton8" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.che76" "Checkbutton9" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.com54" "Combobox1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.ent51" "Entryfield1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.ent55" "Entryfield2" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.ent59" "Entryfield3" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.ent69" "Entryfield4" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.ent71" "Entryfield5" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.fra53" "Frame1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.fra55" "Frame6" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.fra56" "Frame7" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.fra57" "Frame8" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.fra58" "Frame9" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.lab51" "Label3" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.lab52" "Label5" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.lab54" "Label4" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.lab55" "Label1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.lab63" "Label2" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad51" "Radiobutton11" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad52" "Radiobutton9" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad53" "Radiobutton10" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad54" "Radiobutton12" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad55" "Radiobutton1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad56" "Radiobutton2" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad57" "Radiobutton3" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad58" "Radiobutton4" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad59" "Radiobutton5" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad60" "Radiobutton6" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad61" "Radiobutton7" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad62" "Radiobutton8" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad63" "Radiobutton13" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.rad64" "Radiobutton14" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.scr53" "Scrolledtext2" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.spi60" "Spinint1" vTcl:WidgetProc "Toplevel1" 1
    vTcl:DefineAlias "$base.spi61" "Spinint2" vTcl:WidgetProc "Toplevel1" 1

    ###################
    # CREATING WIDGETS
    ###################
    if {!$container} {
    vTcl:toplevel $base -class Toplevel \
        -menu "$base.m57" 
    wm focusmodel $base passive
    wm geometry $base 575x447+128+130; update
    wm maxsize $base 1009 738
    wm minsize $base 575 480
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "digfe v0.7.3 BETA"
    vTcl:FireEvent $base <<Create>>
    }
    ::iwidgets::scrolledtext $base.scr53 \
        -height 227 -textbackground #fefefe -wrap none 
    ::iwidgets::entryfield $base.ent51 \
        -labeltext {Host / Domain:} -textbackground #fefefe \
        -textvariable hostordomain -width 315 
    button $base.but52 \
        \
        -command .top51.scr53\ clear\nif\ \{\ \[catch\ \{\ \\\n\ \ .top51.scr53\ insert\ end\ \[exec\ dig\ @\$dnsserver\ \\\n\ \ \$selectedButtonQT\ \$selectedButtonQC\ -p\ \$portvar\ \\\n\ \ +domain=\$dmnname\ +tim=\$tmeout\ +ret=\$rtry\ \$recursion\ \\\n\ \ \$tcpoption\ \$nssrchoption\ \$aaflagoption\ \\\n\ \ \$adflagoption\ \$cdflagoption\ \$traceoption\ \\\n\ \ \$cmdoption\ \$commentsoption\ \$questionoption\ \\\n\ \ \$answeroption\ \$authorityoption\ \$additionaloption\ \\\n\ \ \$shortoption\ \$qroption\ \$alloption\ \\\n\ \ \$verbinoption\ \$revoption\ \\\n\ \ \$hostordomain\]\ \\\n\ \ \}\ errtxt\]\ \\\n\}\ \{\ .top51.scr53\ insert\ end\ \$errtxt\} \
        -height 31 -text dig -width 67 
    button $base.but53 \
        -command exit -height 31 -text Exit -width 67 
    ::iwidgets::combobox $base.com54 \
        \
        -command {namespace inscope ::iwidgets::Combobox {::.top51.com54 _addToList}} \
        -textbackground #fefefe -textvariable dnsserver -width 219 
    label $base.lab55 \
        -height 0 -text {DNS Server:} -width 0 
    menu $base.m57 \
        -tearoff 1 
    $base.m57 add cascade \
        -menu "$base.m57.men51" -accelerator {} -command {} -image {} \
        -label File 
    $base.m57 add cascade \
        -menu "$base.m57.men52" -accelerator {} -command {} -image {} \
        -label Help 
    menu $base.m57.men51 \
        -tearoff 0 
    $base.m57.men51 add command \
        -accelerator {} -command file_get -image {} -label {Open Log} 
    $base.m57.men51 add command \
        -accelerator {} -command save -image {} -label {Save Log} 
    $base.m57.men51 add command \
        -accelerator {} -command file_save_as -image {} -label {Save Log As} 
    $base.m57.men51 add separator
    $base.m57.men51 add command \
        -accelerator {} -command exit -image {} -label Close 
    menu $base.m57.men52 \
        -tearoff 0 
    $base.m57.men52 add command \
        -accelerator {} \
        -command {#wm state .top55 normal
tk_messageBox -title "About digfe" -type ok -message "Version: digfe-0.7.3 
Author: Jim Burrell jburrell@concoctedlogic.com www.concoctedlogic.com"} \
        -image {} -label About 
    frame $base.fra53 \
        -borderwidth 2 -height 5 -relief sunken -width 500 
    radiobutton $base.rad55 \
        -height 17 -text a -textvariable sBQT -value a \
        -variable selectedButtonQT -width 43 
    radiobutton $base.rad56 \
        -height 17 -text any -value any -variable selectedButtonQT -width 48 
    radiobutton $base.rad57 \
        -height 17 -text mx -value mx -variable selectedButtonQT -width 48 
    radiobutton $base.rad58 \
        -height 17 -text ns -value ns -variable selectedButtonQT -width 48 
    radiobutton $base.rad59 \
        -height 17 -text soa -value so -variable selectedButtonQT -width 53 
    radiobutton $base.rad60 \
        -height 17 -text hinfo -value hinfo -variable selectedButtonQT \
        -width 58 
    radiobutton $base.rad61 \
        -height 17 -text axfr -value axfr -variable selectedButtonQT \
        -width 58 
    radiobutton $base.rad62 \
        -height 17 -text txt -value txt -variable selectedButtonQT -width 58 
    label $base.lab63 \
        -text {Query Type} -width 78 
    label $base.lab51 \
        -height 0 -text {Query Class} -width 78 
    radiobutton $base.rad52 \
        -height 17 -text in -value in -variable selectedButtonQC -width 43 
    radiobutton $base.rad53 \
        -height 17 -text any -value * -variable selectedButtonQC -width 53 
    label $base.lab54 \
        -height 0 -text {Dig Options} -width 73 
    ::iwidgets::entryfield $base.ent55 \
        -clientdata 53 -command {.top51.ent55 insert end 53
.} \
        -labeltext Port -textbackground #fefefe -textvariable portvar \
        -width 65 
    checkbutton $base.che57 \
        \
        -command {if {$revrsvar} {
  set revoption -x
  } else {
    set revoption +defname
}} \
        -height 17 -text -x -textvariable revtext -variable revrsvar \
        -width 41 
    ::iwidgets::entryfield $base.ent59 \
        -focuscommand {} -labeltext Domain: -textbackground #fefefe \
        -textvariable dmnname -validate none -width 150 
    ::iwidgets::spinint $base.spi60 \
        -command {} \
        -decrement {namespace inscope ::iwidgets::Spinner {::.top51.spi60 down}} \
        -increment {namespace inscope ::iwidgets::Spinner {::.top51.spi60 up}} \
        -labeltext Timeout(sec): -textbackground #fefefe -textvariable tmeout \
        -validate {::iwidgets::Entryfield::numeric %c} -width 130 
    ::iwidgets::spinint $base.spi61 \
        \
        -decrement {namespace inscope ::iwidgets::Spinner {::.top51.spi61 down}} \
        -increment {namespace inscope ::iwidgets::Spinner {::.top51.spi61 up}} \
        -labeltext Retries -textbackground #fefefe -textvariable rtry \
        -validate {::iwidgets::Entryfield::numeric %c} -width 90 
    radiobutton $base.rad51 \
        -height 17 -text cname -value cname -variable selectedButtonQT \
        -width 63 
    radiobutton $base.rad54 \
        -height 17 -text ch -value ch -variable selectedButtonQC -width 38 
    radiobutton $base.rad63 \
        -height 17 -text hs -value hs -variable selectedButtonQC -width 43 
    radiobutton $base.rad64 \
        -height 17 -text wks -value wk -variable selectedButtonQT -width 48 
    checkbutton $base.che65 \
        \
        -command {if {$verbinvar} {
  set verbinoption version.bind
  } else {
    set verbinoption +defname
}} \
        -height 17 -text version.bind -variable verbinvar -width 96 
    checkbutton $base.che66 \
        \
        -command {if {$recurvar} {
  set recursion +recursive
  } else {
    set recursion +norecursive
}} \
        -height 17 -text recursion -variable recurvar -width 81 
    checkbutton $base.che67 \
        \
        -command {if {$tcpvar} {
  set tcpoption +tcp
  } else {
    set tcpoption +notcp
}} \
        -height 17 -text tcp -variable tcpvar -width 46 
    ::iwidgets::entryfield $base.ent69 \
        -labeltext {Name : Key} -textbackground #fefefe -width 150 
    ::iwidgets::entryfield $base.ent71 \
        -labeltext : -textbackground #fefefe -width 55 
    checkbutton $base.che72 \
        \
        -command {if {$nssrchvar} {
  set nssrchoption +nssearch
  } else {
    set nssrchoption +nonssearch
}} \
        -height 17 -text nssearch -variable nssrchvar -width 81 
    checkbutton $base.che73 \
        \
        -command {if {$tracevar} {
  set traceoption +trace
  } else {
    set traceoption +notrace
}} \
        -height 17 -text trace -variable tracevar -width 56 
    checkbutton $base.che74 \
        \
        -command {if {$aaflagvar} {
  set aaflagoption +aaflag
  } else {
    set aaflagoption +noaaflag
}} \
        -height 17 -text aaflag -variable aaflagvar -width 61 
    checkbutton $base.che75 \
        \
        -command {if {$adflagvar} {
  set adflagoption +adflag
  } else {
    set adflagoption +noadflag
}} \
        -height 17 -text adflag -variable adflagvar -width 61 
    checkbutton $base.che76 \
        \
        -command {if {$cdflagvar} {
  set cdflagoption +cdflag
  } else {
    set cdflagoption +nocdflag
}} \
        -height 17 -text cdflag -variable cdflagvar -width 61 
    label $base.lab52 \
        -text {Print Options} -width 88 
    frame $base.fra55 \
        -borderwidth 2 -height 110 -relief sunken -width 5 
    frame $base.fra56 \
        -borderwidth 2 -height 110 -relief sunken -width 5 
    frame $base.fra57 \
        -borderwidth 2 -height 110 -relief sunken -width 5 
    frame $base.fra58 \
        -borderwidth 2 -height 5 -relief sunken -width 570 
    checkbutton $base.che52 \
        \
        -command {if {$cmdvar} {
  set cmdoption +cmd
  } else {
    set cmdoption +nocmd
}} \
        -height 17 -text cmd -variable cmdvar -width 56 
    checkbutton $base.che53 \
        \
        -command {if {$commentsvar} {
  set commentsoption +comments
  } else {
    set commentsoption +nocomments
}} \
        -height 17 -text comments -textvariable comment -variable commentsvar \
        -width 86 
    checkbutton $base.che53.che60 \
        -height 0 -text check -variable "$base\::che60" -width 0 
    checkbutton $base.che54 \
        \
        -command {if {$questionvar} {
  set questionoption +question
  } else {
    set questionoption +noquestion
}} \
        -height 17 -text question -textvariable question \
        -variable questionvar -width 81 
    checkbutton $base.che55 \
        \
        -command {if {$answervar} {
  set answeroption +answer
  } else {
    set answeroption +noanswer
}} \
        -height 17 -text answer -variable answervar -width 71 
    checkbutton $base.che56 \
        \
        -command {if {$authorityvar} {
  set authorityoption +authority
  } else {
    set authorityoption +noauthority
}} \
        -height 17 -text authority -variable authorityvar -width 86 
    checkbutton $base.che58 \
        \
        -command {if {$additionalvar} {
  set additionaloption +additional
  } else {
    set additionaloption +noadditional
}} \
        -height 17 -text additional -textvariable additional \
        -variable additionalvar -width 86 
    checkbutton $base.che59 \
        \
        -command {if {$shortvar} {
  set shortoption +short
  } else {
    set shortoption +noshort
}} \
        -height 17 -text short -variable shortvar -width 56 
    checkbutton $base.che61 \
        \
        -command {if {$allvar} {
  set alloption +all
  .top51.che52 select
  set cmdoption +cmd
  .top51.che53 select
  set commentsoption +comments
  .top51.che54 select
  set questionoptions +question
  .top51.che55 select
  set answeroptions +answer
  .top51.che56 select
  set authorityoptions +authority
  .top51.che58 select
  set additionaloptions +additional
  } else {
    set alloption +defname
    .top51.che52 deselect
    set cmdoption +nocmd
    .top51.che53 deselect
    set commentsoption +nocomments
    .top51.che54 deselect
    set questionoption +noquestion
    .top51.che55 deselect
    set answeroption +noanswer
    .top51.che56 deselect
    set authorityoption +noauthority
    .top51.che58 deselect
    set additionaloption +noadditional
}} \
        -height 17 -text all -variable allvar -width 46 
    checkbutton $base.che62 \
        \
        -command {if {$qrvar} {
  set qroption +qr
  } else {
    set qroption +noqr
}} \
        -height 17 -text qr -textvariable qr -variable qrvar -width 41 
    ###################
    # SETTING GEOMETRY
    ###################
    pack $base.scr53 \
        -in $base -anchor sw -expand 1 -fill x -side bottom 
    place $base.ent51 \
        -x 3 -y 13 -width 315 -height 22 -anchor nw -bordermode ignore 
    place $base.but52 \
        -x 335 -y 8 -width 67 -height 31 -anchor nw -bordermode ignore 
    place $base.but53 \
        -x 412 -y 8 -width 67 -height 31 -anchor nw -bordermode ignore 
    place $base.com54 \
        -x 98 -y 45 -width 219 -height 22 -anchor nw -bordermode ignore 
    place $base.lab55 \
        -x 14 -y 46 -width 82 -height 20 -anchor nw -bordermode ignore 
    place $base.fra53 \
        -x -1 -y 73 -width 575 -height 3 -anchor nw -bordermode ignore 
    place $base.rad55 \
        -x 3 -y 96 -width 43 -height 17 -anchor nw -bordermode ignore 
    place $base.rad56 \
        -x 8 -y 112 -width 48 -height 17 -anchor nw -bordermode ignore 
    place $base.rad57 \
        -x 6 -y 127 -width 48 -height 17 -anchor nw -bordermode ignore 
    place $base.rad58 \
        -x 4 -y 142 -width 48 -height 17 -anchor nw -bordermode ignore 
    place $base.rad59 \
        -x 5 -y 157 -width 53 -height 17 -anchor nw -bordermode ignore 
    place $base.rad60 \
        -x 58 -y 112 -width 58 -height 17 -anchor nw -bordermode ignore 
    place $base.rad61 \
        -x 56 -y 96 -width 58 -height 17 -anchor nw -bordermode ignore 
    place $base.rad62 \
        -x 52 -y 142 -width 58 -height 17 -anchor nw -bordermode ignore 
    place $base.lab63 \
        -x 17 -y 78 -width 78 -height 15 -anchor nw -bordermode ignore 
    place $base.lab51 \
        -x 135 -y 78 -width 78 -height 15 -anchor nw -bordermode ignore 
    place $base.rad52 \
        -x 141 -y 96 -width 43 -height 17 -anchor nw -bordermode ignore 
    place $base.rad53 \
        -x 142 -y 113 -width 53 -height 17 -anchor nw -bordermode ignore 
    place $base.lab54 \
        -x 260 -y 78 -width 73 -height 15 -anchor nw -bordermode ignore 
    place $base.ent55 \
        -x 330 -y 45 -width 65 -height 22 -anchor nw -bordermode ignore 
    place $base.che57 \
        -x 223 -y 95 -width 41 -height 17 -anchor nw -bordermode ignore 
    place $base.ent59 \
        -x 4 -y 197 -width 150 -height 22 -anchor nw -bordermode ignore 
    place $base.spi60 \
        -x 350 -y 195 -width 130 -height 22 -anchor nw -bordermode ignore 
    place $base.spi61 \
        -x 481 -y 195 -width 90 -height 22 -anchor nw -bordermode ignore 
    place $base.rad51 \
        -x 61 -y 127 -width 63 -height 17 -anchor nw -bordermode ignore 
    place $base.rad54 \
        -x 146 -y 131 -width 38 -height 17 -anchor nw -bordermode ignore 
    place $base.rad63 \
        -x 143 -y 148 -width 43 -height 17 -anchor nw -bordermode ignore 
    place $base.rad64 \
        -x 61 -y 157 -width 48 -height 17 -anchor nw -bordermode ignore 
    place $base.che65 \
        -x 225 -y 110 -width 96 -height 17 -anchor nw -bordermode ignore 
    place $base.che66 \
        -x 224 -y 125 -width 81 -height 17 -anchor nw -bordermode ignore 
    place $base.che67 \
        -x 224 -y 141 -width 46 -height 17 -anchor nw -bordermode ignore 
    place $base.ent69 \
        -x 155 -y 196 -width 150 -height 22 -anchor nw -bordermode ignore 
    place $base.ent71 \
        -x 297 -y 196 -width 55 -height 22 -anchor nw -bordermode ignore 
    place $base.che72 \
        -x 224 -y 157 -width 81 -height 17 -anchor nw -bordermode ignore 
    place $base.che73 \
        -x 325 -y 141 -width 56 -height 17 -anchor nw -bordermode ignore 
    place $base.che74 \
        -x 325 -y 95 -width 61 -height 17 -anchor nw -bordermode ignore 
    place $base.che75 \
        -x 325 -y 110 -width 61 -height 17 -anchor nw -bordermode ignore 
    place $base.che76 \
        -x 325 -y 125 -width 61 -height 17 -anchor nw -bordermode ignore 
    place $base.lab52 \
        -x 428 -y 78 -width 88 -height 15 -anchor nw -bordermode ignore 
    place $base.fra55 \
        -x 394 -y 76 -width 3 -height 112 -anchor nw -bordermode ignore 
    place $base.fra56 \
        -x 126 -y 76 -width 3 -height 112 -anchor nw -bordermode ignore 
    place $base.fra57 \
        -x 214 -y 76 -width 3 -height 112 -anchor nw -bordermode ignore 
    place $base.fra58 \
        -x 0 -y 187 -width 575 -height 3 -anchor nw -bordermode ignore 
    place $base.che52 \
        -x 401 -y 95 -width 56 -height 17 -anchor nw -bordermode ignore 
    place $base.che53 \
        -x 404 -y 111 -width 86 -height 17 -anchor nw -bordermode ignore 
    place $base.che53.che60 \
        -x 80 -y 16 -anchor nw -bordermode ignore 
    place $base.che54 \
        -x 401 -y 127 -width 81 -height 17 -anchor nw -bordermode ignore 
    place $base.che55 \
        -x 403 -y 143 -width 71 -height 17 -anchor nw -bordermode ignore 
    place $base.che56 \
        -x 400 -y 159 -width 86 -height 17 -anchor nw -bordermode ignore 
    place $base.che58 \
        -x 484 -y 95 -width 86 -height 17 -anchor nw -bordermode ignore 
    place $base.che59 \
        -x 487 -y 111 -width 56 -height 17 -anchor nw -bordermode ignore 
    place $base.che61 \
        -x 483 -y 143 -width 46 -height 17 -anchor nw -bordermode ignore 
    place $base.che62 \
        -x 485 -y 127 -width 41 -height 17 -anchor nw -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

Window show .
Window show .top51

main $argc $argv
