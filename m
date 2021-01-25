Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] fio: fix premature final dlclose of dynamic engine
References: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <faa26c59-f53d-a512-3f68-73549e47dfb0@kernel.dk>
Date: Mon, 25 Jan 2021 14:04:16 -0700
MIME-Version: 1.0
In-Reply-To: <6bb40362-44e3-2138-25c5-0f7630179e09@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Yigal Korman <ykorman@gmail.com>, "Richard W.M. Jones" <rjones@redhat.com>
List-ID: <fio@vger.kernel.org>

On 1/25/21 12:13 PM, Eric Sandeen wrote:
> When running a job like this, with external engines enabled:
> 
> [global]
> ioengine=pmemblk
> directory=/mnt/test
> thread=1
> direct=1
> iodepth=1
> 
> [pmemblk-job2]
> filename=pmemblk-smallrw,4096,17
> rw=readwrite
> 
> [pmemblk-job2]
> filename=pmemblk-randrw,4096,64
> rw=randrw
> 
> it segfaults if the first thread to finish is the one that dlopened the engine,
> and the 2nd thread has everything ripped out from under it:
> 
> # fio --debug=io pmemblk.fio
> ...
> io       18361 close ioengine pmemblk
> io       18362 prep: io_u 0x285e1c0: off=0x2108000,len=0x1000,ddir=1,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 queue: io_u 0x285e1c0: off=0x2108000,len=0x1000,ddir=1,file=/mnt/test/pmemblk-randrw,4096,64
> io       18361 free ioengine pmemblk
> io       18362 complete: io_u 0x285e1c0: off=0x2108000,len=0x1000,ddir=1,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 fill: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18361 ioengine pmemblk unregistered
> io       18362 prep: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 queue: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 complete: io_u 0x285e1c0: off=0x1bcc000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 fill: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 prep: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 queue: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 complete: io_u 0x285e1c0: off=0xe91000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 fill: io_u 0x285e1c0: off=0x3413000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 prep: io_u 0x285e1c0: off=0x3413000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> io       18362 queue: io_u 0x285e1c0: off=0x3413000,len=0x1000,ddir=0,file=/mnt/test/pmemblk-randrw,4096,64
> Segmentation fault (core dumped)
> 
> Fix this by keeping the dlhandle on the io engine itself, not the thread,
> then explicitly dlopen for every thread that asks for the engine, and let
> dlopen/dlclose do refcounting as designed.
> 
> I think this is right, and it fixes it for me, but good review would be wise!
> 
> Also: maybe the 2 patches could be collapsed, though I /think/ this makes review
> a bit easier and doesn't add any regression at patch1 ...

Applied them separately, thanks.

-- 
Jens Axboe


