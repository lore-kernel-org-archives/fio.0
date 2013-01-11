Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48939 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab3AKG4A (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Jan 2013 01:56:00 -0500
Message-ID: <50EFB77D.7090102@fusionio.com>
Date: Fri, 11 Jan 2013 07:55:57 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Add a check avoid segfault.
References: <201301101936131638895@gmail.com>,  <50EEB1B0.9050007@fusionio.com> <201301110839272022792@gmail.com>
In-Reply-To: <201301110839272022792@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 2013-01-11 01:39, majianpeng wrote:
> 
>> On 2013-01-10 12:36, majianpeng wrote:
>>> If new_size was zero or realloc failed, it would be segment fault.
>>> So add a check.
>>
>> It's a drop in the bucket, fio basically does not alloc failure
>> checking. It'd be nice to improve on that, but you'd need a lot more
>> than the below to get near fixing that.
>>
>> -- 
>> Jens Axboe
>>
> yes, why did i sent this patch?Because i set nrfiles=-1,fio would be segfault.
> I viewed the code about judging nrfiles, the code did not check this condition.
> Anthor case can cause this bug if nrfiles=0xffffffff.
> 
> There are many parameters like nrfiles.So they should do same check.
> Maybe add those check is better rather than check alloc fail or success?

OK, you should have mentioned that. Segfaults that are easily caused by
invalid parameters being specified should of course be fixed.

-- 
Jens Axboe

