Return-Path: <prvs=8624f6c1e=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] options: Add thinktime_iotime option
Date: Mon, 23 Aug 2021 03:02:17 +0000
Message-ID: 
 <DM6PR04MB70811E567D631024AE13198BE7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210820112542.1489147-1-shinichiro.kawasaki@wdc.com>
 <DM6PR04MB70819EEF6D7109B5EF691BCBE7C49@DM6PR04MB7081.namprd04.prod.outlook.com>
 <20210823013541.ndgh3gcmyhteofyr@shindev>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 2021/08/23 10:35, Shinichiro Kawasaki wrote:=0A=
[...]=0A=
>>> diff --git a/thread_options.h b/thread_options.h=0A=
>>> index 4b4ecfe1..6fe1cad7 100644=0A=
>>> --- a/thread_options.h=0A=
>>> +++ b/thread_options.h=0A=
>>> @@ -189,6 +189,7 @@ struct thread_options {=0A=
>>>  	unsigned int thinktime_spin;=0A=
>>>  	unsigned int thinktime_blocks;=0A=
>>>  	unsigned int thinktime_blocks_type;=0A=
>>> +	unsigned int thinktime_iotime;=0A=
>>>  	unsigned int fsync_blocks;=0A=
>>>  	unsigned int fdatasync_blocks;=0A=
>>>  	unsigned int barrier_blocks;=0A=
>>> @@ -500,6 +501,8 @@ struct thread_options_pack {=0A=
>>>  	uint32_t thinktime_spin;=0A=
>>>  	uint32_t thinktime_blocks;=0A=
>>>  	uint32_t thinktime_blocks_type;=0A=
>>> +	uint32_t thinktime_iotime;=0A=
>>> +	uint32_t pad6;=0A=
>>=0A=
>> Why is this needed ? Some alignement warning ?=0A=
> =0A=
> Yes. Without the pad, I observe build errors as follows:=0A=
> =0A=
> In file included from fio.h:17,=0A=
>                  from libfio.c:31:=0A=
> libfio.c: In function =91initialize_fio=92:=0A=
> compiler/compiler.h:31:44: error: static assertion failed: "percentile_li=
st"=0A=
>    31 | #define compiletime_assert(condition, msg) _Static_assert(conditi=
on, msg)=0A=
>       |                                            ^~~~~~~~~~~~~~=0A=
> libfio.c:372:9: note: in expansion of macro =91compiletime_assert=92=0A=
>   372 |         compiletime_assert((offsetof(struct thread_options_pack, =
percentile_list) % 8) =3D=3D 0, "percentile_list");=0A=
>       |         ^~~~~~~~~~~~~~~~~~=0A=
> compiler/compiler.h:31:44: error: static assertion failed: "latency_perce=
ntile"=0A=
>    31 | #define compiletime_assert(condition, msg) _Static_assert(conditi=
on, msg)=0A=
>       |                                            ^~~~~~~~~~~~~~=0A=
> libfio.c:373:9: note: in expansion of macro =91compiletime_assert=92=0A=
>   373 |         compiletime_assert((offsetof(struct thread_options_pack, =
latency_percentile) % 8) =3D=3D 0, "latency_percentile");=0A=
>       |         ^~~~~~~~~~~~~~~~~~=0A=
> make: *** [Makefile:496: libfio.o] Error 1=0A=
> make: *** Waiting for unfinished jobs....=0A=
> =0A=
>> If yes, have you tried moving=0A=
>> this declaration in the struct ?=0A=
> =0A=
> Yes. I moved the new field thinktime_iotime to the end of struct=0A=
> thread_options_pack then the errors were avoided. But I wanted=0A=
> to place the new field at the same place as other thinktime related=0A=
> fields. For that purpose, I needed to add the padding pad6. I tried to=0A=
> utilize other pads such as pad2 or pad5, but it didn't work.=0A=
> =0A=
> To place the related fields at same place with padding, or to place the n=
ew=0A=
> field at different place without padding, which way to go?=0A=
=0A=
I think that is a question for Jens...=0A=
=0A=
Jens,=0A=
=0A=
Which way do you prefer ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

