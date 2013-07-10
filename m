Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48411 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3GJMlF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Jul 2013 08:41:05 -0400
Date: Wed, 10 Jul 2013 06:41:06 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC] packaging fio 2.1.1 for Debian: make clean does not remove
 all generated files
Message-ID: <20130710124106.GP2530@kernel.dk>
References: <201307081506.16476.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201307081506.16476.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On Mon, Jul 08 2013, Martin Steigerwald wrote:
> Hi Jens!
> 
> I am in the process of upgrading Debian packaging of fio to current version
> 2.1.1, but run into this error:
> 
> dpkg-source: info: using source format `3.0 (quilt)'
> dpkg-source: info: building fio using existing ./fio_2.1.1.orig.tar.gz
> dpkg-source: info: local changes detected, the modified files are:
>  fio/config.log
>  fio/crc/crc16.d
>  fio/crc/crc32.d
> […]
>  fio/engines/binject.d
>  fio/engines/cpu.d
> […]
>  fio/lib/axmap.d
>  fio/lib/flist_sort.d
> […]
>  fio/profiles/act.d
>  fio/profiles/tiobench.d
> dpkg-source: info: you can integrate the local changes with dpkg-source --commit
> dpkg-source: error: aborting due to unexpected upstream changes, see /tmp/fio_2.1.1-1.diff.eLtKfe
> dpkg-buildpackage: error: dpkg-source -b fio gave error exit status 2
> 
> 
> 
> I added the following patch to debian package which fixes it:
> 
> Description: Delete config log and .d-files on clean.
>   Makefile of fio 2.1.1 leaves them which prevents repeated builds
>   with dpkg-buildpackage due to:
>   dpkg-source: info: local changes detected, …
> Author: Martin Steigerwald <ms@teamix.de>
> 
> ---
> --- a/Makefile
> +++ b/Makefile
> @@ -265,7 +265,7 @@
>         $(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS) $(LDFLAGS)
>  
>  clean: FORCE
> -       -rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d 
> config-host.mak config-host.h
> +       -rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d */*.d 
> config.log config-host.mak config-host.h
>  
>  distclean: clean FORCE
>         @rm -f cscope.out
> 
> 
> 
> 
> Any other suggestion? If thats good to go, maybe makes sense to apply
> upstream?

I think that makes sense, I'll add it upstream too.

-- 
Jens Axboe

