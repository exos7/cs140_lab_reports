#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article 

#maketitle(
   title: "CS 140 Lab Report 4",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",),
)

#enum(spacing: 10pt)[ // 1
  Using annotated xv6 code snippets or screenshots (include filenames), answer the following:
  
  \
  #enum(numbering:"(a)", spacing: 10pt)[
    Explain how the `main` function of xv6 is able to context switch into the `init` process by going through relevant function calls.
  ][
    Explain why it is important for `exit` to wake a possibly sleeping process up.
  ][
    Explain what happens when a child process calls `exit`, but the parent process does not call `wait` and why this situation must be avoided.
  ][
    The `kill` syscall allows a process to terminate another process using its PID. Despite this, the `kill` function in `kernel/proc.c` simply sets the value of the `killed` field of the target process to `1`. \
    Explain how setting `killed` to `1` results in the associated process being terminated. Your explanation is expected to relate this termination mechanism to context switching.
  ][
    Go through the code of the xv6 shell may be found in `user/sh.c` and explain using `fork`, `exec`, and `wait` how:
    
    #list[
      Typing `ls` will result in the `ls` user program being executed
    ][
      `sh` is able to pause execution until `ls` ends
    ][
      `sh` is able to continue execution when `ls` ends
    ]
  ]
][ // 2
  Create a user progam `user/formbomb.c` with the code in Code Block 1, run xv6 via `CPUS=1 make qemu`, execute `forkbomb`, and observe its behavior. Commit all changes made related to this item.
  #enum[
    Explain what the code in Code Block 1 does and how it is recursive in nature.
  ][
    Describe the output of running `forkbomb`, how it affects the process table, adn why it goes on indefinitely.
  ]
  #showybox(frame: (body-color: luma(80%)))[
    *Answer:*
  ]
][ // 3
  Draw a state diagram where there is a one-to-one mapping between states in the diagram and the six xv6 process states with state transition containing the name of the xv6 kernel function that performs the corresponding state change (i.e, which function containts `p->state = PROCESS_STATE_HERE)`.\
  If there are multiple xv6 functions resulting in the same transition, use a single arrow with all function names separated by commas as its label (e.g, `f1`, `f2`).
][ // 4
  The xv6 implementation of `fork` has the invoking process continue execution after invoking `fork`. Modify xv6 such that calling `fork` instead causes a context switch to the next available process right after the process control block of the child process has been initialized.\
  Show all relevant changes made (with corresponding filename) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly commited and pushed to your Github Classroom repository
]