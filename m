Return-Path: <erwan@seanodes.com>
Message-ID: <492417BC.1020701@seanodes.com>
Date: Wed, 19 Nov 2008 14:42:20 +0100
From: Erwan Velu <erwan@seanodes.com>
MIME-Version: 1.0
Subject: Re: Help required to understand fio output
References: <4924115E.6040701@seanodes.com> <20081119131945.GD26308@kernel.dk>
In-Reply-To: <20081119131945.GD26308@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote:

[...]
> The output could do with a bit of prettying up... It's explained in the
> documentation, though, The 100=64.24% field means that 64.24% of the ios
> completed within 50 and 99ms, as you indicate.
>   
I would say that [50-99]=64.24% would have been less confusing even if 
it take more room.
[...]

>> And then, how should I understan lines 8 & 9 that reports that 100% of 
>> IOs were completed with a depth=4... What happened ?
>>     
>
> Same deal, 4 means 1-4 completions per io_getevents() call for your test
> case. So any attempt to retrieve completed IO from the system resulted
> in a return of 1-4 ios.
I just don't understand what the reason of that 64 -> 4 depth reduction. 
Is that related to the storage or the kernel capabilities ?


-- 
Erwan Velu
Pre-Sales Engineer
Seanodes
http://www.seanodes.com
+33 (0)1 41 22 13 83


