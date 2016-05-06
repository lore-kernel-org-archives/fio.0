Return-Path: <axboe@kernel.dk>
Subject: Re: Missing log entries and other questions
References: <eBGJ1s00E1TeosZ01BGKGG> <036a01d19f62$717af530$5470df90$@cox.net>
 <20160427203823.GB25397@kernel.dk> <572A02B9.1040902@kernel.dk>
 <572A24AC.5090106@kernel.dk> <c85dc095-f2d2-851b-7246-8530230e997c@gmail.com>
 <572A60D1.3050700@kernel.dk> <572A69F7.4010102@kernel.dk>
 <bbbda45d-dc91-0cdf-cd65-d0541c5ffc20@gmail.com> <572CD03F.6060507@kernel.dk>
 <f039468a-0c04-570a-679b-1c76b5d3f37d@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <572CD1EF.9000005@kernel.dk>
Date: Fri, 6 May 2016 11:18:39 -0600
MIME-Version: 1.0
In-Reply-To: <f039468a-0c04-570a-679b-1c76b5d3f37d@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>, Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

On 05/06/2016 11:16 AM, Mark Nelson wrote:
> On 05/06/2016 12:11 PM, Jens Axboe wrote:
>> On 05/05/2016 01:33 PM, Mark Nelson wrote:
>>>>>>> Can you try the below patch?
>>>>>>
>>>>>> I'll also try to take a look at this as we've seen a fair amount of
>>>>>> skew
>>>>>> in the logs doing fio librbd upstream ceph testing.
>>>>>
>>>>> That'd be great. More complete version below, fwiw.
>>>
>>> Ok, I'll try this one.  It might be a bit before I can test it since I'm
>>> bisecting ceph right now looking for a regression that only hits 128k
>>> sequential rbd reads.  Go figure. :)
>>
>> When you get to it, here's an updated version. I'm tempted to shove this
>> into a new branch, instead of flinging diffs around... Let me know what
>> you prefer.
>
> new branch would be wonderful!

Done, it's now in the 'logging' branch:

http://git.kernel.dk/cgit/fio/commit/?h=logging&id=a47591e4923fb8faef18e1cd5125a50429282089

-- 
Jens Axboe


