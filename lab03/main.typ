#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article.with(lang: "en")

#maketitle(
   title: "CS 140 Lab Report 3",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",),
)

#enum(spacing:  20pt)[ // 1
  For each subitem below, show all relevant changes made (with corresponding filename) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly commited and pushed to your Github Classroom repository. Note that none of the system calls below should print anything on the screen.
  
  \
  #enum(numbering: "(a)")[
    Create a new system call `opencount` with syscall number `24` that returns the number of times the `open` syscall has been invoked successfully (i.e reached the end of its syscall handler without returning `-1` prematurely) since xv6 startup as a `uint64`. Include a corresponding user mode wrapper function. \
    #figure(
      image("assets/item1a/1.png"),
      caption: [`syscall.h` change]
    )
    This change adds the is required to assign the syscall code 24 to the new syscall `sys_opencount`.

    #figure(
      image("assets/item1a/2.png"),
      caption: [`syscall.c` change 1]
    )

    #figure(
      image("assets/item1a/3.png"),
      caption: [`syscall.c` change 2]
    )

    These are changes to add the `sys_opencount` function to the syscall table.

    #figure(
      image("assets/item1a/4.png"),
      caption: [`sysfile.h` change 1]
    )

    #figure(
      image("assets/item1a/5.png"),
      caption: [`sysfile.h` change 2]
    )

    #figure(
      image("assets/item1a/6.png"),
      caption: [`sysfile.c` change 3]
    )

    These are the changes to implement the `sys_opencount` function. `open_count` is a variable that is incremented each time the `sys_open` function is called and successfull (change 3 is added at the end of the functino). The `sys_opencount` function simply returns the value of `open_count`.

    #figure(
      image("assets/item1a/7.png"),
      caption: [`usys.pl` change]
    )

    This change is necessary to add the user mode wrapper function for `opencount`.

    #figure(
      image("assets/item1a/8.png"),
      caption: [`user.h` change]
    )

    This change allows `C` programs to call `opencount` as a regular `C` function despite it being defined in assembly.
  ][
    Examine how `sys.uptime` in `kernel/sysproc.c` is able to return the number of ticks since xv6 startupt to the user process, and examine how `sys_kill` in `kernel/sysproc.c` is able to retrieve the value passed in `a0` when `ecall` is executed.
    Create a new system call `ppid` with syscall number 25 that takes a PID as its argument, then returns a `uint64` corresponding to the parent PID of the process with the given PID, or `-1` if the PID is invalid. Include a corresponding user mdoe wrapper function. No need to perform locking.

    #figure(
      image("assets/item1b/1.png"),
      caption: [`syscall.h` change]
    )

    This change adds the is required to assign the syscall code 25 to the new syscall `sys_ppid`.

    #figure(
      image("assets/item1b/2.png"),
      caption: [`syscall.c` change 1]
    )

    #figure(
      image("assets/item1b/3.png"),
      caption: [`syscall.c` change 2]
    )

    These are changes to add the `sys_ppid` function to the syscall table.

    #figure(
      image("assets/item1b/4.png", width: 50%),
      caption: [`sysproc.h` change 1]
    )

    This is the implementation of the `sys_ppid` function. It gets the argument passed to it using `argint` and then searches for the `ppid` of the process from the `proc` array.

    #figure(
      image("assets/item1b/5.png"),
      caption: [`usys.pl` change]
    )
    This change is necessary to add the user mode wrapper function for `ppid`.
    #figure(
      image("assets/item1b/6.png"),
      caption: [`user.h` change]
    )
    This change allows `C` programs to call `ppid` as a regular `C` function despite it being defined in assembly.
  ] 
][ // 2
  Regarding the change described in Section 2.2 regarding the syscalls invoked on startup, show all relevant changes made (with corresponding filename) via code screenshots or snippets, and briefly describe what each change does.
  \
  Additionally, take a screenshot of the output introduced by your changes when starting xv6 up, and annotate it so it shows the syscall name of each syscall number shown (you may also print the name programmatically). Ensure the name of the invoking process is shown per syscall.
][ // 3
  Show the screenshot taken in Section 2.3.2, compare it with the output of the same command in Section 2.3.1, then explain why running `hello` causes the output discrepancy.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* In 2.3.2, we added lines of code that runs whenever we call the process with syscall code 23 (which is `sys_hello`). In the changes, it disables timer interrupts by running the line `asm volatile("csrw sie, %0" : : "r" (0x200));` Since we disabled timer interrupts, it also disables the scheduler. This means that whoever runs first, in my case the user program `a` runs first, it will run until it terminates but since we programmed our `a` to run indefinitely, it will never terminate hence it will forever be printing the letter a.
    #figure(
      table(
        columns: 2,
        [#image("assets/2.3.2.png")],
        [#image("assets/2.3.1.png")]
      ),
      caption: [Output of 2.3.1 vs Output of 2.3.2]
    )

  ]
][
  Show the screenshot taken in Section 2.3.3, describe the behavior of `hello` from startup to termination, then explain what causes `hello` to behave in atypical manner.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* The `hello` program is unable to run the `printf("After disabling timer interrupts\n");` line because of the previous line `asm volatile("csrw sie, %0" : : "r" (0x200));` this line should be called in kernel mode but it is called in user mode causing a trap and terminating the program.
    #figure(
      image("assets/2.3.4.png"),
      caption: [Output of 2.3.4]
    )
  ]
]