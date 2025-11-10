#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article.with(lang: "en") 

#set enum(spacing: 15pt)
#set list(spacing: 15pt)

#maketitle(
   title: "CS 140 Lab Report 09",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",)
)

#enum[ // item 3
  Ensure that you have properly commited and pushed your working `checksum` implementation *and test program* as specified in Section 3.1 to your Github Classroom repository.
][ // item 2
  Illustrate the following aspects of your `checksum` solution (_ensure that you refer to actual lines of code; no need to explain internals of *bread*_):

  #enum(numbering:"(a)")[ // a
    How it is determined whether a byte in a block is to be ignored with respect to the checksum value (_i.e., how bytes 1-511 of the second block are excluded when computing the checksum of a 1025-byte file_)
  ][ // b
    How data in direct blocks is retrieved (_provide a concrete example of involving at least two direct blocks_)
  ][ // c
    How data in indirect blocks is retrieved (_provide a concrete example of involving at least two blocks referenced from the indirect block_)
  ]
][ // item 3
  If xv6 is set to have `15` direct pointers and `3` indirect pointers and that disk block numbers are four bytes wide, determine the largest file size in bytes that axv6 can accomodate. Show complete solution.
][ // item 4
  The `bread` function of `bio.c` calls `virtio_disk_rw` of `virtio_disk.c` to retrieve a particular block from the virtual hard disk. `virtio_disk_intr` handles interrupts related to the virtual hard disk. Both functions use MMIO to communicate with the virtual hard disk. Provide screenshots of xv6 code that *(1)* define and *(2)* use the following:

  #enum(numbering:"(a)")[
    IRQ number associated with the virtual hard disk
  ][
    Memory-mapped address used to notify the virtual hard disk that queue `0` has new I/O requests
  ][
    Sleep lock used to ensure exclusive access to a `struct buf` value
  ]
]
