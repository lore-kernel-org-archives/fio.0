Return-Path: <axboe@kernel.dk>
Message-ID: <54E613D8.90107@kernel.dk>
Date: Thu, 19 Feb 2015 08:48:24 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Potential leaks & errors on current trunk
References: <54E35788.2000400@enovance.com> <54E4DBB7.7080705@kernel.dk> <54E5D468.1070200@enovance.com>
In-Reply-To: <54E5D468.1070200@enovance.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/19/2015 04:17 AM, Erwan Velu wrote:
>
> Le 18/02/2015 19:36, Jens Axboe a écrit :
>>
>>> http://git.kernel.dk/?p=fio.git;a=blob;f=iolog.c;h=99f8bc18d8694cca0c141c51d116aced1b4130f2;hb=HEAD#l863
>>>
>>>
>>> In that function, if we do return 1 we do leak ic.buf, we shall free it
>>> before the return
>>
>> Yep, there's a potential leak or two there, should be fixed up.
>>
>>> http://git.kernel.dk/?p=fio.git;a=blob;f=lib/axmap.c;h=164300f254014b10ed6e04e3e06b7263aa917aac;hb=HEAD#l127
>>>
>>>
>>> Here, we surely miss the free of the axmap. We did free its internal
>>> structure but not axmap itself.
>>
>> Yes, that should free 'axmap' too of course.
>>
>
> Hey Jens,
>
> I don't know your workflow : do you accept pull request directly on
> github ?

I do, I'm pretty flexible that way.

> At least, please find the two commits for that issues in my repo :
> https://github.com/enovance/fio/tree/erwan/memory-leak

Thanks, applied. But I had to fix up your whitespace, you are using 
spaces instead of tabs.

-- 
Jens Axboe


