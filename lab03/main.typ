#import "@preview/rubber-article:0.5.0": * 

#show: article 

#maketitle(
   title: "CS 140 Lab Report 3",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",),
)

#enum[ // 1
  For each subitem below, show all relevant changes made (with corresponding filename) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly commited and pushed to your Github Classroom repository. Note that none of the system calls below should print anything on the screen.
  #enum(numbering: "(a)")[
    Create a new system call `opencount` with syscall number `24` that returns the number of times the `open` syscall has been invoked successfully (i.e reached the end of its syscall handler without returning `-1` prematurely) since xv6 startup as a `uint64`. Include a corresponding user mode wrapper function.
  ][
    Examine how `sys.uptime` in `kernel/sysproc.c` is able to return the number of ticks since xv6 startupt to the user process, and examine how `sys_kill` in `kernel/sysproc.c` is able to retrieve the value passed in `a0` when `ecall` is executed.
    Create a new system call `ppid` with syscall number 25 that takes a PID as its argument, then returns a `uint64` corresponding to the parent PID of the process with the given PID, or `-1` if the PID is invalid. Include a corresponding user mdoe wrapper function. No need to perform locking.
  ] 
][ // 2
  #par("Regarding the change described in Section 2.2 regarding the syscalls invoked on startup, show all relevant changes made (with corresponding filename) via code screenshots or snippets, and briefly describe what each change does.")


]