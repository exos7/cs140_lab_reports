#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article 

#maketitle(
   title: "CS 140 Lab Report 5",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",),
)

#enum(spacing: 10pt)[
  QEMU maps physical address `0x100000` to the write register of a virtual shutdown I/O device.Writing the magic value `0x5555` to this register causes QEMU to shut down.\
  Using the code in `sys_shutdown` of `kernel/sysproc.c` as a guide, modify the xv6 `exec` syscall such that the virtual page containing virtual address `0x100000` of all user processes calling exec would be mapped to the physical page containing physical address `0x100000` with reads and writes allowed in user mode—this should enable a user process that executes `(*(volatile uint32 *) 0x100000) = 0x5555;` to shut QEMU down. Ensure that user processes are able to terminate gracefully—you may need to modify `proc freepagetable` in `kernel/proc.c `for this. Show all relevant changes made (with corresponding filenames) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly committed and pushed to your Github Classroom repository. Include the user program and `Makefile` changes you used to test your implementation.
  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* \ This change modifies the `exec` function in `exec.c` to map the virtual address and physical address to `0x100000`.#figure(
      image("assets/item 1 1.png"),
      caption: [`exec()` change in `exec.c`]
    )
    This change is important to ensure shutdown gets unmapped.
    #figure(
      image("assets/item 1 2.png"),
      caption: [`proc_freepagetable` change in `proc.c`]
    )
  ]
][
  Explain in detail how xv6 ensures that accessing the `kernel_satp` field of the `trapframe` field of the active PCB results in the correct memory location despite the user page table still being in use.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* xv6 ensures that `kernel_satp` is accessed correctly by mapping `TRAPFRAME` in both user and kernel page tables at the same address. This makes it that when a trap occurs, it guarantees that the trapframe is accessible under the user page table and is still accessible even if you switch to the kernel page table.
  ]
][
  Explain how `uservec` is still able to execute `sfence.vma zero, zero` right after `csrw satp, t1` despite the page table changing after `csrw satp, t1` is executed.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* It still able to execute `sfence.vma zero, zero` because xv6 maps trampoline at the same address in both user and kernel page tables. This makes sure that the CPU never loses access to it even after switching page tables.
  ]
][
  `exec` sets a stack guard page when setting up the user page table. Explain what a stack guard page is for, and how exactly `exec` allocates the said page for it to serve as one. Cite all references used.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* A stack guard page is an unmapped page placed below the user stack to catch whenever a stack overflow occurs. Whenever a a stack overflow occurs, the guard page will trigger a page-fault exception to avoid overwriting other memory. \
    When `exec` allocates and initializes a user stack. It just allocates just one stack page then it places an inaccessible page just below the stack page to serve as the guard page. (pp 40-41)
    \
    Reference: #link("https://pdos.csail.mit.edu/6.S081/2022/xv6/book-riscv-rev3.pdf")
  ]
][
  Create a system call `vaspace` with syscall number `23` that prints the base addresses of all valid virtual pages of the invoking process along with their read, write, execute, and user permissions. Check until just before `MAXVA`. Include a corresponding user mode wrapper function. For each valid virtual page, a line formatted as `<b>: <r><w><x><u>` should be printed in increasing order of virtual addresses where each token is as follows (sample line is `0x0: RWX-`):

  #list[
    `<b>`: Base virtual address of virtual page in hex with 0x prefix, no leading zeros][
    `<r>`: `R` if the virtual page has read permissions, or - otherwise][
    `<w>`: `W` if the virtual page has write permissions, or - otherwise][
    `<x>`: `X` if the virtual page has execute permissions, or - otherwise][
    `<u>`: `U` if the virtual page has its user bit set, or - otherwise
  ] \
  Additionally, create `user/vaspace.c` with the code in Code Block 1, run it (ensuring your change for Item 1 is present), and take a screenshot of the output. For each page in the output, describe what the purpose of the page is and justify your answer with the permission bits set, other lines of the output, and, if necessary, additional information from the xv6 codebase. \
  Show all relevant changes made (with corresponding filenames) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly committed and pushed to your Github Classroom repository.\ \
  This change adds the vaspace syscall and assign it to number 23
  #figure(
    image("assets/item5/4.png"),
    caption: [`syscall.h` change]
  ) \
  These changes add the prototype and adds the array mapping for the `vaspace` syscall
  #figure(
    image("assets/item5/5.png"),
    caption: [`syscall.c` change 1]
  )

  #figure(
    image("assets/item5/8.png"),
    caption: [`syscall.c` change]
  )

  This change implements the `vaspace` syscall
  #figure(
    image("assets/item5/6.png"),
    caption: [`sysproc.c` change]
  ) \

  These changes implement a wrapper function for the `vaspace` syscall
  #figure(
    image("assets/item5/1.png"),
    caption: [`usys.pl` change]
  )

  #figure(
    image("assets/item5/2.png"),
    caption: [`user.h` change]
  ) \
  This change adds the user program to test the `vaspace` syscall given by Code Block 1 in the specs.
  #figure(
    image("assets/item5/3.png"),
    caption: [`MAKEFILE` change]
  ) \

  This is the output of the `vaspace` syscall
  #figure(
    image("assets/item5/7.png"),
    caption: [Output of `vaspace` syscall]
  ) \
][
  Explain how xv6 page fault handling stays consistent with cumulative memory allocations via `sbrk` and how the handling already accommodates stack memory accesses.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* By analyzing `sys_sbrk` in `sysproc.c`, we can see from the comments that `sbrk` lazily increases the size of the memory but doesn't allocate memory. If the process uses the memory, `vmfault()` will allocate it. This keeps the memory allocations consistent.
  ]
][
  The `fork` syscall is able to copy the data of parent to the child via `uvmcopy`. Explain what each line of `uvmcopy` does and what it is for. Exclude lines containing only braces.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* \
    This declares the variables used in the function `uvmcopy`. pte is the page table entry, pa is the physical address, i is a loop counter, and flags are the permission bits of the page.
     \
    #figure(
      image("assets/item8/1.png"),
      caption: [declaration of variables]
    ) \
    This loop iterates through each page in the parent's page table. It starts from the first page and goes up to the size of the parent's memory, incrementing by the page size each iteration. During the loop, it checks if the PTE is valid, if it is not valid, it goes to the next page. If it is valid, it gets the physical address (pa) and the permission bits (flags) of the page. If it fails it goes to `err` which will be in the next figure. If it is successful, it will go to `memmove` which copies the contents of parent's page to the child's page. If it is successful, it uvmcopy returns 0. If it fails, it goes to `err`.
     \
    #figure(
      image("assets/item8/2.png"),
      caption: [for loop that iterates through each page in the parent's page table]
    )]

#showybox(frame: (body-color: luma(80%)))[
  This will unmap all the pages removing all allocations done by uvmcopy and then returns -1.
    #figure(
      image("assets/item8/3.png"),
      caption: [gets the page table entry of the current page]
    ) \
  ]
]