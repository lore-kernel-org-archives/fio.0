Return-Path: <axboe@kernel.dk>
Message-ID: <533E163B.2080605@kernel.dk>
Date: Thu, 03 Apr 2014 20:17:31 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <533B7FC4.70700@cran.org.uk> <533DE3DC.6020605@cran.org.uk> <533E1172.6010803@kernel.dk> <533E1590.1070109@cran.org.uk>
In-Reply-To: <533E1590.1070109@cran.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, =?ISO-8859-1?Q?S=E9bastien_Bouchex_?= =?ISO-8859-1?Q?Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>

On 2014-04-03 20:14, Bruce Cran wrote:
>
> On 4/3/2014 7:57 PM, Jens Axboe wrote:
>> On 2014-04-03 16:42, Bruce Cran wrote:
>>>
>>> Also, fio-2.0.15 works, while fio-2.1 doesn't.
>>
>> That makes very little sense... How could the contents of the buffer
>> change the behavior?
>>
>> Could you run a git bisect? Should be quick'n easy, if it's nicely
>> reproducible.
>>
>
> http://git.kernel.dk/?p=fio.git;a=commit;h=cc86c395fd9dd2002ec1edc0967b7c9453debdfb
> is the changeset that breaks things - and I know it makes no sense.

That is pretty nutty. If you revert just the change to filesetup.c, does 
that make it work again?

-- 
Jens Axboe


