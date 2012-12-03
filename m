Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2LCScK (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Dec 2012 13:32:10 -0500
Message-ID: <50BCF027.5080503@kernel.dk>
Date: Mon, 03 Dec 2012 19:32:07 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Getting 'stat64 already defined' type errors when trying to "make"
 fio on RedHat/Centos 6.3 (linux kernel 2.6.18-308)
References: <50B8FFFC.7000602@benslade.com> <50B90653.2030808@kernel.dk> <50BBA9F2.4050607@kernel.dk> <50BCD836.2040507@benslade.com>
In-Reply-To: <50BCD836.2040507@benslade.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: buysell08 <buysell08@benslade.com>
Cc: fio@vger.kernel.org

On 2012-12-03 17:49, buysell08 wrote:
> Re: you write centos 6.3, but it's running kernel 2.6.18. That can't be right
> 
> Indeed, it is not right.  I meant to say Centos 6.3, kernel version
> 2.6.32.   Apologies.

Did you change the compiler, too? gcc 4.4.2 isn't centos 6.3 stock
either.

> Re: Try adding a <sys/stat.h> include to fio.h
> 
> No joy.  Same compilation error
> 
> But.....    I found the web pages:
> 
>    http://mailman.videolan.org/pipermail/x264-devel/2011-June/008563.html
> 
>    http://lifecs.likai.org/2009/06/multiple-definition-of-extern-inline.html
> 
> which says to add the compiler flag "-fgnu89-inline" (because of an issue where old glibc libraries aren't compatible with "the c99 standard").   I added the compilation flag
> (adding it just after the "-std=gnu99" option) and the compilation errors went away.

I found that that one, too. So you should be able to make it work by
just doing:

$ EXTFLAG="-std=gnu99" make

and not have to edit anything. Not sure I can do too much about this, if
it's a largely non-standard setup. It's a bug in your toolchain.

-- 
Jens Axboe

