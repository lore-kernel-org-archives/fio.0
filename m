Return-Path: <axboe@kernel.dk>
Message-ID: <548F40A8.3010405@kernel.dk>
Date: Mon, 15 Dec 2014 13:12:24 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio main thread got stuck over the weekend
References: <20140811154423.GE7486@beardog.cce.hp.com> <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk> <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net> <548BC55F.9020706@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net> <548F1C65.2070501@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/15/2014 12:39 PM, Elliott, Robert (Server Storage) wrote:
> 
> 
>> it's just 18.9 minutes. Total runtime is summed after the fact. The one
>> I think is interesting is the first thread, that is the one that should
>> be printing eta stats. And it seems to be stuck:
>>
>>  >    212 Thread 0x7fa9a086e700 (LWP 6509)  0x0000003974c0b98e in
>> pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
>>
>> can you do a bt on that? This looks like it _might_ be an issue that was
>> fixed recently with stats. Are you running fio with any output or status
>> options?
>>
> 
> No output options.

OK

> (gdb) thread 212
> [Switching to thread 212 (Thread 0x7fa9a086e700 (LWP 6509))]#0  0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
> (gdb) bt
> #0  0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
> #1  0x0000000000449381 in helper_thread_main (data=<value optimized out>) at backend.c:2127
> #2  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
> #3  0x00000039748e8b7d in clone () from /lib64/libc.so.6
> (gdb) select-frame 1
> (gdb) info local
> ts = {tv_sec = 1418658662, tv_nsec = 980074000}
> tv = {tv_sec = 1418658662, tv_usec = 730074}
> ret = <value optimized out>
> (gdb) print helper_exit
> $36 = 0
> (gdb) print nr_thread
> $37 = 224
> (gdb) print nr_process
> $38 = 0

This is the helper thread, this is what will output the ETA etc stats.
There's a signal handler that runs and sets/wakes it to do so. So it
would be interesting if you could see what it is up to, set a break
point in there and check what the control flow ends up being.

It's backend.c:helper_thread_main()

backend.c:sig_show_status() should repeatedly fire and end up waking
this thread.

> 
> (gdb) thread 1
> [Switching to thread 1 (Thread 0x7fa9a99b1720 (LWP 6508))]#0  0x00000039748acced in nanosleep () from /lib64/libc.so.6
> (gdb) bt
> #0  0x00000039748acced in nanosleep () from /lib64/libc.so.6
> #1  0x00000039748e1e64 in usleep () from /lib64/libc.so.6
> #2  0x000000000044d019 in do_usleep () at backend.c:1841
> #3  run_threads () at backend.c:2083
> #4  0x000000000044d8ab in fio_backend () at backend.c:2199
> #5  0x000000397481ed1d in __libc_start_main () from /lib64/libc.so.6
> #6  0x000000000040a199 in _start ()
>  (gdb) select-frame 3
>  (gdb) info local
> td = <value optimized out>
> i = <value optimized out>
> todo = <value optimized out>
> nr_running = 210
> m_rate = 0
> t_rate = 0
> nr_started = <value optimized out>
> spent = <value optimized out>
> (gdb) print thread_number
> $39 = 224
> 
> so run_threads() is probably in this loop waiting for 210 threads to quit:
>         while (nr_running) {
>                 reap_threads(&nr_running, &t_rate, &m_rate);
>                 do_usleep(10000);
>         }

Yes, which is expected. Once all jobs have been started, it'll
continually sit in that loop and wait for them to finish.

> 
> Given:
> 
> (gdb) thread 2
> [Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
> (gdb) print td->error
> No symbol "td" in current context.
> (gdb) bt
> #0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
> #1  0x0000000000457058 in fio_libaio_commit (td=0x7fa9a0dd1860) at engines/libaio.c:255
> #2  0x000000000040b395 in td_io_commit (td=0x7fa9a0dd1860) at ioengines.c:396
> #3  0x000000000040bea1 in td_io_queue (td=0x7fa9a0dd1860, io_u=0x7fa8e4015400) at ioengines.c:343
> #4  0x000000000044a75d in do_io (td=0x7fa9a0dd1860) at backend.c:792
> #5  0x000000000044c209 in thread_main (data=0x7fa9a0dd1860) at backend.c:1504
> #6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
> #7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
> (gdb) select-frame 5
> (gdb) print td->error
> $40 = 0
> (gdb) print td->terminate
> $41 = 0
> (gdb) print td->done
> $42 = 0
> (gdb) print td->o.time_based
> $43 = 1
> (gdb) print o->create_only
> $47 = 0

It's still actively running, correct? Not stuck in io_submit()?

> I guess the threads are not leaving this loop in thread_main(): 
>         while (keep_running(td)) {
>         ...
>         }
> 
> static int keep_running(struct thread_data *td)
> {
>         unsigned long long limit;
> 
>         if (td->done)
>                 return 0;
>         if (td->o.time_based)
>                 return 1;
> ...
> 
> After the runtime has elapsed, should td->done or td->terminate
> get set?

Nope, when the runtime is exceeded, the thread will notice by calling
runtime_exceeded() in do_io(). ->terminate is set if you do ctrl-c for
instance.

Are you seeing evidence that it's running for longer than it should?
From your job file:

> runtime=216000
> time_based=1

it should run for 2.5 days, then exit.

-- 
Jens Axboe


