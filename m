Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48829 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544Ab3HHU4m (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Aug 2013 16:56:42 -0400
Message-ID: <520405D4.2060309@kernel.dk>
Date: Thu, 08 Aug 2013 14:55:48 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: no slat log
References: <520173F7.6000104@conversis.de> <52020EFA.6060208@enovance.com> <52022323.2030208@conversis.de>
In-Reply-To: <52022323.2030208@conversis.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dennis Jacobfeuerborn <dennisml@conversis.de>
Cc: Erwan Velu <erwan@enovance.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/07/2013 04:36 AM, Dennis Jacobfeuerborn wrote:
> On 07.08.2013 11:10, Erwan Velu wrote:
>> On 07/08/2013 00:08, Dennis Jacobfeuerborn wrote:
>>> Hi,
>>> when I try to create logs with fio I get bw, iops, lat, clat and slat
>>> logs but the slat log always has a size of 0 bytes. Is this a bug or
>>> is data for this log only generated with specific options for fio?
>>>
>> Dennis,
>>
>> I've been trying this on my 2.1.2 with the following job :
>>
>> [read-sda-4k-para]
>> bs=4k
>> filename=/dev/sda
>> rw=read
>> write_lat_log=lat.log
>>
>> On my side, the slat file is perfectly filled.
>>
>> Can you provide a testing procedure & the version you use ?
> 
> I just tested the job above and these are the files produced:
> 
> [dennis@nexus fio]$ ls -l
> total 11272
> -rw-r--r--. 1 root   root   5767080  7. Aug 12:31 lat.log_clat.log
> -rw-r--r--. 1 root   root   5767087  7. Aug 12:31 lat.log_lat.log
> -rw-r--r--. 1 root   root         0  7. Aug 12:31 lat.log_slat.log
> -rw-rw-r--. 1 dennis dennis      84  7. Aug 12:31 logtest.fio
> 
> There are not errors or warnings during the fio run so it's not clear
> why the file ends up being empty.

slat only exists for async IO engines. For a sync workload, submission
and completion retrieval are not separate events, so you cannot do split
submission + completion stats.

-- 
Jens Axboe

