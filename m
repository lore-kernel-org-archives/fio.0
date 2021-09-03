Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] options: Add thinktime_iotime option
References: <20210820112542.1489147-1-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB70819EEF6D7109B5EF691BCBE7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
 <20210823013541.ndgh3gcmyhteofyr@shindev>
 <DM6PR04MB70811E567D631024AE13198BE7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
 <20210903012602.dkdwfxybvmlzuhh4@shindev>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d5917e42-e2c0-0bed-eb5a-98c16f969d50@kernel.dk>
Date: Thu, 2 Sep 2021 20:57:52 -0600
MIME-Version: 1.0
In-Reply-To: <20210903012602.dkdwfxybvmlzuhh4@shindev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/2/21 7:26 PM, Shinichiro Kawasaki wrote:
> On Aug 23, 2021 / 03:02, Damien Le Moal wrote:
>> On 2021/08/23 10:35, Shinichiro Kawasaki wrote:
>> [...]
>>>>> diff --git a/thread_options.h b/thread_options.h
>>>>> index 4b4ecfe1..6fe1cad7 100644
>>>>> --- a/thread_options.h
>>>>> +++ b/thread_options.h
>>>>> @@ -189,6 +189,7 @@ struct thread_options {
>>>>>  	unsigned int thinktime_spin;
>>>>>  	unsigned int thinktime_blocks;
>>>>>  	unsigned int thinktime_blocks_type;
>>>>> +	unsigned int thinktime_iotime;
>>>>>  	unsigned int fsync_blocks;
>>>>>  	unsigned int fdatasync_blocks;
>>>>>  	unsigned int barrier_blocks;
>>>>> @@ -500,6 +501,8 @@ struct thread_options_pack {
>>>>>  	uint32_t thinktime_spin;
>>>>>  	uint32_t thinktime_blocks;
>>>>>  	uint32_t thinktime_blocks_type;
>>>>> +	uint32_t thinktime_iotime;
>>>>> +	uint32_t pad6;
>>>>
>>>> Why is this needed ? Some alignement warning ?
>>>
>>> Yes. Without the pad, I observe build errors as follows:
>>>
>>> In file included from fio.h:17,
>>>                  from libfio.c:31:
>>> libfio.c: In function ‘initialize_fio’:
>>> compiler/compiler.h:31:44: error: static assertion failed: "percentile_list"
>>>    31 | #define compiletime_assert(condition, msg) _Static_assert(condition, msg)
>>>       |                                            ^~~~~~~~~~~~~~
>>> libfio.c:372:9: note: in expansion of macro ‘compiletime_assert’
>>>   372 |         compiletime_assert((offsetof(struct thread_options_pack, percentile_list) % 8) == 0, "percentile_list");
>>>       |         ^~~~~~~~~~~~~~~~~~
>>> compiler/compiler.h:31:44: error: static assertion failed: "latency_percentile"
>>>    31 | #define compiletime_assert(condition, msg) _Static_assert(condition, msg)
>>>       |                                            ^~~~~~~~~~~~~~
>>> libfio.c:373:9: note: in expansion of macro ‘compiletime_assert’
>>>   373 |         compiletime_assert((offsetof(struct thread_options_pack, latency_percentile) % 8) == 0, "latency_percentile");
>>>       |         ^~~~~~~~~~~~~~~~~~
>>> make: *** [Makefile:496: libfio.o] Error 1
>>> make: *** Waiting for unfinished jobs....
>>>
>>>> If yes, have you tried moving
>>>> this declaration in the struct ?
>>>
>>> Yes. I moved the new field thinktime_iotime to the end of struct
>>> thread_options_pack then the errors were avoided. But I wanted
>>> to place the new field at the same place as other thinktime related
>>> fields. For that purpose, I needed to add the padding pad6. I tried to
>>> utilize other pads such as pad2 or pad5, but it didn't work.
>>>
>>> To place the related fields at same place with padding, or to place the new
>>> field at different place without padding, which way to go?
>>
>> I think that is a question for Jens...
>>
>> Jens,
>>
>> Which way do you prefer ?
> 
> Jens,
> 
> May I ask your comment on the new pad in the struct thread_options_pack? If the
> new pad is not good, I will move the new field thinktime_iotime to the end of
> the struct.

I tend to add new elements where I can remove a padding field. Or moving
things around to make it saner. If you need to add pad6, then that's
a clear indication that things can be moved around and padding reduced.

-- 
Jens Axboe


