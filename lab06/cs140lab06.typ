#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article 

#maketitle(
   title: "CS 140 Lab Report 6",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",),
)

#enum(spacing: 10pt)[
  Regarding Section 3.1, explain *(1)* what happens when `global.c` is executed and *(2)* why its output is not consistent across multiple reruns of the same executable file.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* When `global.c` is executed, the program creates two threads `t1` and `t2` using `pthread_create`. The threads run `increment()` and `decrement()` respectively. These two functions modify a global variable named `global` by incrementing and decrementing it. This is why the output of `global.c` is inconsistent across multiple runs. This is because both threads are accessing and changing the same variable `global` at the same time.
  ]
  
][
  Regarding Section 3.2, provide a screenshot of the output of `stack` and explain how threads maintain locality of local variables despite having shared address space by referring to the addresses in the screenshot. Relate your answer to the contrasting behavior of `global`.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:*
  #figure(
    image(
      "assets/2.png", 
      width: 50%
    ),
    caption: [Output of `stack`]
  )

  We can see from the screenshot that the two different threads with delta `(1)` and `(-1)` have different stack addresses. This is because each thread has its own stack. In their respective stack, they have their own local variables, namely `x` and `delta`. Compared to `global.c`, where both threads are accessing the same `global` variable. This is why the output of `stack` is consistent across multiple runs.
  ]
][
  Regarding Section 3.3.3, provide screenshots of output of `strace` for both the threaded and the forking C programs an identify which `clone` flag is responsible for ensuring shared address spaces. State all references used.

  #showybox(frame: (body-color: luma(80%)))[
  #figure(
    image(
      "assets/thread.png", 
    ),
    caption: [Output of `strace` for `thread`]
  )

  #figure(
    image(
      "assets/fork.png", 
    ),
    caption: [Output of `strace` for `fork`]
  )
  ]

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* The `CLONE_VM` flag is responsible for ensuring that for the `thread` program, the threads share the same address space. For the `fork` program, there is no `CLONE_VM` flag, which means that the child has its own address space.
  ]
][
  Regarding Section 3.4, answer the following:

  #enum(spacing: 10pt, numbering: "(a)")[
    Provide the realtime execution durations recorded earlier for `speedup` (at least ten for each value of `N`) and compute the average of each set. Explain why the execution time of `speedup` is shorter when `NTHREADS` is changed from 1 to 2.

    #figure(
      table(
        columns: 2,
        [*Run*], [*Execution Time*],
        [1], [0m0.966s],
        [2], [0m0.893s],
        [3], [0m0.790s],
        [4], [0m0.773s],
        [5], [0m0.807s],
        [6], [0m0.783s],
        [7], [0m0.856s],
        [8], [0m0.622s],
        [9], [0m0.601s],
        [10], [0m0.591s],
      ),
      caption: [Execution times for `NTHREADS = 1`]
    )

    #figure(
      table(
        columns: 2,
        [*Run*], [*Execution Time*],
        [1], [0m0.591s],
        [2], [0m0.670s],
        [3], [0m0.586s],
        [4], [0m0.780s],
        [5], [0m0.748s],
        [6], [0m0.696s],
        [7], [0m0.496s],
        [8], [0m0.701s],
        [9], [0m0.676s],
        [10], [0m0.595s],
      ),
      caption: [Execution times for `NTHREADS = 2`]
    )
  ][
    Explain why there is no race condition for the threads in `speedup.c` despite operating on the same array.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* There are no threads in `speedup.c` that operate on the same element. This is because each thread has a specific `start` that it operates on.
    ]
  ]
][
  Regarding Section 3.5, answer the following:

  #enum(spacing: 10pt, numbering: "(a)")[
    Explain why the output of the original `sync.c` is inconsistent across several runs.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* Just like in `(1)`, the threads are accesssing and modifying the same global variable `sum` at the same time.
    ]
  ][
    Explain how adding a mutex to `sync.c` makes it output consistent across several runs.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* By adding mutex, we ensure that only one thread can access and modify `sum` at a time. It locks the critical section of the code, specifically `sum += 1`, so that if one thread is executing this section, the others have to wait until it is unlocked.
    ]
  ]
][
  Regarding Section 3.6, answer the following: \
  #enum(spacing: 10pt, numbering: "(a)")[
    Given `N` threads synchronized by a properly initialized barrier, determine how many threads will end up reaching the line labeled:
    #enum(spacing: 10pt, numbering:"i.")[
      `(A)`

      #showybox(frame: (body-color: luma(80%)))[
        *Answer:* Only `1` thread will end up reaching line `(A)`
      ]
    ][
      `(B)`

      #showybox(frame: (body-color: luma(80%)))[
        *Answer:* There will be `N-1` threads that will reach line `(B)`
      ]
    ]
  ][
    Illustrate a case in which `NTHREADS` is `3` that shows some interleaved order of thread execution in which the threads end up being synchronized by the barrier. Make reference to relevant variable values and conditions

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* We have the following order of execution:

      1. Thread 1 will reach the barrier first then it will run `wait_barrier(&b, 3)`. It will then go to line `pthread_mutex_lock(&b->lock)` which will lock the barrier. It will then go to `if(b->num_waiting == 0)` which is true then it will go to `if(b->num_exited == n)` which is true then it will now run `b->is_open = 0` after that, it will exit the if statement then will now go to `b->num_waiting += 1` then it will unlock the barrier. It will now go to `if (b->num_waiting == n)` which is false then it will go to the `else` statement which is `while (b->is_open == 0) {}` which is where it will be stuck.

      2. Thread 2 will then reach the barrier while Thread 1 is stuck in the `while` loop. It will then run `wait_barrier(&b, 3)`. It will then go to `pthread_mutex_lock(&b->lock)` like Thread 1, it will then go `if (b->num_waiting == 0)` which will be false so it goes to `b->num_waiting += 1` then it will run `pthread_mutex_unlock(&b->lock)` now it will go to `if(b->num_waiting == n)` which is false then it will go to the `else` statement which is `while (b->is_open == 0) {}` which is where it will be stuck.

      3. Thread 3 will have a similar execution to Thread 2: `wait_barrier(&b, 3), pthread_mutex_lock(&b->lock), if(b->num_waiting == 0), b->num_waiting += 1, pthread_mutex_unlock(&b->lock), if (b->num_waiting == n)` this is where it diverges from Thread 2 because this will be true. Now it will now go to `b->num_waiting = 0, b->num_exited = 1, b->is_open = 1` then Thread 3 will be done executing. Now that `b->is_open = 1`, Thread 1 and Thread 2 will now be able to exit the `while` loop where they were stuck.

      4. Thread 1 will now run `pthread_mutex_lock(&b->lock)` then `b->num_exited += 1` then it will go to `pthread_mutex_unlock(&b->lock)` then it will finish executing.

      5. Thread 2 will now run the same as Thread 1: `pthread_mutex_lock(&b->lock), b->num_exited += 1, pthread_mutex_unlock(&b->lock)` then it will finish executing.
    ]
  ][
    Assume a barrier `b` supporting `N > 1` threads that is currently in the process of letting the `N` threads through _(i.e., the barrier is currently open for them)._ Illustrate how a new thread _(i.e., not part of the `N` barrier-exiting threads_ that attempts to use the same barrier via a call to `wait_barrier(&b, N`) will properly be denied passage through the barrier. Make reference to relavant variable values and conditions.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* The last thread will run `b->num_waiting = 0`. This means that the new process will be able to enter `if(b->num_waiting == 0)`. It will then run `if(b->num_exited == n)` which will be false since it was stated that it is still in the process of letting the `N` threads through. It will then go to the `else` statement which will run `pthread_mutex_unlock(&b->lock)` then it will get stuck in `while(b->num_exited != n) {}` until all `N` threads have exited the barrier. Then it will run `pthread_mutex_lock(&b->lock)` then run `b->is_open = 0` then it will run `b->num_waiting += 1` then it will run `pthread_mutex_unlock(&b->lock)` then it will go to `if(b->num_waiting == n)` which will be false since it is a new thread. It will then go to the `else` statement where it will get stuck in `while(b->is_open == 0) {}` until the barrier is open again.
    ]
  ][
    For each `pthread_mutex_lock` call in `barrier.c` _(see comment labels_, enumerate all possible `pthread_mutex_calls` that can undo the lock that it sends on the mutex _(i.e., a possible unlock pair for the lock call)_. Listing of labels for each will suffice _(e.g., `(2)`, `(6)`)_:

    #list(spacing: 10pt)[
      `(1)`

      #showybox(frame: (body-color: luma(80%)))[
        *Answer:* `(2)`, `(4)`
      ]
    ][
      `(3)`

      #showybox(frame: (body-color: luma(80%)))[
        *Answer:* `(4)`
      ]
    ][
      `(5)`

      #showybox(frame: (body-color: luma(80%)))[
        *Answer:* `(6)`
      ]
    ]
  ]
][
  Regarding Section 3.7, answer the following:

  #enum(spacing: 10pt, numbering:"(a)")[
    Explain how the semaphore-based barrier is able to ensure that no more than `N` threads are able to pass through the barrier. Make reference to semaphore values and calls to `wait` and `post`.
  ][
    Illustrate with a concrete example how commenting out the line labeled `(A)` in Code Block 7 may potentially cause a _deadlock_
  ]
]

#bibliography(
  style: "american-psychological-association",
  ("refs.bib"),
  full: true,
)