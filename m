Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61251 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbbADCt0 (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 3 Jan 2015 21:49:26 -0500
Message-ID: <54A8AA06.6090407@fb.com>
Date: Sat, 3 Jan 2015 19:48:38 -0700
From: Jens Axboe <axboe@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] axmap: fix deadlock
References: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>	<54A830E7.5080509@fb.com>	<CA+icZUWcafgFE27NbYPhKtjJ6Vqk_o4nmxKHhgXj7q3vNBvw7w@mail.gmail.com>	<54A84D4E.5060404@fb.com> <CA+icZUUbZwtMz9-bwwEEicO-335Q9rBHFpRaQ24OotGeR+8n7g@mail.gmail.com>
In-Reply-To: <CA+icZUUbZwtMz9-bwwEEicO-335Q9rBHFpRaQ24OotGeR+8n7g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: sedat.dilek@gmail.com
Cc: Ming Lei <ming.lei@canonical.com>, fio@vger.kernel.org

On 01/03/2015 04:51 PM, Sedat Dilek wrote:
> On Sat, Jan 3, 2015 at 9:13 PM, Jens Axboe <axboe@fb.com> wrote:
>> On 01/03/2015 12:39 PM, Sedat Dilek wrote:
>>>
>>> On Sat, Jan 3, 2015 at 7:11 PM, Jens Axboe <axboe@fb.com> wrote:
>>>>
>>>> On 01/03/2015 07:21 AM, Ming Lei wrote:
>>>>>
>>>>> axmap_first_free() is always called with axmap->lock held,
>>>>> so needn't to acquire the lock inside the function.
>>>>>
>>>>> The deadlock is introduced in commit 12bde3697fc230d7a(axmap:
>>>>> ensure we lock down the maps for shared access).
>>>>>
>>>>> Given axmap_first_free() is only called inside lib/axmap.c,
>>>>> this patch declares the function as static. In the future,
>>>>> if external users need the function, axmap lock can be
>>>>> considered at that time.
>>>>
>>>>
>>>> Thanks Ming, applied.
>>>>
>>>
>>> Do you use the "Fixes:" tag in fio development [1]?
>>>
>>> Fixes: 12bde3697fc2 ("axmap: ensure we lock down the maps for shared
>>> access")
>>
>>
>> I sometimes mention the commit that it fixes, if I remember I do. It's
>> usually done like Ming did it in his commit:
>>
>>      The deadlock is introduced in commit 12bde3697fc230d7a(axmap:
>>      ensure we lock down the maps for shared access).
>>
>> and not as a specific Fixes: like we use on the linux kernel side. It makes
>> more sense to do for the kernel since we maintain stable branches, so you
>> can have tools figure out how far back to backport certain fixes. Fio
>> doesn't maintain stable branches off releases, so it's less relevant there.
>> I just people to use the latest release, and/or tip.
>>
>
> Thanks, it's  helpful to mention the culprit commit, personally I like
> the idea of the Fixes-tag.

Not disagreeing, I like them too. Just saying there's little reason to 
do it in fio, as we don't have specific stable branches. But there is 
something to be said for having it in a consistent format.

> You have reverted recent changes to axmap in fio.git.
> Do you plan a new fio v2.2.4 release as v2.2.3 has this serious "hanging" issue?

Yup, in fact I did that just now.

-- 
Jens Axboe

