Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:42827
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1IAURL (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Sep 2011 16:17:11 -0400
Message-ID: <4E5FE840.9040706@kernel.dk>
Date: Thu, 01 Sep 2011 14:17:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Linux I/O stack design question
References: <1314880418.11001.6.camel@werner-t410>  <x494o0w1h15.fsf@segfault.boston.devel.redhat.com> <1314908040.2091.14.camel@werner-t410>
In-Reply-To: <1314908040.2091.14.camel@werner-t410>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-09-01 14:14, Werner Fischer wrote:
>> 3) the fusion IO device driver can hook itself in where you put it, or
>>    also up above the I/O scheduler (based on a module load option).
> Oh wow, that sounds interesting. Does this mean that in this case (IO
> device driver above the I/O scheduler) simply no I/O scheduler is used?

It'll hook in similarly to where stacked devices like md/dm do. So yes,
it's bypassing the IO scheduler. One note on that - this mode is going
away in the future. You end up losing out on request merging, so write
performance is hampered, for one.

The Micron pci-e mtip32xx driver does similarly, as does the
nvmhci-express driver from Intel. IMHO it's largely due to
inefficiencies in the IO stack, once we get those fixed, we should be
getting back to the one true single IO mode for a driver. I consider the
bypass setup a bit of a hack and work-around.

-- 
Jens Axboe

