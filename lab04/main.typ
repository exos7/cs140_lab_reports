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
    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* the `main` function will call different functions to initialize the kernel. It will then run `userinit()` to create the first user process. Going into `userinit()`, it will then call `allocproc()` to allocate a process. After this, it will set the state of the process to `RUNNABLE`. In here, it will also set `p->context.ra` by running `forkret`. After returning to `main`, it will call `scheduler()`. Going into it, this will turn the `userinit` process to `RUNNING` state and will switch to the process using `swtch()`. After this, it will go back to what we got in `forkret` and will then run `prepare_return()` to switch back to user mode. Since the process is now in user mode, it will then execute `init` \ \ The flow of code will be as follows:
      `main` -> `userinit` -> `allocproc` -> `scheduler` -> `swtch` -> `forkret` -> `prepare_return` -> `init`] 
      #showybox(frame: (body-color: luma(80%)))[
      #figure(
        image("assets/1a/1.png", width: 50%),
        caption: [Relevant code snippet 1 (`main` in `main.c`)]
      )
      #figure(
        image("assets/1a/2.png", width: 50%),
        caption: [Relevant code snippet 2 (`userinit` in `proc.c`)]
      )
      #figure(
        image("assets/1a/3.png", width: 50%),
        caption: [Relevant code snippet 3 (`forkret` in `proc.c`)]
      )
      #figure(
        image("assets/1a/4.png", width: 50%),
        caption: [Relevant code snippet 4 (`scheduler` in `main.c`)]
      )]
      #showybox(frame: (body-color: luma(80%)))[
      #figure(
        image("assets/1a/5.png", width: 50%),
        caption: [Relevant code snippet 5 (`scheduler` in `proc.c`)]
      )
      #figure(
        image("assets/1a/6.png", width: 50%),
        caption: [Relevant code snippet 6 (`forkret` in `proc.c`)]
      )
    ]
  ][
    Explain why it is important for `exit` to wake a possibly sleeping process up.
    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* It is important for `exit` to wake a possibly sleeping process up because the parent process might be sleeping while waiting for the child to terminate. The parent process will be in `wait()` and will be in `SLEEPING` state. If the child process calls `exit()`, it will have to wake up the parent process so that it can continue its execution and properly handle the termination of the child process. 
      #figure(
        image("assets/1b/1.png", width: 50%),
        caption: [Relevant code snippet 1 (`exit` in `proc.c`)]
      )]
  ][
    Explain what happens when a child process calls `exit`, but the parent process does not call `wait` and why this situation must be avoided.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* When a child process calls `exit`, but the parent process does not call `wait`, the child process will stay in `ZOMBIE` state. This means that the process we want to exit is already done, but it is still there. This means that the parent process will not be able to know that the child process is already done and clean up. This must be avoided because it could lead to memory problems. Even though the process is already done, it is still in memory.
      #figure(
        image("assets/1c/1.png", width: 50%),
        caption: [Relevant code snippet 1 (`exit` in `proc.c`)]
      )]
  ][
    The `kill` syscall allows a process to terminate another process using its PID. Despite this, the `kill` function in `kernel/proc.c` simply sets the value of the `killed` field of the target process to `1`. \
    Explain how setting `killed` to `1` results in the associated process being terminated. Your explanation is expected to relate this termination mechanism to context switching.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* Setting `killed` to `1` will not immediately terminate the process. Instead, it will mark the process as killed. In the next context switch, whenever it calls `usertrap`, it will check if the process is killed. If it is it will call `exit(-1)` to finally terminate the process.
      
      #figure(
        image("assets/1d/1.png", width: 50%),
        caption: [Relevant code snippet 1 (`usertrap` in `trap.c`)]
      )
      ]
  ][
    Go through the code of the xv6 shell may be found in `user/sh.c` and explain using `fork`, `exec`, and `wait` how:
    
    #list[
      Typing `ls` will result in the `ls` user program being executed
    ][
      `sh` is able to pause execution until `ls` ends
    ][
      `sh` is able to continue execution when `ls` ends
    ]

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* When we type `ls`, the shell will first call `fork1()` to create a new process. The new process will then go to `runcmd()`. In there, it will go to `case EXEC` and will call `exec()`. This will replace the process with the implementation of `ls`. The parent process will then go to `wait()` and wait for the child process (the one running `ls`) to finish. When the child process finishes, it will call `exit()` and will go to `wait()` in the parent process. This will then return and the shell will continue its execution.

      #figure(
        image("assets/1e/1.png", width: 50%),
        caption: [Relevant code snippet 1 (`main` in `sh.c`)]
      )

      #figure(
        image("assets/1e/2.png", width: 50%),
        caption: [Relevant code snippet 2 (`runcmd` in `sh.c`)]
      )
    ]
  ]
][ // 2
  Create a user progam `user/formbomb.c` with the code in Code Block 1, run xv6 via `CPUS=1 make qemu`, execute `forkbomb`, and observe its behavior. Commit all changes made related to this item.
  #enum(numbering: "a")[
    Explain what the code in Code Block 1 does and how it is recursive in nature. #showybox(frame: (body-color: luma(80%)))[
      *Answer:* The code in Code Block 1 calls `fork()` in an infinite loop. The first `fork()` will create a child process, then both the parent and child will execute a new `forkbomb` process which will then again call `fork()`.
    ]
  ][
    Describe the output of running `forkbomb`, how it affects the process table, and why it goes on indefinitely. #showybox(frame: (body-color: luma(80%)))[
    *Answer:*  \
    The output of running `forkbomb` are continuous lines of `fork failed for PID #`, where the number is increasing. This is because the process table is getting filled more and more because of `fork()`. It goes indefinitely since there is no condition to stop the loop like `wait()` or `exit()`.
  ]
  ]
  
][ // 3
  Draw a state diagram where there is a one-to-one mapping between states in the diagram and the six xv6 process states with state transition containing the name of the xv6 kernel function that performs the corresponding state change (i.e, which function containts `p->state = PROCESS_STATE_HERE)`.\
  If there are multiple xv6 functions resulting in the same transition, use a single arrow with all function names separated by commas as its label (e.g, `f1`, `f2`).

  #figure(
    image("assets/cs140lab04_3.drawio.png", width: 70%),
    caption: [State diagram of xv6 process states]
  )
][ // 4
  The xv6 implementation of `fork` has the invoking process continue execution after invoking `fork`. Modify xv6 such that calling `fork` instead causes a context switch to the next available process right after the process control block of the child process has been initialized.\
  Show all relevant changes made (with corresponding filename) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly commited and pushed to your Github Classroom repository

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* In order to make `fork` switch to the next available process right after the child process has been initialized, I added a call to `yield()` at the end of the `fork()` function. This will cause the current process to yield the CPU and allow the scheduler to pick the next process to run.

    #figure(
      image("assets/4.png", width: 50%),
      caption: [Relevant code snippet 1 (`fork` in `proc.c`)]
    )
  ]
]