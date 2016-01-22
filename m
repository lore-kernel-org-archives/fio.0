Return-Path: <axboe@kernel.dk>
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk> <56A1AD7C.3060802@kernel.dk>
 <56A271EF.6040401@cran.org.uk> <56A279E4.8090209@kernel.dk>
 <56A2A6DB.2090802@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56A2A940.9000105@kernel.dk>
Date: Fri, 22 Jan 2016 15:12:16 -0700
MIME-Version: 1.0
In-Reply-To: <56A2A6DB.2090802@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/22/2016 03:02 PM, Bruce Cran wrote:
> On 1/22/16 11:50 AM, Jens Axboe wrote:
>
>> - I think we should just use OS_MSG_DONTWAIT in the server.c code, then
>> it'd work fine. That's an oversight on my behalf.
>>
>> - On the strcasestr, since you have STRCASESTR on Windows, don't you
>> just need to add   output_sym "CONFIG_STRCASESTR" to configure for
>> windows?
>>
>
> I tried defining CONFIG_STRCASESTR but it didn't work - so I think
> strcasestr.o is being linked in twice?

I think you earlier added it in the cygwin section. We need to kill that 
one, not the generic one, since that would fail on systems not providing 
strcasestr().

http://git.kernel.dk/cgit/fio/commit/?id=ada83043abcb94dde7c603ce60ae8de9693a022f

-- 
Jens Axboe


