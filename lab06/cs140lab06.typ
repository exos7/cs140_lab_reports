#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article 

#maketitle(
   title: "CS 140 Lab Report 6",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",),
)

#enum(spacing: 10pt)[
  Regarding Section 3.1, explain *(1)* what happens when `global.c` is executed and *(2)* why its output is not consistent across multiple reruns of the same executable file.
][
  Regarding Section 3.2, provide a screenshot of the output of `stack` and explain how threads maintain locality of local variables despite having shared address space by referring to the addresses in the screenshot. Relate your answer to the contrasting behavior of `global`.
][
  Regarding Section 3.3.3, provide screenshots of output of `strace` for both the threaded and the forking C programs an didentify which `clone` flag is responsible for ensuring shared address spaces. State all references used.
][
  Regarding Section 3.4, answer the following:

  #enum(spacing: 10pt, numbering: "(a)")[
    Provide the realtimeexecution durations recorded earlier for `speedup` (at least ten for each value of `N`) and compute the average of each set. Explain why the execution time of `speedup` is shorter when `NTHREADS` is changed from 1 to 2.
  ][
    Explain why there is no race condition for the threads in `speedup.c` despite operating on the same array.
  ]
][
  Regarding Section 3.5, answer the following:

  #enum(spacing: 10pt, numbering: "(a)")[
    Explain why the output of the original `synbc.c` is inconsistent across several runs.
  ][
    Explain how adding a mutex to `sync.c` makes it output consistent across several runs.
  ]
][
  Regarding Section 3.6, answer the following: \
  #enum(spacing: 10pt, numbering: "(a)")[
    Given `N` threads synchronized by a properly initialized barrier, determine how many threads will end up reaching the line labeled:
    #enum(spacing: 10pt, numbering:"i.")[
      `(A)`
    ][
      `(B)`
    ]
  ][
    Illustrate a case in which `NTHREADS` is `3` that shows some interleaved order of thread execution in which the threads end up being synchronized by the barrier. Make reference to relevant variable values and conditions
  ][
    Assume a barrier `b` supporting `N > 1` threads that is currently in the process of letting the `N` threads through _(i.e., the barrier is currently open for them)._ Illustrate how a new thread _(i.e., not part of the `N` barrier-exiting threads_ that attempts to use the same barrier via a call to `wait_barrier(&b, N`) will properly be denied passage through the barrier. Make reference to relavant variable values and conditions.
  ][
    For each `pthread_mutex_lock` call in `barrier.c` _(see comment labels_, enumerate all possible `pthread_mutex_calls` that can undo the lock that it sends on the mutex _(i.e., a possible unlock pair for the lock call)_. Listing of labels for each will suffice _(e.g., `(2)`, `(6)`)_:

    #list(spacing: 10pt)[
      `(1)`
    ][
      `(3)`
    ][
      `(5)`
    ]
  ]
][
  Regarding Section 3.7, answer the following:

  #enum(spacing: 10pt, numbering:"(a)")[
    Explain how the semaphore-based barrier is able to ensure that no more than `N` threads are able to pass through the barrier. Make reference to semaphore values and calls to `wait` and `post`.
  ][
    Illustrate with a concrete example how commenting out the line labeled `(A)` in Code BLock 7 may potentially cause a _deadlock_
  ]
]