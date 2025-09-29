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
][
  Explain in detail how xv6 ensures that accessing the `kernel_satp` field of the `trapframe` field of the active PCB results in the correct memory location despite the user page table still being in use.
][
  Explain how `uservec` is still able to execute `sfence.vma zero, zero` right after `csrw satp, t1` despite the page table changing after `csrw satp, t1` is executed.
][
  `exec` sets a stack guard page when setting up the user page table. Explain what a stack guard page is for, and how exactly `exec` allocates the said page for it to serve as one. Cite all references used.
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
  Show all relevant changes made (with corresponding filenames) via code screenshots or snippets, and briefly describe what each change does. Ensure that your changes are properly committed and pushed to your Github Classroom repository.
  
][
  Explain how xv6 page fault handling stays consistent with cumulative memory allocations via `sbrk` and how the handling already accommodates stack memory accesses.
][
  The `fork` syscall is able to copy the data of parent to the child via `uvmcopy`. Explain what each line of `uvmcopy` does and what it is for. Exclude lines containing only braces.
]