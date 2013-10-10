Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:46897 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756176Ab3JJUzo (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 10 Oct 2013 16:55:44 -0400
Message-ID: <52571453.4050101@nellans.org>
Date: Thu, 10 Oct 2013 15:55:47 -0500
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: IO scheduler
References: <CAAAK+WXw_-gAJL9u9Bibvz=4aHVH2YYvgQRi2sMvekY6xDRR4A@mail.gmail.com>
In-Reply-To: <CAAAK+WXw_-gAJL9u9Bibvz=4aHVH2YYvgQRi2sMvekY6xDRR4A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10/10/2013 12:08 PM, Brian L. wrote:
> Hi there,
>
> I was wondering if you guys use NOOP IO scheduler when you are running fio?
>
> I use the CFQ IO scheduler but I do put the OS into init 1 and run fio
> process one at a time so that I can get accurate readings.
>
> I was wondering what are people practice and experience in the real world.
>
> Thanks,
> Brian L.

Some flash device drivers specifically (Fusion-io does this) use the 
noop scheduler to reduce latency and variance that can be introduced 
when using other schedulers.  Using the no-op scheduler is a reasonable 
thing to do for all drives to make apples to apples, but if a driver 
specifically overrides it to something else, probably worth sticking 
with their settings.

init 1 is overkill.  In a previous life doing a lot of measuring of 
flash - I found that simply making sure the machine was "idle" you could 
get easily get repeatability within 1% for devices doing several hundred 
thousand IOPS, even those with on-load architectures that were sensitive 
to CPU usage.
