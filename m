Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2HNNKZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 09:10:25 -0400
Message-ID: <502A4E20.8020402@kernel.dk>
Date: Tue, 14 Aug 2012 15:09:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: raw device size used by fio
References: <CACiQ3FDXKEV0VVjrxaUH9U4CkXhHmVrz_d0eW6QyHKE2HHwacw@mail.gmail.com>
In-Reply-To: <CACiQ3FDXKEV0VVjrxaUH9U4CkXhHmVrz_d0eW6QyHKE2HHwacw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kyle Hailey <kyle.hailey@delphix.com>
Cc: fio@vger.kernel.org

On 08/08/2012 08:29 PM, Kyle Hailey wrote:
> I was running a number of tests with raw devices and no size set (but
> did use offsets).
> In the case where a raw device is specified  but no size, what
> happens? does fio have a way to figure out the size of the raw device?

Yes, fio will figure out the size. If it could not, then it'll complain
since it doesn't know how much IO to do.

> What is the usage of the size parameter when there are multiple raw devices.
> For example if I have multiple raw devices
> 
>       filename=/dev/rdsk/c4t3d0p0:/dev/rdsk/c4t4d0p0
> 
> and a set size
> 
>      size=8000m
> 
> will it treat the 8000m as the total size of the two devices or is the
> 8000m the size of each?

It'll do 8000m of IO in total.

> If it's the total, then I guess fio can't work with multiple raw
> devices of different sizes?

Sure, lets say the first is 2g and the second is 10g. You should end up
with 2g of IO done from the first one, the remainder from the last one.
At least with the default file service policy.

-- 
Jens Axboe

