Return-Path: <prvs=474eabae4=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 1/4] configure: improve libzbc version check
Date: Fri, 31 Jul 2020 07:06:52 +0000
Message-ID: 
 <MWHPR04MB3758D578A0BE8DA074A0E2EFE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
 <20200729210415.4166-2-dmitry.fomichev@wdc.com>
 <CY4PR04MB3751CCE0FB675C4906F9C414E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <MN2PR04MB59519F3A6FCC32DFCEC891B3E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
 <CALjAwxgRCsoKwhJhg8M1TO8Ga3Os+gQxSWAQQX=suvLvabsZCA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@gmail.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/31 14:54, Sitsofe Wheeler wrote:=0A=
> On Fri, 31 Jul 2020 at 00:09, Dmitry Fomichev <Dmitry.Fomichev@wdc.com> w=
rote:=0A=
>>=0A=
>> Right now, there is no default for libzbc ioengine support. If libzbc is=
 found by=0A=
>> configure, then libzbc ioengine will always be added. The new flag, --di=
sable-libzbc,=0A=
>> prevents adding support for libzbc ioengine in this case. If libzbc is n=
ot present,=0A=
>> fio configure is not failed with "feature not found".=0A=
>>=0A=
>> Currently, no other feature in fio configure has the default option of "=
yes" and all=0A=
>> features that can be explicitly set to yes are set so by script command =
line options.=0A=
>> If a feature is set to yes and is not available, configure fails with "f=
eature not found"=0A=
>> error. Do we really want configure to fail on any system that doesn't ha=
ve libzbc=0A=
>> unless --disable-libzbc is added to the command line?=0A=
>>=0A=
>> There is one feature option, "disable_lex",  with the default value, "".=
 I guess we=0A=
>> could define libzbc option the same way to improve code clarity.=0A=
> =0A=
> That's right:=0A=
> - "yes": hard fail if probe fails=0A=
> - "": probe but don't hard fail=0A=
> - "no": don't probe and disable feature=0A=
> =0A=
> So your suggestion of a default of "" is right because I can't believe=0A=
> we want to hard fail when libzbc is unavailable.=0A=
> =0A=
> I learned of this pattern while reading=0A=
> https://github.com/qemu/qemu/blob/1448629751871c4924c234c2faaa968fc26890e=
1/configure#L348=0A=
> which I think was the basis of fio's configure script. The desire to=0A=
> show this pattern led to some of the refactoring in=0A=
> https://github.com/axboe/fio/commit/d490af7f8c0ee7a992f332bb6bcffb30313d6=
488=0A=
> even though it added some unncessary lines for those options...=0A=
> =0A=
=0A=
Thanks. That indeed clarifies everything !=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

