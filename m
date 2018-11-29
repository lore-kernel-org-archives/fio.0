Return-Path: <prvs=86459b244=Vincent.Fu@wdc.com>
From: Vincent Fu <Vincent.Fu@wdc.com>
Subject: Re: [PATCH] gettime: use nsec in get_cycles_per_msec division
Date: Thu, 29 Nov 2018 18:31:02 +0000
Message-ID: 
 <BYAPR04MB4421EC1B964FCD677181697A95D20@BYAPR04MB4421.namprd04.prod.outlook.com>
References: <20181129181418.24788-1-vincentfu@gmail.com>
 <e784e513-65b4-bb28-8487-347ae467f5f5@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "vincentfu@gmail.com" <vincentfu@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/29/18 1:21 PM, Jens Axboe wrote:=0A=
> On 11/29/18 11:14 AM, vincentfu@gmail.com wrote:=0A=
>> From: Vincent Fu <vincent.fu@wdc.com>=0A=
>>=0A=
>> Since we now have ntime_since() we can use nsec in the division for=0A=
>> get_cycles_per_msec(). This makes the cycles_per_msec value that fio=0A=
>> ultimately uses more stable since fio will no longer be using values=0A=
>> truncated to usec.=0A=
>>=0A=
>> While we're here also modify some debug prints to make it explicit that=
=0A=
>> fio ultimately uses a trimmed mean in its time calculations.=0A=
>>=0A=
>> On platforms where only gettimeofday() is available this will be no=0A=
>> worse than the original code since we will revert back to using times=0A=
>> truncated to usec.=0A=
>>=0A=
>> With the patch, the last three digits of the trimmed mean have a tight=
=0A=
>> range from 784-786. Without the patch, the corresponding value (labeled=
=0A=
>> avg) has a much wider range from 821-958. Notice also that the standard=
=0A=
>> error S is an order of magnitude smaller with the patch.=0A=
> This is great, thanks Vincent. Applied.=0A=
I made a mistake in the commit message. Instead of "a tight range from=0A=
784-786" it should be 788-789.=0A=

