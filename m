Return-Path: <richard@rsk.demon.co.uk>
Subject: Re: unexpected results from simple test?
From: Richard Kennedy <richard@rsk.demon.co.uk>
In-Reply-To: <20090622175728.GK31415@kernel.dk>
References: <1245667272.2704.41.camel@localhost.localdomain>
	 <20090622105104.GC31415@kernel.dk>
	 <1245680446.2704.61.camel@localhost.localdomain>
	 <20090622175728.GK31415@kernel.dk>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 11:02:10 +0100
Message-Id: <1245751330.2715.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, 2009-06-22 at 19:57 +0200, Jens Axboe wrote:
> On Mon, Jun 22 2009, Richard Kennedy wrote:
> > 
> > > In any case, please try and download a new fresh version and see if that
> > > makes it any better.
> > > 
> > > There was also a recent linux kernel futex problem that fio triggered,
> > > so it could also be a kernel issue. Again, knowing what the two other
> > > jobs are doing would help.
> > > 
> > Hi Jens,
> > 
> > 'strace -f' running on a freshly built fio 1.28
> > 
> > It runs somewhat slowly but I just get lots of reads & writes like these
> > 
> > [pid  6597] gettimeofday({1245679454, 899777}, NULL) = 0
> > [pid  6597] lseek(8, 419278848, SEEK_SET) = 419278848
> > [pid  6597] gettimeofday({1245679454, 899917}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 899988}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 900059}, NULL) = 0
> > [pid  6597] write(8, "+\265bB\305\243g+\214\313\313\377\20H\237\356\266
> > \326X\335<\37\317K\207\317,/\335J\206\267\33"..., 4096) = 4096
> > [pid  6597] gettimeofday({1245679454, 900244}, NULL) = 0
> > [pid  6597] lseek(8, 419282944, SEEK_SET) = 419282944
> > [pid  6597] gettimeofday({1245679454, 900391}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 900463}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 900534}, NULL) = 0
> > [pid  6597] read(8, "+\265bB\305\243g+\214\313\313\377\20H\237\356\266
> > \326X\335<\37\317K\207\317,/\335J\206\267\33"..., 4096) = 4096
> > [pid  6597] gettimeofday({1245679454, 900705}, NULL) = 0
> > [pid  6597] lseek(8, 419287040, SEEK_SET) = 419287040
> > [pid  6597] gettimeofday({1245679454, 900845}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 900914}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 900985}, NULL) = 0
> > [pid  6597] write(8, "+\265bB\305\243g+\214\313\313\377\20H\237\356\266
> > \326X\335<\37\317K\207\317,/\335J\206\267\33"..., 4096) = 4096
> > [pid  6597] gettimeofday({1245679454, 901171}, NULL) = 0
> > [pid  6597] lseek(8, 419291136, SEEK_SET) = 419291136
> > [pid  6597] gettimeofday({1245679454, 901309}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 901379}, NULL) = 0
> > [pid  6597] gettimeofday({1245679454, 901460}, NULL) = 0
> > [pid  6597] read(8, "+\265bB\305\243g+\214\313\313\377\20H\237\356\266
> > \326X\335<\37\317K\207\317,/\335J\206\267\33"..., 4096) = 4096
> > 
> > 
> > where pid 6597 is job f1
> > 
> > I'll rebuild my kernel from the latest git, and check that.
> 
> So it's still running, perhaps the eta is just off. Is write back
> caching disabled on that drive?
> 

It seems better on the latest git kernel, the time for the complete test
is now 1m30.
Although the eta times do seem strange. As fio starts up I see extremely
large eta's flash up , i.e. some huge number of days, but I haven't
managed to capture one yet, and it says it's finished long before it
actually stops.

Yes, strangely the write_cache is disabled on sda, but enabled on sdb.

I'll turn it on and see if there's any difference.

regards
Richard
  



