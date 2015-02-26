Return-Path: <axboe@kernel.dk>
Message-ID: <54EFA0C5.5030401@kernel.dk>
Date: Thu, 26 Feb 2015 15:40:05 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Plain "./fio" segfaults on FreeBSD
References: <54EE51B4.8050606@cran.org.uk> <54EF9EF8.3030901@kernel.dk>
In-Reply-To: <54EF9EF8.3030901@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/26/2015 03:32 PM, Jens Axboe wrote:
> On 02/25/2015 03:50 PM, Bruce Cran wrote:
>> The latest code from git (built using clang) causes a segfault after
>> printing the usage text when "./fio" is run:
>>
>> [New LWP 100111]
>> No jobs(s) defined
>>
>> fio-2.2.5-28-g93eeb
>> [usage text]
>> [New Thread 801c06400 (LWP 100111/fio)]
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> [Switching to Thread 801c06400 (LWP 100111/fio)]
>> flist_empty (head=0x802000040) at flist.h:119
>> 119             return head->next == head;
>> Current language:  auto; currently minimal
>> (gdb) p head
>> $1 = (const struct flist_head *) 0x802000040
> 
> I can reproduce this, very strange... I'll debug it.

This should fix it:

http://git.kernel.dk/?p=fio.git;a=commit;h=3d0e3417997d9caa27cf97462e15ba437d285d29

-- 
Jens Axboe


