Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:42987
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab1IAVNh (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Sep 2011 17:13:37 -0400
Message-ID: <4E5FF57A.1040908@kernel.dk>
Date: Thu, 01 Sep 2011 15:13:30 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Linux I/O stack design question
References: <1314880418.11001.6.camel@werner-t410>  <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>  <1314908040.2091.14.camel@werner-t410>  <4E5FE840.9040706@kernel.dk> <1314908867.2091.23.camel@werner-t410>
In-Reply-To: <1314908867.2091.23.camel@werner-t410>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-09-01 14:27, Werner Fischer wrote:
>> One note on that - this mode is going
>> away in the future. 
> Do you mean that this mode is going away in the future for the Fusion-io
> driver or that generally no driver will be able to hook in there (also
> the mtip32xx and nvmhci-express drivers you mention below)?

For this particular case, I meant the fusion-io driver. Even for the
current 2.x series of the driver, bypassing the IO scheduler is not the
default. You have to manually specify that with a module option.

>> You end up losing out on request merging, so write
>> performance is hampered, for one.
>>
>> The Micron pci-e mtip32xx driver does similarly, as does the
>> nvmhci-express driver from Intel. IMHO it's largely due to
>> inefficiencies in the IO stack, once we get those fixed, we should be
>> getting back to the one true single IO mode for a driver.
> With "one true single IO mode for a driver" you mean that every device
> driver should sit and stay below the I/O scheduler?
> Or do you mean that there should only be one single I/O scheduler? (in
> the patch removing the anticipatory scheduler you suggested something
> like this:
> http://git.kernel.org/linus/492af6350a5ccf087e4964104a276ed358811458 )

I mean that every device should plug in at the same place. There are
definite up and down sides to plugging in at the stacking level and
bypassing the IO scheduler. So you have to weight the pros and cons
before doing that. We need to fix this. Drivers doing that lose out on
other features in the name of a bit more performance, that's just not
acceptable.

-- 
Jens Axboe

