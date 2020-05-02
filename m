Return-Path: <prvs=38445ce10=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/7] zbd: bump ZBD_MAX_OPEN_ZONES
Date: Sat, 2 May 2020 04:37:11 +0000
Message-ID: 
 <BY5PR04MB6900A72C37A609FCE0C66115E7A80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <BY5PR04MB690069FD2724EB40CA9AC828E7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200501144702.GA15160@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/05/01 23:47, Alexey Dobriyan wrote:=0A=
> On Fri, May 01, 2020 at 01:19:10AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
> =0A=
>>> -#define ZBD_MAX_OPEN_ZONES	128=0A=
>>> +#define ZBD_MAX_OPEN_ZONES	4096=0A=
>>>  =0A=
>>>  /*=0A=
>>>   * Zoned block device models.=0A=
>>>=0A=
>>=0A=
>> Makes sense. ZNS will will need this.=0A=
> =0A=
> Oh yeah :^) 128 opened zones doesn't cut it.=0A=
> =0A=
>> Note: You did not send a cover letter for the series. Please add it for =
the next=0A=
>> round.=0A=
> =0A=
> There is no cover letter, fixes are really independent.=0A=
=0A=
Even in such case, a cover letter is still useful for Jens to ack all patch=
es in=0A=
one go instead of having to answer each patch email.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

