Return-Path: <axboe@kernel.dk>
Message-ID: <54EF9EF8.3030901@kernel.dk>
Date: Thu, 26 Feb 2015 15:32:24 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Plain "./fio" segfaults on FreeBSD
References: <54EE51B4.8050606@cran.org.uk>
In-Reply-To: <54EE51B4.8050606@cran.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/25/2015 03:50 PM, Bruce Cran wrote:
> The latest code from git (built using clang) causes a segfault after
> printing the usage text when "./fio" is run:
> 
> [New LWP 100111]
> No jobs(s) defined
> 
> fio-2.2.5-28-g93eeb
> [usage text]
> [New Thread 801c06400 (LWP 100111/fio)]
> 
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 801c06400 (LWP 100111/fio)]
> flist_empty (head=0x802000040) at flist.h:119
> 119             return head->next == head;
> Current language:  auto; currently minimal
> (gdb) p head
> $1 = (const struct flist_head *) 0x802000040

I can reproduce this, very strange... I'll debug it.

> Also, could we update -std=gnu99 to -std=c11 and use _Static_assert in
> compiler.h? Currently, turning optimizations off in the Makefile causes
> linker failures such as "fio/libfio.c:308: undefined reference to
> `__compiletime_assert_308'".

I think it'd be more bullet proof (considering other platforms) to just
not do the compile time asserts at all if optimizations aren't enabled.
I'd be happy to take a patch for that...

-- 
Jens Axboe


