Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0179.hostedemail.com ([216.40.44.179]:51797 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755501AbbEUO3z (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 21 May 2015 10:29:55 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 6B84B11B639
	for <fio@vger.kernel.org>; Thu, 21 May 2015 14:23:01 +0000 (UTC)
Message-ID: <555DEA42.8020209@nellans.org>
Date: Thu, 21 May 2015 09:22:58 -0500
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: Urgent problem while using Fio to test random write performance
References: <555D9487.3040104@cnnic.cn>
In-Reply-To: <555D9487.3040104@cnnic.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nan WANG <wangnan@cnnic.cn>, fio@vger.kernel.org

you're randwrite to a raw partition. if you had a filesystem on that 
partition you were trying to use, then well, your data is gone/corrupted.
without a filesystem on it, i'm not sure how you'd think that your disc 
usage has become "100%" without some xgui widgit warning you, so seems 
likely you did something you didn't mean to with regards to writing to 
/dev/sdb1 directly

if you use fio on devices/partitions with a filesystem, you need to have 
it write to files or it will trash your filesystem



On 05/21/2015 03:17 AM, Nan WANG wrote:
> hi all~
>     I wanted to use fio to test random write performance, the command 
> line is as forllowing:
>
>       fio --filename=/dev/sdb1 --direct=1 --iodepth 1 --thread 
> --rw=randwrite --ioengine=psync --bs=16k --size=200G --numjobs=10 
> --runtime=1000 --group_reporting --name=mytest
>
>     After the execution of fio finished, my disc usage become 100%, is 
> there any method to release the content written by Fio?
>
>  Thanks a lot in advance!!
>

