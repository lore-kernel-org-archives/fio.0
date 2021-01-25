Return-Path: <sandeen@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] fio: fix premature final dlclose of dynamic engine
Message-ID: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
Date: Mon, 25 Jan 2021 13:13:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Yigal Korman <ykorman@gmail.com>, "Richard W.M. Jones" <rjones@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

When running a job like this, with external engines enabled:

[global]
ioengine=pmemblk
directory=/mnt/test
thread=1
direct=1
iodepth=1

[pmemblk-job2]
filename=pmemblk-smallrw,4096,17
rw=readwrite

[pmemblk-job2]
filename=pmemblk-randrw,4096,64
rw=randrw

it segfaults if the first thread to finish is the one that dlopened the engine,
and the 2nd thread has everything ripped out from under it:

# fio --debug=io pmemblk.fio
...
io       18361 close ioengine pmemblk
io       18362 prep: io_u 0x285e1c0: off=0x2108000,len=0x1000,ddir=1,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 queue: io_u 0x285e1c0: off=0x2108000,len=0x1000,ddir=1,file=/mnt/test/pmemblk-randrw,4096,64
io       18361 free ioengine pmemblk
io       18362 complete: io_u 0x285e1c0: off=0x2108000,len=0x1000,ddir=1,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 fill: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18361 ioengine pmemblk unregistered
io       18362 prep: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 queue: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 complete: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 fill: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 prep: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 queue: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 complete: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 fill: io_u 0x285e1c0: off=0x3413000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 prep: io_u 0x285e1c0: off=0x3413000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
io       18362 queue: io_u 0x285e1c0: off=0x3413000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
Segmentation fault (core dumped)

Fix this by keeping the dlhandle on the io engine itself, not the thread,
then explicitly dlopen for every thread that asks for the engine, and let
dlopen/dlclose do refcounting as designed.

I think this is right, and it fixes it for me, but good review would be wise!

Also: maybe the 2 patches could be collapsed, though I /think/ this makes review
a bit easier and doesn't add any regression at patch1 ...

Thanks,
-Eric


