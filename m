Return-Path: <bruce@cran.org.uk>
Message-ID: <533E1590.1070109@cran.org.uk>
Date: Thu, 03 Apr 2014 20:14:40 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <533B7FC4.70700@cran.org.uk> <533DE3DC.6020605@cran.org.uk> <533E1172.6010803@kernel.dk>
In-Reply-To: <533E1172.6010803@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, =?ISO-8859-1?Q?S=E9bastien_Bouchex_?= =?ISO-8859-1?Q?Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>


On 4/3/2014 7:57 PM, Jens Axboe wrote:
> On 2014-04-03 16:42, Bruce Cran wrote:
>>
>> Also, fio-2.0.15 works, while fio-2.1 doesn't.
>
> That makes very little sense... How could the contents of the buffer 
> change the behavior?
>
> Could you run a git bisect? Should be quick'n easy, if it's nicely 
> reproducible.
>

http://git.kernel.dk/?p=fio.git;a=commit;h=cc86c395fd9dd2002ec1edc0967b7c9453debdfb 
is the changeset that breaks things - and I know it makes no sense.

-- 
Bruce

