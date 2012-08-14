Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2HNNGL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 09:06:11 -0400
Message-ID: <502A4D22.3090200@kernel.dk>
Date: Tue, 14 Aug 2012 15:05:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: How to do strict synchronous i/o on Windows?
References: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
In-Reply-To: <CAHaS=Qz8_g=0RqV53G_PuSM7Apvbbn3ksuF5MvkFUo7vme40Fw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org

On 08/14/2012 08:24 AM, Greg Sullivan wrote:
> I need to simulate strict synchronous, round robin i/o to a group of
> files. I am on Windows 7 32-bit.
> fio is very nearly working, except that even with a queue depth of 1,
> it is still resulting in a disk queue that is > 1, because the
> "iodepth" parameter is not global - it is per thread. (correct?)
> 
> I've tried using the "sync" engine, however that doesn't work at all -
> just spews out errors.

That'll be the case for ANY platform and IO engine. If you have more
than 1 thread or process going, you can have > 1 depth at the device
side. The definition of a sync IO call is that the call doesn't return
until the IO is done. If you have overlapped calls due to more than 1
thread, then that is no longer true.

What you are looking for is outside the scope of an application. You
would have to limit the queue depth on the operating system side to
achieve that. Or artificially limit fio in some way, which would not
make a lot of sense imho.

-- 
Jens Axboe

