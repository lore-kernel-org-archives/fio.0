Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38866 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZKSUOM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Nov 2009 15:14:12 -0500
Date: Thu, 19 Nov 2009 21:14:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fio on solaris
Message-ID: <20091119201417.GJ8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tom <4711@gnurz.de>
Cc: fio@vger.kernel.org

On Thu, Nov 19 2009, Tom wrote:
> Hello!
> 
> I've a problem to make that fio for solaris:
> 
> > gmake -f Makefile.solaris
> gcc -o gettime.o -c -Wall -O2 -g -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=64 -DFIO_INC_DEBUG gettime.c
> In file included from gettime.c:11:
> hash.h:27:2: #error Define GOLDEN_RATIO_PRIME for your wordsize.
> In file included from gettime.c:11:
> hash.h: In function `hash_long':
> hash.h:51: error: `GOLDEN_RATIO_PRIME' undeclared (first use in this
> function)
> hash.h:51: error: (Each undeclared identifier is reported only once
> hash.h:51: error: for each function it appears in.)
> hash.h:55: error: `__WORDSIZE' undeclared (first use in this function)
> gmake: *** [gettime.o] Error 1
> 
> I've no idea what that means, any help?

Probably my define shuffling, I'll check and fix that up.

-- 
Jens Axboe

