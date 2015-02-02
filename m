Return-Path: <fio-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:7620 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbBBAya (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 1 Feb 2015 19:54:30 -0500
Message-ID: <54CEC9F7.3050301@huawei.com>
Date: Mon, 2 Feb 2015 08:51:03 +0800
From: "majun (F)" <majun258@huawei.com>
MIME-Version: 1.0
Subject: Re: Help: FIO testing problem on arm64
References: <54C98E9A.5010500@huawei.com> <CAB6=LfOaY-STQyyB_nm4Eu8GCnhSRVcQGDu_h2o6J2at0qZd3w@mail.gmail.com>
In-Reply-To: <CAB6=LfOaY-STQyyB_nm4Eu8GCnhSRVcQGDu_h2o6J2at0qZd3w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Philip Keogh <pkeogh@compusoftcs.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Philip:
	Thanks for you replying.
Can you explain the case of  "may step on itself" more detail ?


在 2015/1/30 16:48, Philip Keogh 写道:
> On Wed, Jan 28, 2015 at 5:36 PM, majun (F) <majun258@huawei.com> wrote:
>> Hi All:
>>         I met a problem while testing the ramdisk peformance using fio.
>>         The platform is arm64 , fio version is 2.1.10.
>>
>>         The ramdisk is enabled on my platform , so there are dev/ram0 ...to dev/ram15 totall 16 ramdisk devices.
>>         I tried to test these ramdisks performance uisng the script file list as below.
>>
>> #!/bin/bash
>> ...
>>                                         fio --time_based ... --runtime=$runtime ... &
>>                                 done
>>                                 sleep $runtime
>>                         done
>> ...
>>         But the test result is not ok.
>>         The error log is:
>> ...
>>
> 
> Have you tried sleeping for slightly longer then the runtime passed to fio?
> 
> As a result of implementation details and the simple fact that sleep
> isn't exact, nor is fio's runtime, a script not allowing a sufficient
> buffer between backgrounded fio operations but intending to run
> operations sequentially may step on itself.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

