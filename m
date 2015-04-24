Return-Path: <axboe@kernel.dk>
Message-ID: <553A71CD.1080505@kernel.dk>
Date: Fri, 24 Apr 2015 10:39:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: crash reports while running IO on raid0 btrfs
References: <CABtFm2Wh07GiQ4HAeOKzDHTNpPRpq+u=CU7xLnwej+HaESzn_w@mail.gmail.com> <553A6D62.5070803@kernel.dk>
In-Reply-To: <553A6D62.5070803@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------000201000005030905020108"
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000201000005030905020108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/24/2015 10:20 AM, Jens Axboe wrote:
> On 04/17/2015 03:13 AM, Srinivasa Chamarthy wrote:
>> Received the following crash reports:
>>
>> fio: pid=2847, got signal=6
>> Jobs: 3 (f=101), CR=1200MB/0B KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.1%
>> done] [0KB/118.1MB/0KB /s] [0/1814/0 iopJobs: 3 (f=97), CR=1200MB/0B
>> KB/s: [K(1),W(1),K(1),W(2),K(1)] [80.2% done] [0KB/40312KB/0KB /s]
>> [0/583/0 iops]*** Error in `fio':
>> double free or corruption (!prev): 0x000000000114d7b0 ***
>> ======= Backtrace: =========
>> /lib64/libc.so.6(+0x730bf)[0x7fcf25c7e0bf]
>> /lib64/libc.so.6(+0x7892e)[0x7fcf25c8392e]
>> /lib64/libc.so.6(+0x79636)[0x7fcf25c84636]
>> fio(free_io_mem+0x97)[0x42c3e7]
>> fio[0x44dc73]
>> fio[0x450fd9]
>> fio(fio_backend+0xfb)[0x45144b]
>> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fcf25c2cb05]
>> fio[0x40d3ec]
>>
>> # fio -v
>> fio-2.2.7-9-g4da2
>
> I can't reproduce this. Could you try a make clean and make again?
> Sometimes fio's build system screws up when you pull in changes, some of
> the dependencies are apparently whacked.

Actually, I think I see what it is. It's because your max bs isn't a 
multiple of the min bs, and fio has a bug in where it rounds up the 
blocksize as a multiple of the min bs. So we end up rounding up to 128K, 
where the max should be 124K. This causes us to overwrite allocated 
memory, and madness ensues. Can you test this patch?

-- 
Jens Axboe


--------------000201000005030905020108
Content-Type: text/x-patch;
 name="bs-align-down.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bs-align-down.patch"

diff --git a/io_u.c b/io_u.c
index ba3f7ca00fcd..50644850463f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -485,7 +485,7 @@ static unsigned int __get_next_buflen(struct thread_data *td, struct io_u *io_u,
 				~(td->o.verify_interval - 1);
 
 		if (!td->o.bs_unaligned && is_power_of_2(minbs))
-			buflen = (buflen + minbs - 1) & ~(minbs - 1);
+			buflen &= ~(minbs - 1);
 
 	} while (!io_u_fits(td, io_u, buflen));
 

--------------000201000005030905020108--

