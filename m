Return-Path: <axboe@kernel.dk>
Subject: Re: Bug with --buffer_compress_percentage
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
 <56533A11.4050706@kernel.dk> <56533BE5.3010606@kernel.dk>
 <CAF+0mv=KWZ-_VGEFLhDzh70E2ztr7esdjOpQR-wdLJ-eQ-mRng@mail.gmail.com>
 <5653D5EA.1060201@kernel.dk>
 <CAF+0mvnKfMNX-Pb1mYrQYubDqJJj84C0NQKVzMAGOoR84Qt8zg@mail.gmail.com>
 <5655F003.1000208@kernel.dk>
 <CAF+0mvmBhA7zWkoOuTiw_F=4qo+4QwSHKQwTVNtL1=hTnTsgNg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56568A13.7020703@kernel.dk>
Date: Wed, 25 Nov 2015 21:26:59 -0700
MIME-Version: 1.0
In-Reply-To: <CAF+0mvmBhA7zWkoOuTiw_F=4qo+4QwSHKQwTVNtL1=hTnTsgNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/25/2015 05:55 PM, Matthew Eaton wrote:
>> That's odd, I can't reproduce that. Could this just be a bad build? Fio
>> sometimes fails to rebuild correctly between version. Does it persist across
>> a make clean && make?
>>
>>
>> --
>> Jens Axboe
>>
>
> Weird!  I will look into this again on Monday when I am back at work.

I think I found and fixed the main issue why the rebuild issue would 
happen, init.c didn't get the right dependencies. Hopefully a make clean 
won't be needed going forward.

I still think that is your issue, I don't see any problems with the 
buffer filling. So do let me know when you test on Monday, thanks.

-- 
Jens Axboe


