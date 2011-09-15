Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:48039
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1IOHY3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Sep 2011 03:24:29 -0400
Message-ID: <4E71A82C.5050507@kernel.dk>
Date: Thu, 15 Sep 2011 09:24:28 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: memory leak bug? when do write with verify
References: <CADson1wk9astwdroeAtPXb4A3+yrAcDcCXaEPvEGJPhM4TBfqQ@mail.gmail.com> <CADson1wi5=W-WDbDGy1j2T4FZD_2yoGGzOG8Af7GKKppiY7Lrg@mail.gmail.com> <4E70E6BB.6060708@kernel.dk> <CADson1y9VBx_gvHHafaQddA9NHjpwFwgtWZ854HHGE+EgfBvZw@mail.gmail.com>
In-Reply-To: <CADson1y9VBx_gvHHafaQddA9NHjpwFwgtWZ854HHGE+EgfBvZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhang Taile <zhangtl@gmail.com>
Cc: fio@vger.kernel.org

On 2011-09-15 04:49, Zhang Taile wrote:
> Hi ,
> Understand now.
> One more question, what backlog for?  Why read only with verify do not
> need it?

It's not strictly necessary for most cases. For random writes, we can
verify faster by doing it in disk order instead of in write order. If
you are using trim to discard parts of the ranges, then we need those
appropriately marked in memory.

But we can/could relax it a bit and save the memory. I don't think I've
had this complaint before, I guess people generally have plenty of RAM
these days :-)

-- 
Jens Axboe

