Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:43381 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1HDHED (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Aug 2011 03:04:03 -0400
Message-ID: <4E3A445E.9010901@fusionio.com>
Date: Thu, 4 Aug 2011 09:03:58 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: On I/O engines
References: <201108032213.36977.Martin@lichtvoll.de> <4E3A4008.9050105@fusionio.com> <CA+e7fc_Lfm=Zhp52sAWWLf7g4h6K_fW9w66inSqpx-n9ajh__g@mail.gmail.com>
In-Reply-To: <CA+e7fc_Lfm=Zhp52sAWWLf7g4h6K_fW9w66inSqpx-n9ajh__g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: DongJin Lee <dongjin.lee@auckland.ac.nz>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-08-04 08:58, DongJin Lee wrote:
> just adding 2c question:
> 
>> On Thu, Aug 4, 2011 at 18:45, Jens Axboe <jaxboe@fusionio.com> wrote:
>> That does not mean it's stable, it could just be
>> sitting in the drive write back cache.
> 
> right, example with a simple hdd 2tb with some 64mb cache, so indeed,
> there's no real way to confirm that the data has been physically
> written to the mechanical platter;

Usually any type of device that has a write back caching scheme also
supports a command to sync/flush that cache. This is what the kernel
does when you use one of the fsync() variants.

> but as I understand when shutting down the system, all are physically
> written to the platter; so I wonder what command the os issues to the
> disk then? maybe just unmount do so?

The devices are stopped at some point, that should ensure that the
caches are stable.


-- 
Jens Axboe

