Return-Path: <axboe@kernel.dk>
Subject: Re: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56840F80.4060903@kernel.dk>
 <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5684A8F1.6010105@kernel.dk>
Date: Wed, 30 Dec 2015 21:02:57 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/30/2015 11:34 AM, Thierry BERTAUD wrote:
> Hello Jens,
>
>> That's expected - when the main thread goes to sleep, it checks for this
>> status dump file. If it exists, then it'll show the current summary of
>> stats, then unlink it.
> Thanks for explain this point.
>
> Just to confirm my understanding the following option with engine 'posixaio'
> iodepth=128 and numjobs=128 =>
> I don't use 'thread' option so i think with iodpeth=128 the main fio process will fork to create 128 process.
> With numjob=128 that imply, i'll clone each forked process from fio (due to iodepth) that's imply 16384 process (128 * 128).
> If i use threads enabled, with iodepth=128 the main fio process will create with pthread_create 128 threads for itself.
> With numjobs=128, the ain fio process will clone to have  16384 threads into itselft  or it will fork to create  128 process and each process has 128 threads.
>
>> That's the main thread, what are the IO threads doing?
> If i follow disk I/O there are no activities.
> This kind of information for fio process can help or not to answer the questions?
> The list of thread by process this:
>     # ps -mo THREAD
>         USER      PID     PPID        TID ST  CP PRI SC    WCHAN        F     TT BND COMMAND
>         root  9437428 10551472          - A    0  60  1        -   200001  pts/0   - ksh
>            -        -        -   18350143 S    0  60  1        -    10400      -   - -
>       padmin 10551472 11534386          - A    0  60  1        -   240001  pts/0   - -rksh
>            -        -        -   49873143 S    0  60  1        -    10400      -   - -
>         root 11206870  9437428          - A    1  60  1        -   200001  pts/0   - bash
>            -        -        -   48759011 S    1  60  1        -   410400      -   - -
>         root 62914724 11206870          - A    6  63  1        -   200001  pts/0   - ps -mo THREAD
>            -        -        -  116850921 R    6  63  1        -   400000      -   - -
>     #
> Or thread for a given process like this:
>     # ps -mp 9437428 -o THREAD
>         USER      PID     PPID        TID ST  CP PRI SC    WCHAN        F     TT BND COMMAND
>         root  9437428 10551472          - A    0  60  1        -   200001  pts/0   - ksh
>            -        -        -   18350143 S    0  60  1        -    10400      -   - -
>     #
>
> I tried to use gdb against the live process but i don't how to progress with it?
> I can do gdb against the executable also but i don't know how to progress whit it?

Against the live process it the easiest. Just do gdb -p <pid> and 
attach. If you don't use threads from fio, then they will each be a 
separate process.

I'll be taking a bit of time off, but I should have access to an AIX 
that I can test on sometime next week. What version are you on?

-- 
Jens Axboe


