Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Revert "Avoid irrelevant "offset extend ends" error
 message for chrdev"
References: <20171129092922.4109-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ba40be9c-77cc-29b1-3625-424c91d1f071@kernel.dk>
Date: Wed, 29 Nov 2017 09:11:08 -0700
MIME-Version: 1.0
In-Reply-To: <20171129092922.4109-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org, elliott@hpe.com
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 11/29/2017 02:29 AM, Tomohiro Kusumi wrote:
> This reverts commit 0f34169ac64f009b193bed1c8fb6692844bf99c2.
> 
>> Commit 0f34169a broke it, moving a check from a non-character
>> device path up a level to where it now triggers on a character
>> device (for which the size is left set to -1ULL).
>>
>> This gets it working again:
>>         git revert 0f34169a
>>         make
>>
>> Tomohiro, could you help prepare a better fix?
> 
> Sorry, I'll just revert it at the moment.

Yeah let's kill it, that patch has been far more trouble than it's
worth.

-- 
Jens Axboe


