Return-Path: <prvs=136545b2b=Vincent.Fu@wdc.com>
From: Vincent Fu <Vincent.Fu@wdc.com>
Subject: Re: [three fio patches 3/3] smalloc: allocate pool-> members from
 shared memory
Date: Wed, 28 Aug 2019 19:44:38 +0000
Message-ID: 
 <BL0PR04MB4898E1614B5213924541271B95A30@BL0PR04MB4898.namprd04.prod.outlook.com>
References: <20190828174842.25423-1-vincentfu@gmail.com>
 <20190828174842.25423-4-vincentfu@gmail.com>
 <bb5acdc6-d2f6-99e6-2e9e-01fef4650b74@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "vincentfu@gmail.com" <vincentfu@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/28/19 3:13 PM, Jens Axboe wrote:=0A=
> On 8/28/19 11:48 AM, vincentfu@gmail.com wrote:=0A=
>> From: Vincent Fu <vincent.fu@wdc.com>=0A=
>>=0A=
>> If one process is making smalloc calls and another process is making=0A=
>> sfree calls, pool->free_blocks and pool->next_non_full will not be=0A=
>> synchronized because the two processes each have independent, local=0A=
>> copies of the variables.=0A=
>>=0A=
>> This patch allocates space for the two variables from shared storage so=
=0A=
>> that separate processes will be modifying quantities stored at the same=
=0A=
>> locations.=0A=
>>=0A=
>> This issue was discovered on the server side running a client/server job=
=0A=
>> with --status-interval=3D1. Such a job encountered an OOM error when onl=
y=0A=
>> ~50 objects were allocated from the smalloc pool.=0A=
>>=0A=
>> Also change the calculation of free_blocks in add_pool() to use=0A=
>> SMALLOC_BPI instead of SMALLOC_BPB. These two constants are=0A=
>> coincidentally the same on Linux and Windows but SMALLOC_BPI is the=0A=
>> correct one to use. free_blocks is the number of available blocks of=0A=
>> size SMALLOC_BPB. It is the product of the number of unsigned integers=
=0A=
>> in the bitmap (bitmap_blocks) and the number of bits per unsigned=0A=
>> integer (SMALLOC_BPI).=0A=
> =0A=
> Would it make more sense to just have the pool[] come out of shared=0A=
> memory?=0A=
> =0A=
>=0A=
=0A=
Yeah, that would avoid the ugly *(pool->free_blocks) expressions and =0A=
make things easier if anything else that needs to be shared is ever =0A=
added to struct pool.=0A=
=0A=
Would something like this in sinit() work?=0A=
=0A=
if (nr_pools =3D=3D 0)=0A=
=0A=
     mp =3D mmap(NULL, MAX_POOLS * sizeof(struct pool), ...)=0A=
=0A=
I'm on vacation through Labor Day and will work on this next week.=0A=
=0A=
Vincent=0A=

