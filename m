Return-Path: <axboe@kernel.dk>
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56A1AD7C.3060802@kernel.dk>
Date: Thu, 21 Jan 2016 21:18:04 -0700
MIME-Version: 1.0
In-Reply-To: <56A1536A.6060308@cran.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/21/2016 02:53 PM, Bruce Cran wrote:
> On 01/21/2016 02:43 PM, Jeff Furlong wrote:
>> Building version 2.5 on Windows appears broken:
>>
>>
>> server.c:272:11: error: 'MSG_DONTWAIT' undeclared (first use in this
>> function)
>>     flags = MSG_DONTWAIT;
>>             ^
>> server.c:272:11: note: each undeclared identifier is reported only
>> once for each function it appears in
>
> Yeah, there's also a problem with strcasestr.c. I'm working on fixing
> both problems just now.

We'll just spin a 2.6 once that's fixed.

I never heard back on the mutex issue, I'm assuming it's fixed for you?

-- 
Jens Axboe


