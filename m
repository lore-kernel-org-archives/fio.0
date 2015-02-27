Return-Path: <axboe@kernel.dk>
Message-ID: <54F08B8F.9040206@kernel.dk>
Date: Fri, 27 Feb 2015 08:21:51 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: suggestion:  patch to make per-thread IOPS more accurate
References: <596106035.8980737.1421443175599.JavaMail.zimbra@redhat.com> <54B982D7.1070503@kernel.dk> <159806365.11854527.1422052704407.JavaMail.zimbra@redhat.com> <1745095866.10478940.1424039625224.JavaMail.zimbra@redhat.com> <54EF8E70.1000504@gmail.com> <54EFAA24.8070603@kernel.dk> <618699956.9909382.1425010455755.JavaMail.zimbra@redhat.com>
In-Reply-To: <618699956.9909382.1425010455755.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrew Theurer <atheurer@redhat.com>
Cc: Mark Nelson <mark.a.nelson@gmail.com>, Ben England <bengland@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/26/2015 09:14 PM, Andrew Theurer wrote:
>
>
> ----- Original Message -----
>> From: "Jens Axboe" <axboe@kernel.dk>
>> To: "Mark Nelson" <mark.a.nelson@gmail.com>, "Ben England" <bengland@redhat.com>, fio@vger.kernel.org
>> Sent: Thursday, February 26, 2015 5:20:04 PM
>> Subject: Re: suggestion:  patch to make per-thread IOPS more accurate
>>
>> On 02/26/2015 02:21 PM, Mark Nelson wrote:
>>> Hi Ben,
>>>
>>> I confess that I'm not using JSON output myself, but I think this would
>>> be really beneficial when there are a lot of clients (like VMs).
>>>
>>> Jens, would this be an acceptable change?  I think I'd appreciate this
>>> if I switch over to using the JSON output.
>>
>> I like the change, my only worry is that it'll break somebody's
>> parsing... So from that end, perhaps it'd be better to add a new field
>> instead of reusing the 'iops' field to dump it.
>>
>> Maybe I'm just being overly cautious here, feel free to tell me I'm wrong.
>
> Since this is for the json data, I don't think the parsing would be an issue.  I have at least tried reading this data with parl::JSON with this patch, and there have been no issues.

Alright, I was hoping that might be the case. I have applied the patch, 
thanks guys.

-- 
Jens Axboe


