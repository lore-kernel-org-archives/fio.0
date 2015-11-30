Return-Path: <axboe@kernel.dk>
Subject: Re: Bug with --buffer_compress_percentage
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
 <56533A11.4050706@kernel.dk> <56533BE5.3010606@kernel.dk>
 <CAF+0mv=KWZ-_VGEFLhDzh70E2ztr7esdjOpQR-wdLJ-eQ-mRng@mail.gmail.com>
 <5653D5EA.1060201@kernel.dk>
 <CAF+0mvnKfMNX-Pb1mYrQYubDqJJj84C0NQKVzMAGOoR84Qt8zg@mail.gmail.com>
 <5655F003.1000208@kernel.dk>
 <CAF+0mvmBhA7zWkoOuTiw_F=4qo+4QwSHKQwTVNtL1=hTnTsgNg@mail.gmail.com>
 <56568A13.7020703@kernel.dk>
 <CAF+0mvkM4AQzkJ=gt+_rQLKjKPFKr4xJjRb5NkdAqLbBsyakug@mail.gmail.com>
 <565CBD92.6060904@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <565CBFE3.4090302@kernel.dk>
Date: Mon, 30 Nov 2015 14:30:11 -0700
MIME-Version: 1.0
In-Reply-To: <565CBD92.6060904@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/30/2015 02:20 PM, Jens Axboe wrote:
> On 11/30/2015 02:17 PM, Matthew Eaton wrote:
>>> I think I found and fixed the main issue why the rebuild issue would
>>> happen,
>>> init.c didn't get the right dependencies. Hopefully a make clean
>>> won't be
>>> needed going forward.
>>>
>>> I still think that is your issue, I don't see any problems with the
>>> buffer
>>> filling. So do let me know when you test on Monday, thanks.
>>>
>>> --
>>> Jens Axboe
>>>
>>
>> I tested again trying a make clean as well as a fresh clone from git
>> but I could still reproduce.  This system is Ubuntu 14.04, so for
>> kicks I moved to a completely different system and installed Fedora 23
>> and fio from git, but had the same problem!
>>
>> This is my configure output.  Could I be missing something?
>
> Nope, that part should not matter. I'm probably wrong, then. I'll try
> and reproduce!

Try current -git, I think I found it.

-- 
Jens Axboe


