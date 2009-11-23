Return-Path: <fio-owner@vger.kernel.org>
Received: from vbox10706.hkn.net ([213.9.107.6]:59324 "EHLO vbox10706.hkn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbZKWMNF (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 Nov 2009 07:13:05 -0500
Message-ID: <25005.194.113.141.20.1258978389.squirrel@webmail.s-itc.de>
In-Reply-To: <20091123120318.GW8742@kernel.dk>
References: <58349.194.113.141.20.1258623572.squirrel@webmail.s-itc.de>
    <20091119201417.GJ8742@kernel.dk> <20091123120318.GW8742@kernel.dk>
Date: Mon, 23 Nov 2009 13:13:09 +0100 (CET)
Subject: Re: Fio on solaris
From: "Tom" <4711@gnurz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tom <4711@gnurz.de>, fio@vger.kernel.org

Hi Jens,
thanks for that fast answer and job.
Where will I find the new Version, I checked http://brick.kernel.dk/snaps
but the latest file is
"fio-git-20091113222504.tar.gz        13-Nov-2009"

Thanks
Tom

> On Thu, Nov 19 2009, Jens Axboe wrote:
>> On Thu, Nov 19 2009, Tom wrote:
>> > Hello!
>> >
>> > I've a problem to make that fio for solaris:
>> >
>> > > gmake -f Makefile.solaris
>> > gcc -o gettime.o -c -Wall -O2 -g -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>> > -D_FILE_OFFSET_BITS=64 -DFIO_INC_DEBUG gettime.c
>> > In file included from gettime.c:11:
>> > hash.h:27:2: #error Define GOLDEN_RATIO_PRIME for your wordsize.
>> > In file included from gettime.c:11:
>> > hash.h: In function `hash_long':
>> > hash.h:51: error: `GOLDEN_RATIO_PRIME' undeclared (first use in this
>> > function)
>> > hash.h:51: error: (Each undeclared identifier is reported only once
>> > hash.h:51: error: for each function it appears in.)
>> > hash.h:55: error: `__WORDSIZE' undeclared (first use in this function)
>> > gmake: *** [gettime.o] Error 1
>> >
>> > I've no idea what that means, any help?
>>
>> Probably my define shuffling, I'll check and fix that up.
>
> Re-pull (or download latest snapshot), it's fixed. I just did a check
> compile on Solaris.
>
> --
> Jens Axboe
>
>




