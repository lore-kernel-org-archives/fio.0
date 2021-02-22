Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] parse: simplify parse_is_percent()
References: <YDOvg+OKTZhSoDce@localhost.localdomain>
 <4c012bb6-5100-6262-20a1-ba6992786c25@kernel.dk>
 <YDPd3CMn9MRPZ4Do@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <503397c6-63d3-dcb9-5638-4138c72e42de@kernel.dk>
Date: Mon, 22 Feb 2021 09:38:26 -0700
MIME-Version: 1.0
In-Reply-To: <YDPd3CMn9MRPZ4Do@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org, dmitry.fomichev@wdc.com
List-ID: <fio@vger.kernel.org>

On 2/22/21 9:37 AM, Alexey Dobriyan wrote:
> On Mon, Feb 22, 2021 at 07:36:42AM -0700, Jens Axboe wrote:
>> On 2/22/21 6:20 AM, Alexey Dobriyan wrote:
>>> Check "unsigned long long val <= -1ULL" is tautologically true
>>> because of how value conversions work.
>>
>> Thanks, applied this and the other 3 patches. Note for future
>> patch series you should use git send-email and provide a small cover
>> letter for the series. Also avoids typos like 2/5 for patch 2, and
>> it gives the reviewer a sense of the whole series.
> 
> Oh well, still can't get used to bulk emailing.
> 
> These patches are independent in fact.
> There is textual dependency between parse_is_percent() and main 'z'
> suffix patch.
> 
> And the rest was found while reading code for 'z' suffix.

Even if they are independent, it's easier to organize if you send
it out as a series :-)

-- 
Jens Axboe


