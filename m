Return-Path: <axboe@kernel.dk>
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk> <56A1AD7C.3060802@kernel.dk>
 <56A271EF.6040401@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56A279E4.8090209@kernel.dk>
Date: Fri, 22 Jan 2016 11:50:12 -0700
MIME-Version: 1.0
In-Reply-To: <56A271EF.6040401@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/22/2016 11:16 AM, Bruce Cran wrote:
> On 1/21/16 9:18 PM, Jens Axboe wrote:
>> On 01/21/2016 02:53 PM, Bruce Cran wrote:
>>> Yeah, there's also a problem with strcasestr.c. I'm working on fixing
>>> both problems just now.
>>
>> We'll just spin a 2.6 once that's fixed.
>
> I've attached a patch that should fix it.  The removal of strcasestr.o
> is because I was getting a error saying strcasestr had already been
> defined.

Two comments:

- I think we should just use OS_MSG_DONTWAIT in the server.c code, then 
it'd work fine. That's an oversight on my behalf.

- On the strcasestr, since you have STRCASESTR on Windows, don't you 
just need to add   output_sym "CONFIG_STRCASESTR" to configure for windows?

-- 
Jens Axboe


