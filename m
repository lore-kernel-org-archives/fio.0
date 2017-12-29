Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] debug: make debug=io readable with multiple threads
References: <20171221011219.780-1-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5c009455-61dc-a948-e457-3d7a7952a66b@kernel.dk>
Date: Fri, 29 Dec 2017 08:15:25 -0700
MIME-Version: 1.0
In-Reply-To: <20171221011219.780-1-elliott@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/20/17 6:12 PM, Robert Elliott wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> When multiple threads are active, debug=io prints are unreadable as the output
> is interleaved. Multiple log_info_buf() calls are used to construct each line,
> but there is no mutual exclusion covering multiple calls.
> 
> Change the dprint call tree to construct the entire line before passing it to
> log_info_buf(), rather than make several calls.
> 
> Other nits:
> * print the thread ID rather than the process ID
> * change offset and length from decimal to hex
> * separate offset, length, ddir, and file with , rather than / since the
>   filename on the same line likely has / of its own
> * change "fill_io_u" to "fill" to match the others
> * change "io complete" to "complete" to match the others
> * change "->prep()=%d" to "prep: io_u %p: ret=%d" to resemble the others
> * change offset/buflen in an error print to better resemble the normal prints
> * add "file=" prefix for the filename
> * check the calloc() return values inside the valist_to_buf functions
> 
> Old:
> fill_io_u: io_u 0x7feeac010b80: off=720896/len=65536/ddir=1
> 
> io       50692io       50692//dev/dax0.0io       50692fill_io_u: io_u 0x7fee98010b80: off=196608/len=65536/ddir=1io       50692io       50692
> io       50692->prep(0x7fef10010b80)=0
> //dev/dax0.0//dev/dax1.0io       50692io       50692io       50692io       50692->prep(0x7feeec010b80)=0
> io       50692prep: io_u 0x7feec4010b80: off=1966080/len=65536/ddir=1io       50692io complete: io_u 0x7feedc010b80: off=393216/len=65536/ddir=1io
> 50692io       50692prep: io_u 0x7feef4010b80: off=720896/len=65536/ddir=1io       50692io       50692
> io       50692io       50692prep: io_u 0x7feef0010b80: off=851968/len=65536/ddir=1//dev/dax0.0io       50692//dev/dax0.0
> 
> //dev/dax0.0
> io       50692io       50692//dev/dax0.0//dev/dax0.0io       50692
> 
> New:
> io       71400 queue: io_u 0x7fd0f0010b80: off=0x2f0000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71395 fill: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71395 prep: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71395 prep: io_u 0x7fd0fc010b80: ret=0
> io       71395 queue: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71430 complete: io_u 0x7fd05c010b80: off=0x180000,len=0x10000,ddir=1,file=/dev/dax1.0
> io       71400 complete: io_u 0x7fd0f0010b80: off=0x2f0000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71430 fill: io_u 0x7fd05c010b80: off=0x190000,len=0x10000,ddir=1,file=/dev/dax1.0
> io       71400 fill: io_u 0x7fd0f0010b80: off=0x300000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71400 prep: io_u 0x7fd0f0010b80: off=0x300000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71400 prep: io_u 0x7fd0f0010b80: ret=0
> io       71400 queue: io_u 0x7fd0f0010b80: off=0x300000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71430 prep: io_u 0x7fd05c010b80: off=0x190000,len=0x10000,ddir=1,file=/dev/dax1.0
> io       71395 complete: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71430 prep: io_u 0x7fd05c010b80: ret=0
> io       71430 queue: io_u 0x7fd05c010b80: off=0x190000,len=0x10000,ddir=1,file=/dev/dax1.0
> io       71421 complete: io_u 0x7fd090010b80: off=0x320000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71419 complete: io_u 0x7fd098010b80: off=0x320000,len=0x10000,ddir=1,file=/dev/dax0.0
> io       71404 complete: io_u 0x7fd0d0010b80: off=0x0,len=0x10000,ddir=1,file=/dev/dax0.0

Looks good, thanks for doing this! Applied.

-- 
Jens Axboe


