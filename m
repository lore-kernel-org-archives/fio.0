Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57886 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0F3Hoc (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Jun 2010 03:44:32 -0400
Message-ID: <4C2AF5DF.8050705@fusionio.com>
Date: Wed, 30 Jun 2010 09:44:31 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Have we changed number of fields in fio --minimal output
References: <20100629193247.GA3819@redhat.com> <4C2AF2EC.1090806@fusionio.com> <4C2AF382.7000708@fusionio.com>
In-Reply-To: <4C2AF382.7000708@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fio@vger.kernel.org

On 2010-06-30 09:34, Jens Axboe wrote:
> On 2010-06-30 09:31, Jens Axboe wrote:
>> On 2010-06-29 21:32, Vivek Goyal wrote:
>>> Hi,
>>> 
>>> I was running latest fio and noticed that number of fields in fio
>>> --minimal output have gone up from 69 to 77. A increase of 8 
>>> fields. Don't see any update in --minimal documentation. Is it 
>>> regarding total latency thing?
>> 
>> Woops yes, there's a total latency in there as well now. Should 
>> just be 4 extra fields, though. It gets logged after completion 
>> latency, but before bandwidth stats. I'll update the 
>> documentation.
>> 
>> Should we perhaps put a versioning field in there? Now would seem 
>> to be a good time, since the output has changed anyway. I'm open to
>> suggestions from you or other terse output users.
> 
> How about redesigning it a bit to make it more bullet proof... We 
> could prefix series of fields with the value they are logging. So
> for instance, the 4 completion latency fields would include a clat
> prefix first:
> 
> clat[%lu;%lu;%f;%f],foo[%lu;%lu],etc
> 
> Would that not be more resilient to future changes? New fields would 
> not bother you, and reordering should also be fine.
> 
> Any other ideas?

With that change, the output would be modified from:

file;0;0;131072;356015;377;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;131072;303660;442;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;99.265606%;0.367197%;95;0;343;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%

to

id[file;0;0];overview[131072;357913;375];slat[0;0;0.000000;0.000000];clat[0;0;0.000000;0.000000];lat[0;0;0.000000;0.000000];bw[0;0;0.000000%;0.000000;0.000000];overview[131072;304348;441];slat[0;0;0.000000;0.000000];clat[0;0;0.000000;0.000000];lat[0;0;0.000000;0.000000];bw[0;0;0.000000%;0.000000;0.000000];sys[99.754601%;0.000000%;116;0;342];iodepth[100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%];iolat[0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%];

The upside is that it should be easier to parse, and it's even humanly
readable to a much greater extent than the current format. But let me
know what you think.

-- 
Jens Axboe

