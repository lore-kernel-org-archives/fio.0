Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37620 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3HFQ0H (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 12:26:07 -0400
Message-ID: <52012370.8090803@kernel.dk>
Date: Tue, 06 Aug 2013 10:25:20 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: 2.1.2 released
References: <52011D0F.5060308@kernel.dk> <52012346.9040609@enovance.com>
In-Reply-To: <52012346.9040609@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/06/2013 10:24 AM, Erwan Velu wrote:
> On 06/08/2013 17:58, Jens Axboe wrote:
>> Hi Folks,
>>
>> I tagged the release of 2.1.2 this morning. The basic changes since
>> 2.1.1 are:
>>
>> - The big graphing rework from Erwan.
>> - A fix for a potential verification failure, courtesy of Josef Bacik.
>> - Support for randomness of reads and writes independently.
>> - Support for setting block sizes (or ranges) for random of sequential
>>    IO.
>> - Support for multicast network IO in the net ioengine, from Shawn
>>    Bohrer.
>> - RDMA io engine should now compile and work again, was broken with the
>>    recent rewrites. From Yufei Ren.
>>
>> 65 commits in total, of which I only did 8 of them. I believe that is a
>> new record! Thanks a lot for your contributions, keep them coming.
>>
> I'd like to add also the genfio tool which is very useful to describe
> complex and repetitive fio's jobs.

Indeed, I completely forgot about that one. Sorry about that.

> I'm also adding an url where people can see the kind of graphing
> fio2gnuplot does :
> http://www.flickr.com/photos/ennael/sets/72157634249027122/

Great, always a good thing to have samples to point people at.

-- 
Jens Axboe

