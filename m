Return-Path: <hanpt@linux.vnet.ibm.com>
Date: Fri, 9 Aug 2013 16:39:05 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Subject: Re: segmentation fault on power system
Message-ID: <20130809083905.GA9877@localhost.localdomain>
References: <20130723101359.GC2152@localhost.localdomain>
 <51EE5997.6070804@enovance.com>
 <51EE9E1C.3040708@kernel.dk>
 <20130724021019.GA2615@localhost.localdomain>
 <20130724062101.GB2615@localhost.localdomain>
 <51F13781.8000502@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F13781.8000502@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Jul 25, 2013 at 08:34:41AM -0600, Jens Axboe wrote:
> On 07/24/2013 12:21 AM, Han Pingtian wrote:
> > I think I have found what's wrong. After 'make distclean' then 'make',
> > the problem of segfault has gone. There were some object files 
> > compiled on another machine. The recompilation fixed it. But looks like
> > the ATBU call dosen't work on power7 system.
> 
> So the recompilation fixed the segfault, but not the illegal instruction
> due to ATBU?

Yes. If we set unlimit core dump, fio will generate a core with 
backtrace like this one:

#0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
55              asm volatile("mfspr %0,%1": "=r" (val) : "K" (reg));
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.107.el6.ppc64 libaio-0.3.107-10.el6.ppc64
(gdb) bt
#0  mfspr (envp=<value optimized out>) at arch/arch-ppc.h:55
#1  get_cpu_clock (envp=<value optimized out>) at arch/arch-ppc.h:71
#2  atb_child (envp=<value optimized out>) at arch/arch-ppc.h:88
#3  atb_clocktest (envp=<value optimized out>) at arch/arch-ppc.h:98
#4  arch_init (envp=<value optimized out>) at arch/arch-ppc.h:116
#5  initialize_fio (envp=<value optimized out>) at libfio.c:248
#6  0x0000000010067294 in main (argc=<value optimized out>, argv=<value optimized out>,
    envp=<value optimized out>) at fio.c:33


Apologize for late to reply.


