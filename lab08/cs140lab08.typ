#import "@preview/rubber-article:0.5.0": * 
#import "@preview/showybox:2.0.4": showybox

#show: article.with(lang: "en")

#set enum(spacing: 15pt)
#set list(spacing: 15pt)

#maketitle(
   title: "CS 140 Lab Report 08",
   authors: ("Dale Sealtiel T. Flores \n 2023-11373 \n THX/WXY",)
)

#enum[ // item 1
  Show all relevant changes made (with corresponding filenames) via code screenshots or snippets for the exercise in Section 2.8, briefly describe what each change does. Ensure that your changes are properly committed and pushed to your Github Classroom repository.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* These are the changes that I made in order to implement the needed behavior in Section 2.8

    #figure(
      image("assets/keyseq.png"),
      caption: [Change 1 in `console.c`]
    )

    This change is to have the key sequence be put in a sequence in order to have its order preserved *(Up, Up, Down, Down, Left, Right, Left, Right, b, a, and then Ctrl-x).*

    #figure(
      image("assets/index.png"),
      caption: [Change 2 in `console.c`]
    )

    This change is to keep track of the key presses to be used in _figure 1_.
  ]
  #showybox(frame: (body-color: luma(80%)))[
    #figure(
      image("assets/convert.png"),
      caption: [Change 3 in `console.c`]
    )
    This change is needed since if we look at `consoleintr` it passes in an `int c`. We need to convert it first in order to know if we pressed the right button.

    #figure(
      image("assets/main.png"),
      caption: [Change 4 in `console.c`]
    )

    This is the main change for the behavior needed for Section 2.8 It checks whether the key pressed is in the key sequence in _figure 1_. If it is, it will increment the global index. If not, it will reset the global index back to 0. If the global index reaches the end of the sequence, it will shutdown xv6. The code that was used was copy and pasted from `sys_shutdown` in `kernel/syscall.c`.
  ]
][ // item 2
  Describe what happens when `WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);` in `uartinit` is commented out and explain why that is the case.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* The user cannot type in the console of xv6. This is explained in Section 2.6 of the Lab Exercise specifications(_"When the UART becomes ready to either read or write data, it raises an interrupt"_). We can also get hints from the comments in `uartinit` above the instruction said in the question (_"enable transmit and receive interrupts"_). Now we can conclude that since we disabled interrupts by commenting out the instruction, the UART is now unable to read or write the data needed for typing in the console.
  ]
][ // item 3
  Identify the block of xv6 code (and which file it is in) that allows the kernel to map the page frame containing physical address `0x10000000` to a virtual page

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* The code that allows the kernel to map the page frame containing the physical address to a virtual page can be found in `pagetable_t kvmmake(void)` inside of `kernel/vm.c`

    #figure(
      image("assets/map.png"),
      caption: [Code for mapping the physical address to a virtual page],
    )
  ]
][ // item 4
  For the following items, refer to `uartputc_sync` in `kernel/uart.c`:
  #enum(numbering:"(a)")[
    Explain how `uartputc` and `uartputc_sync` differ in terms of how the circular transmit buffer and how interrupts are used.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* The difference of `uartputc` and `uartputc_sync` in their usage of the circular transmit buffer and interrupts is `uartputc` uses them while `uartputc_sync` doesn't. We can see from the comments in `kernel/uart.c`,

      #figure(
        image("assets/uartputc_sync.png"),
        caption: [Comments in `uartputc_sync` in `kernel/uart.c`]
      )
    ]
    #showybox(frame: (body-color: luma(80%)))[
      `uartputc_sync` doesn't use interrupts. We can also observe from the code itself that it doesn't use the circular transmit buffer. It does `WriteReg(THR, c)` instead of using the variables `uart_tx_r` and `uart_tx_w` to write to the buffer.

      #figure(
        image("assets/uartputc.png"),
        caption: [Code of `uartputc` in `kernel/uart.c`]
      )
    ]
  ][
    Excluding those in `kernel/printf.c`, enumerate all instances in the xv6 kernel that call `consputc` (which calls `uartputc_sync`) by showing screenshots or code snippets and their respecting files.

    #showybox(frame: (body-color: luma(80%)))[
      *Answer:* There are *3* instances of `consputc` (_excluding those in `kernel/printf.c`_). All of the calls are from `consoleintr` in `kernel/console.c`
    ]
    #showybox(frame: (body-color: luma(80%)))[
      #figure(
        image("assets/4.b/u.png", width: 75%),
        caption: [`constput(BACKSPACE)` in `kernel/console.c`]
      )
      #figure(
        image("assets/4.b/h.png", width: 75%),
        caption: [`consputc(BACKSPACE)` in `kernel/console.c`]
      )
      #figure(
        image("assets/4.b/default.png", width: 75%),
        caption: [`consputc(c)` in `kernel/console.c`]
      )
    ]
    
  ]
][ // item 5
  Explain why there is a need for callers of `uartstart` to obtain the `uart_tx_lock` lock.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* If we look at the code of `uartstart`, it uses the circular transmit buffer.

    #figure(
      image("assets/uartstart.png", width: 75%),
      caption: [`uartstart` code block]
    )

    These variables are also used in different functions since it is the variables of the circular transmit buffer. Since these variables are used in different functions such as `uartputc`, having locks ensures that it doesn't cause race conditions ensuring that the data in the circular buffer is consistent.
  ]
][//item 6
  Identify the functions called in sequence starting from `devintr` and until `consputc` that results in a key such as `a` that that the user presses to be displayed on screen. Do not include macro "calls".

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* When a user types a character such as `a` it will raise an interrupt that activates the trap handler which calls `devintr` which it will call `r_scause()` then it will call `int irq = plic_claim()` to determine which device interrupted. Since it is it the UART, it will now call `uartintr` which will read the input which will then call `consoleintr` which will then call `consput(c)` which will display the character that was typed which is `a` for our case. \
    #figure(
      table(
        columns: 2,
        [*Order*], [*Function*],
        [1], [`devintr`],
        [2], [`r_scause()`],
        [3], [`int irq = plic_claim()`],
        [4], [`uartintr`],
        [5], [`consoleintr`],
        [6], [`consput(c)`],
      ),
      caption:[Summary],
    )
  ]

][ // item 7
  Supposing that `uart_tx_buf` is currently set to `140`, illustrate what happens to the buffer step-by-step when `uartputc('W');` is called which causes the buffer to become full. Assume that the call to `uartstart` by `uartputc('W')` causes the buffer to be fully processed (i.e., it will be empty when `uartstart` returns). Ensure all data read from and written to the UART is shown.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* We know that that buffer size is 32 bytes. So since `uart_tx_buf` is set to `140` and calling `uartputc('W')` will cause it to become full. We have $140-31=109$ for the `uart_tx_r`. \ In summary we have `uart_tx_w` = 140 and `uart_tx_r` = 109. \
    After `uartstart` is called, it will now process the buffer.

    #figure(
      table(
        columns: 4,
        [*Step*], [*`uart_tx_r`*],[*`uart_tx_r` % 32*], [*State*],
        [1],[109], [13], [`uart_tx_buf[13]`],
        [2],[110], [14], [`uart_tx_buf[14]`],
        [3],[111], [15], [`uart_tx_buf[15]`],
        [4],[112], [16], [`uart_tx_buf[16]`],
        [5],[113], [17], [`uart_tx_buf[17]`],
        [6],[114], [18], [`uart_tx_buf[18]`],
        [7],[115], [19], [`uart_tx_buf[19]`],
        [8],[116], [20], [`uart_tx_buf[20]`],
        [9],[117], [21], [`uart_tx_buf[21]`],
        [10],[118], [22], [`uart_tx_buf[22]`],
        [11],[119], [23], [`uart_tx_buf[23]`],
        [12],[120], [24], [`uart_tx_buf[24]`],
        [13],[121], [25], [`uart_tx_buf[25]`],
        [14],[122], [26], [`uart_tx_buf[26]`],
        [15],[123], [27], [`uart_tx_buf[27]`],
        [16],[124], [28], [`uart_tx_buf[28]`],
        [17],[125], [29], [`uart_tx_buf[29]`],
        [18],[126], [30], [`uart_tx_buf[30]`],
        [19],[127], [31], [`uart_tx_buf[31]`],
        [20],[128], [0], [`uart_tx_buf[0]`],
        [21],[129], [1], [`uart_tx_buf[1]`],
        [22],[130], [2], [`uart_tx_buf[2]`],
        [23],[131], [3], [`uart_tx_buf[3]`],
        [24],[132], [4], [`uart_tx_buf[4]`],
        [25],[133], [5], [`uart_tx_buf[5]`],
        [26],[134], [6], [`uart_tx_buf[6]`],
        [27],[135], [7], [`uart_tx_buf[7]`],
        [28],[136], [8], [`uart_tx_buf[8]`],
        [29],[137], [9], [`uart_tx_buf[9]`],
        [30],[138], [10], [`uart_tx_buf[10]`],
        [31],[139], [11], [`uart_tx_buf[11]`],
        [32],[140], [12], [`uart_tx_buf[12]`],
      )
    )
    After `uartstart` finishes, both `uart_tx_r` and `uart_tx_w` will be `141`.
  ]
][ // item 8
  Illustrate how the xv6 UART driver ensures that writing to relatively slow uart devices (i.e, a large number of C instructions can be executed before the UART is ready for another write) does not hamper program performance. Assume that the circular buffer does not get full.

  #showybox(frame: (body-color: luma(80%)))[
    *Answer:* In xv6, it uses a circular buffer in order to not hamper program performance when writing to slow UART devices. When the UART is not ready, it will store the data to to the circular buffer. When it is ready, it will then call `uartstart` to then process the buffer. This way, the CPU can continue executing while waiting for it to be ready.
  ]
]

