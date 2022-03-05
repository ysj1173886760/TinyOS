# TinyOS
TinyOS based on xv6

# implementation map(deprecated)

First focus on single core implementation.

Implement UART, print 'Hello World'

Construct process framework.

Handle memory manangement, step into virtual memory world

Handle traps

Implement file system

Implement some basic sys-calls

Construct some user-level program and execute it

Then port into multi-core world

Implement locks

Define the critical section in above modules

Handle timer interrupt and implement scheduling

# Update on 3.5

Currently, TinyOS can exec init and sh and some other user programs

check this screenshot

![20220305131043](https://picsheep.oss-cn-beijing.aliyuncs.com/pic/20220305131043.png)

I've not finished porting every syscall from xv6, but i think the rest of part would be easy to implement.

Through this experience, i found the structure and overall design to implement OS between Rust and C is quite different. I used a lot of unsafe part in my code, some is necessary, but some aren't. Fulture work should be to refactor the overall structure, let compiler help us detecting errors. And also change the structure of error handling which is a core feature of Rust.

Even i've finished the lab of mit s6.081, i still learned a lot when re-implementing xv6. I have to carefully think about every minor details to figure out why this code works and other forms doesn't. Still, i think there are more thing i need to learn from xv6, such as code organization and design.

Writing an Operating System is really interesting, if you want to re-implement xv6 just like me, i'm glad to discuss with you about my thinking while i doing this. Also feel free to refer to my code and contact with me. I've added a lot of comments when i met with a bug or some problems, i think those would help others to understand TinyOS and xv6.

Except for re-implement xv6, i also want to enhance it, such as adding TCP stack, implementing threading library, porting on other hardwares and Make TinyOS more robust using Rust. I will be much appreciated if you want to join me.

Enjoy Coding!