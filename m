Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:33318
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMj0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:26 -0400
Message-ID: <4E68B77D.10400@kernel.dk>
Date: Thu, 08 Sep 2011 14:39:25 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Linux I/O stack design question
References: <1314880418.11001.6.camel@werner-t410>  <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>  <1314908040.2091.14.camel@werner-t410>  <4E5FE840.9040706@kernel.dk>  <1314908867.2091.23.camel@werner-t410>  <4E5FF57A.1040908@kernel.dk> <1315231292.2140.62.camel@werner-t410>
In-Reply-To: <1315231292.2140.62.camel@werner-t410>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-09-05 16:01, Werner Fischer wrote:
> On Don, 2011-09-01 at 15:13 -0600, Jens Axboe wrote:
>> [...]
>> I mean that every device should plug in at the same place. There are
>> definite up and down sides to plugging in at the stacking level and
>> bypassing the IO scheduler. So you have to weight the pros and cons
>> before doing that. We need to fix this. Drivers doing that lose out on
>> other features in the name of a bit more performance, that's just not
>> acceptable.
> 
> I have updated the diagram according to all of your hints:
> http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png
> 
> I had also some off-list discussion with Florian Haas, who convinced me
> that the file systems are below of the page cache. I hope this is now
> correct.

Not sure I'd agree with that, I'd place the page cache between the fs
and the storage layer.

-- 
Jens Axboe

