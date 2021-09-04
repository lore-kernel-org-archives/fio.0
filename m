Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] options: Add thinktime_iotime option
References: <20210903083719.1757299-1-shinichiro.kawasaki@wdc.com>
 <ef8b37bd-d743-5e89-eb98-c619523c34e2@kernel.dk>
 <20210903213801.m46bdht67ukz7blm@shindev>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9ddf62e1-6f8e-0f20-1ef5-9b0426b15d34@kernel.dk>
Date: Fri, 3 Sep 2021 18:58:58 -0600
MIME-Version: 1.0
In-Reply-To: <20210903213801.m46bdht67ukz7blm@shindev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/3/21 3:38 PM, Shinichiro Kawasaki wrote:
> On Sep 03, 2021 / 06:38, Jens Axboe wrote:
>> On 9/3/21 2:37 AM, Shin'ichiro Kawasaki wrote:
>>> diff --git a/options.c b/options.c
>>> index 8c2ab7cc..3fe1e6bd 100644
>>> --- a/options.c
>>> +++ b/options.c
>>> @@ -3688,6 +3688,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>>>  		},
>>>  		.parent = "thinktime",
>>>  	},
>>> +	{
>>> +		.name	= "thinktime_iotime",
>>> +		.lname	= "Thinktime interval",
>>> +		.type	= FIO_OPT_INT,
>>> +		.off1	= offsetof(struct thread_options, thinktime_iotime),
>>> +		.help	= "IO time interval between 'thinktime'",
>>> +		.is_time = 1,
>>> +		.is_seconds = 1,
>>> +		.def	= "0",
>>> +		.parent	= "thinktime",
>>> +		.hide	= 1,
>>> +		.category = FIO_OPT_C_IO,
>>> +		.group	= FIO_OPT_G_THINKTIME,
>>> +	},
>>
>> Please line these up nicely as is done elsewhere.
> 
> Ah, the order of the members are diffferent from others. I will move a
> few members to make the order same as others.

I didn't notice the ordering, but just to be clear, I'm just referring
to the tabbing so the '=' line up. But if they are out of order, please
do correct that too.

>> Apart from that, this looks fine. Could really use an example job
>> though, and an improvement in the explanation. The commit message looks
>> great, but then the doc additions are pretty lackluster. Maybe steal a
>> bit of the text you wrote from the commit message and put it in the
>> shipped documentation?
> 
> I will improve the descriptions of the new option in fio.1 and HOWTO,
> copying some of the commit message. Also I will add "for example"
> option usage in the descriptions.

Sounds good, thanks!

-- 
Jens Axboe


