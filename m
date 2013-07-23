Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43544 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab3GWPQE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Jul 2013 11:16:04 -0400
Message-ID: <51EE9E1C.3040708@kernel.dk>
Date: Tue, 23 Jul 2013 09:15:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segmentation fault on power system
References: <20130723101359.GC2152@localhost.localdomain> <51EE5997.6070804@enovance.com>
In-Reply-To: <51EE5997.6070804@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: Han Pingtian <hanpt@linux.vnet.ibm.com>, fio@vger.kernel.org

On 07/23/2013 04:23 AM, Erwan Velu wrote:
> On 23/07/2013 12:13, Han Pingtian wrote:
>> Hey there,
>>
>> When trying to run fio on one of our power system, segmentation fault
>>
> Can you give us the kind of cpu you are using ? (/proc/cpuinfo)
> I'm not used with PPC but maybe your processor doesn't support ATBU call
> on mfspr.

That is definitely the problem, so CPU info would help. In the mean
time, you can use clocksource=clock_gettime to get rid of the illegal
instruction.

-- 
Jens Axboe

