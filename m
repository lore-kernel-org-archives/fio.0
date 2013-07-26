Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab3GZOe1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Jul 2013 10:34:27 -0400
Message-ID: <51F288DC.8000503@kernel.dk>
Date: Fri, 26 Jul 2013 08:34:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Helping to model this workload
References: <CE17FF2B.12F28%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CE17FF2B.12F28%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/26/2013 08:28 AM, Neto, Antonio Jose Rodrigues wrote:
> 
> On 7/26/13 10:24 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
> 
>> On 07/26/2013 08:22 AM, Neto, Antonio Jose Rodrigues wrote:
>>> Would be nice if we could specify?
>>> Iodepth for sequential and random
>>
>> That would be easy enough to add.
>>
>>> Numjobs for sequential and random (for example: I would like to have 16
>>> jobs doing random and 1 job only doing sequential)
>>
>> That's pretty easy to do manually by just having the two sections in the
>> job file.
>>
>> -- 
>> Jens Axboe
>>
>> --
> 
> Something like this? Do you have an example? I am confused with 2 sections
> and the percentage of the distribution of sequential and random plus the
> difference of block size

For multiple sections, you put the shared items in a [global] section.
That section applies to any job in the file. That also gives you a
better overview of the shared and distinct properties of each job.

-- 
Jens Axboe

