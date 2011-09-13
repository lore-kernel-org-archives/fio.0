Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:54260
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1IMILH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 13 Sep 2011 04:11:07 -0400
Message-ID: <4E6F1019.4050106@kernel.dk>
Date: Tue, 13 Sep 2011 10:11:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: runtime option not working similar for all devices
References: <CAKa9NmvPyvyrdbpYaHoo20yu5Gbsq1m_GYzUen2viOUZkJdQHQ@mail.gmail.com> <4E6DC4C1.2050804@kernel.dk> <CAKa9Nmsi_QxSZyD14AH6wrNQ5sqGe_K2m4Efy7ZaHTu2ryGMtQ@mail.gmail.com> <CAKTuRrGKODdJ9dnsfPjK82-===RYr-Js1aM5U6rOC2823n3LYw@mail.gmail.com>
In-Reply-To: <CAKTuRrGKODdJ9dnsfPjK82-===RYr-Js1aM5U6rOC2823n3LYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Josh Aune <luken@omner.org>
Cc: Vikram Seth <seth.vik@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-09-13 10:04, Josh Aune wrote:
> 
>>
>> [global]
>> description=Standard Performance test
>> runtime=43200
>> direct=1
>> filename=/dev/sdc
>> numjobs=20
>> group_reporting
> 
> Add time_based and it will run for the full duration specified by runtime.

Yes. With the job given, once fio has done 128kb randreads to any block
on the total size of sdc, it will exit otherwise. If you only give
runtime=xx, then it's just a cap, it wont extend your runtime beyond the
size of the job.

-- 
Jens Axboe

