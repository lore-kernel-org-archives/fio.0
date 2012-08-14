Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2HNNG7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 09:06:59 -0400
Message-ID: <502A4D53.7080801@kernel.dk>
Date: Tue, 14 Aug 2012 15:06:27 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: "Invalidate" not functional on Windows?
References: <CAHaS=QzLW_CcDATeZnWXPEiVEGRJr9UHdohyJo53M4pp+hh27g@mail.gmail.com> <CAHaS=Qw-2ZvfvhyAHUN_y9HADFihuB=h5g=JmV9_wa27S=1Lag@mail.gmail.com>
In-Reply-To: <CAHaS=Qw-2ZvfvhyAHUN_y9HADFihuB=h5g=JmV9_wa27S=1Lag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Sullivan <greg.sullivan@sullivang.net>
Cc: fio@vger.kernel.org, Bruce Cran <BCran@fusionio.com>

On 08/14/2012 06:57 AM, Greg Sullivan wrote:
> I need to perform reads without using any caching. I have the line
> "invalidate=1" in my job file, however it is still using the cache.  I
> am running Windows 7 32-bit. Is the "invalidate" command supposed to
> be functional on Windows? If so, what am I doing wrong?
> 
> That aside, what a great utility this is - thankyou!!

As far as what I remember from talking/mailing with Bruce (CC'ed),
there's no way to invalidate the cache in Windows.

-- 
Jens Axboe

