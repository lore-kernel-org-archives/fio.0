Return-Path: <axboe@kernel.dk>
Message-ID: <549117EF.7030403@kernel.dk>
Date: Tue, 16 Dec 2014 22:43:11 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio main thread got stuck over the weekend
References: <20140811154423.GE7486@beardog.cce.hp.com> <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk> <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net> <548BC55F.9020706@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net> <548F1C65.2070501@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net> <548F40A8.3010405@kernel.dk> <548F452D.7040401@kernel.dk> <548F495F.7090200@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F830@G4W3202.americas.hpqcorp.net> <5490B574.3000502@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402959410CC6@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959410CC6@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/16/2014 08:52 PM, Elliott, Robert (Server Storage) wrote:
> (gdb) thread 2
> [Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
> (gdb) bt
> #0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
> #1  0x0000000000457058 in fio_libaio_commit (td=0x7fa9a0dd1860) at engines/libaio.c:255
> #2  0x000000000040b395 in td_io_commit (td=0x7fa9a0dd1860) at ioengines.c:396
> #3  0x000000000040bea1 in td_io_queue (td=0x7fa9a0dd1860, io_u=0x7fa8e401c980) at ioengines.c:343
> #4  0x000000000044a75d in do_io (td=0x7fa9a0dd1860) at backend.c:792
> #5  0x000000000044c209 in thread_main (data=0x7fa9a0dd1860) at backend.c:1504
> #6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
> #7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
> (gdb) print td
> No symbol "td" in current context.
> (gdb) select-frame 5
> (gdb) print td->tv_cache
> $51 = {tv_sec = 1099511, tv_usec = 641885}
                   ^^^^^^^

This is the key. If this multiplication overflows:

usecs = (t * inv_cycles_per_usec) / 16777216UL;

then usecs is 2^64/2^24, which is 1099511627776. Divide that by 10^6 to 
get seconds, and that is 1099511... I initially thought this was a buggy 
backwards timer, but it's just this overflow. Fix:

http://git.kernel.dk/?p=fio.git;a=commit;h=b3fa625b38a638cd1783e9fdcac1b958e37e48fa

-- 
Jens Axboe


