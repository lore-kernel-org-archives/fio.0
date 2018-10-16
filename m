Return-Path: <prvs=82083eb8f=Vincent.Fu@wdc.com>
From: Vincent Fu <Vincent.Fu@wdc.com>
Subject: Re: [PATCH 2/2] init: force threads when checking overlap in offload
 mode
Date: Tue, 16 Oct 2018 15:33:35 +0000
Message-ID: 
 <BYAPR04MB44214E35A13DF6609204B4D695FE0@BYAPR04MB4421.namprd04.prod.outlook.com>
References: <20181016152650.7784-1-vincentfu@gmail.com>
 <20181016152650.7784-3-vincentfu@gmail.com>
 <1a792daa-4327-1a4e-48df-4c691630c834@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "vincentfu@gmail.com" <vincentfu@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/16/2018 11:29 AM, Jens Axboe wrote:=0A=
> On 10/16/18 9:26 AM, vincentfu@gmail.com wrote:=0A=
>> From: Vincent Fu <vincent.fu@wdc.com>=0A=
>>=0A=
>> serialize_overlap combined with io_submit_mode=3Doffload requires=0A=
>> threads. Print a warning and force the use of threads if the user=0A=
>> did not specify threads.=0A=
> Why does it require threads? Is it because of the use of a pthread=0A=
> mutex? If so, that should just be a fio mutex instead, and you would=0A=
> not have this restrictions (on most platforms, at least).=0A=
>=0A=
It requires threads because io_u's are not allocated from the shared=0A=
memory area. Jobs need to access each other's io_u's to check for overlap.=
=0A=
=0A=

