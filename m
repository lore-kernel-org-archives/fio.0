Return-Path: <axboe@kernel.dk>
Subject: Re: Re loading libaio engine error and pvsync2 operation not
 permitted error
References: <CAFF4W0UPjgKPX2t=aqRPsjKN65DJHa46emuTckTOsNx4BYBoZg@mail.gmail.com>
 <CAFF4W0XUBMLn5TuYWonvoJntZfPUtUS7HypWpejw8Ofer9z9Sw@mail.gmail.com>
 <0E387D6D-E489-41E2-B535-577AD63036F9@emc.com>
 <CAFF4W0VUtSHm1BVAMS9WrFhkUBKMv-_SbyNLXia08OeyfVQ6FA@mail.gmail.com>
 <BN3PR0401MB164063C824D35F22565924D3E7D60@BN3PR0401MB1640.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5b2250e7-75f9-97cc-943e-83e111b45918@kernel.dk>
Date: Wed, 28 Nov 2018 08:28:43 -0700
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB164063C824D35F22565924D3E7D60@BN3PR0401MB1640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Mohanraj B <bmohanraj91@gmail.com>, "Beierl, Mark" <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/25/18 4:51 PM, Damien Le Moal wrote:
> On 2018/11/26 5:01, Mohanraj B wrote:
>> Hi,
>>
>> 1) How are you installing FIO =EF=BF=BD from the apt repos, or building =
from source?
>> I build fio from source, below is my dockerfile.
>>
>> FROM centos:latest
>> RUN yum update -y
>> RUN yum install git gcc gcc-c++ make  -y
>> RUN git clone https://github.com/axboe/fio
>> RUN yum install zlib-devel libaio -y
>=20
> yum install libaio-devel ?
> Otherwise, libaio will not be compiled...

That's the real answer, I believe that's also mentioned in the
instructions for building fio.

--=20
Jens Axboe


