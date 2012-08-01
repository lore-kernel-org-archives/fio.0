Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:38260 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2HAF1B convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 1 Aug 2012 01:27:01 -0400
Date: Wed, 1 Aug 2012 07:26:56 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <927703077.137143.1343798816636.JavaMail.root@thomas-krenn.com>
In-Reply-To: <5018286D.5070000@kernel.dk>
Subject: Re: Problem using --offset: fix call to fadvise64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Georg Schönberger" <gschoenberger@thomas-krenn.com>
> Cc: fio@vger.kernel.org
> Sent: Tuesday, 31 July, 2012 8:48:13 PM
> Subject: Re: Problem using --offset: fix call to fadvise64
> 
> On 2012-07-20 12:30, Georg Schönberger wrote:
> > I have now figured out the problem: when testing with a whole
> > partition "/dev/sdb1" and specifying an offset you have also to
> > specify a size via "--size". I thought that if I am using an offset
> > with a partition Fio would carry out the test starting at the
> > offset
> > until the end of the partition. But this is not the case, you have
> > to
> > explicitly give the rest of partition's size starting from the
> > offset.
> > This was my fault, Fio is doing everything correctly.
> 
> We could improve and have fio get the partition size in this case.
> The
> problem is that if it's a block device, it'll get the full size. A
> bit
> counter intuitive.
> 
> --
> Jens Axboe
> 
>

Maybe we could solve it by having "--size" as a mandatory argument if "--offset" is given.
In my opinion as a first solution that would be the easiest way.

-Georg



