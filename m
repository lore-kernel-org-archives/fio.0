Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55002 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZKWQY2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 Nov 2009 11:24:28 -0500
Date: Mon, 23 Nov 2009 17:24:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Fio on solaris
Message-ID: <20091123162433.GI8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de> <20091119201417.GJ8742@kernel.dk> <20091123120318.GW8742@kernel.dk> <25005.194.113.141.20.1258978389.squirrel@webmail.s-itc.de> <20091123121420.GX8742@kernel.dk> <13958.194.113.141.20.1258980688.squirrel@webmail.s-itc.de> <20091123125912.GZ8742@kernel.dk> <44735.194.113.141.20.1258982494.squirrel@webmail.s-itc.de> <20091123141923.GF8742@kernel.dk> <53558.194.113.141.20.1258991444.squirrel@webmail.s-itc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53558.194.113.141.20.1258991444.squirrel@webmail.s-itc.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tom <4711@gnurz.de>
Cc: fio@vger.kernel.org

On Mon, Nov 23 2009, Tom wrote:
> Thanks Jens!
> now it's possible to compile that, but (yes, we've a "but"), when I call:
> 
> > fio four_threads.fio
> fio: engine libaio not loadable
> fio: failed to load engine libaio
> fio: file:ioengines.c:98, func=dlopen, error=ld.so.1: fio: fatal: libaio:
> open failed: No such file or directory
> 
> I search for that libaio and found it
> 
> > ll    /usr/lib/libaio.so*
> lrwxrwxrwx   1 root     root          21 Sep  4 10:28 /usr/lib/libaio.so
> -> ../../lib/libaio.so.1
> lrwxrwxrwx   1 root     root          21 Sep  4 10:28 /usr/lib/libaio.so.1
> -> ../../lib/libaio.so.1
> 
> > ll /lib/libaio.so*
> lrwxrwxrwx   1 root     root          11 Sep  4 10:34 /lib/libaio.so ->
> libaio.so.1
> -rwxr-xr-x   1 root     bin        46452 Feb 12  2009 /lib/libaio.so.1
> 
> but that on isn't the right one?
> 
> What kind of libaio have you installed at your SUN where ist it from? We
> have looked around. For Linux we found tonns of libaio and libaio-devel,
> but nothing for SUN.

The libaio engine is Linux specific. On Solaris, the available async
engines are posixaio and the native solarisaio.

-- 
Jens Axboe

