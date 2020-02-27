Return-Path: <sandeen@redhat.com>
Subject: Re: [PATCH] fio: remove duplicate global definition of tsc_reliable
References: <30587810-2ca6-2a7f-f89b-a4f820b28a11@redhat.com>
 <3d8e7a16-3fad-6cbf-ea04-78a0010d200d@redhat.com>
 <3cc8915e-b054-8045-e046-1873ff9d353e@redhat.com>
 <c350fe27-76ca-d068-9ac6-6b27f1c1878b@kernel.dk>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4aa5a893-f753-aaf7-d883-6f19042bfe59@redhat.com>
Date: Thu, 27 Feb 2020 09:20:26 -0800
MIME-Version: 1.0
In-Reply-To: <c350fe27-76ca-d068-9ac6-6b27f1c1878b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2/26/20 6:50 PM, Jens Axboe wrote:
> On 2/18/20 1:35 PM, Eric Sandeen wrote:
>> On 2/6/20 11:52 AM, Eric Sandeen wrote:
>>> On 1/31/20 1:19 PM, Eric Sandeen wrote:
>>>> From: Eric Sandeen <sandeen@redhat.com>
>>>>
>>>> Newer gcc v10 complains about globals being defined twice due to
>>>> a new default -fno-common flag. This causes build failures:
>>>
>>> Ping?
>>>
>>> Thanks,
>>> -Eric
>>
>> Ok, well, this is in Fedora now in any case, since I needed to fix the FTBFS.
> 
> Sorry, applied it. Don't always see mailing list patches if they aren't
> CC'ed to me.

Oh, sorry.  I'll keep that in mind.

Thanks!

-Eric


