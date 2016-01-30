Return-Path: <Konstantin.Ruvinsky@emc.com>
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Subject: RE: FW: default value for random_generator
Date: Sat, 30 Jan 2016 17:21:20 +0000
Message-ID: <923FC40148D42D44A828D320CE66E06A01F15E@MX204CL01.corp.emc.com>
References: <923FC40148D42D44A828D320CE66E06A01E620@MX204CL01.corp.emc.com>
 <56A9411B.5020707@kernel.dk>
In-Reply-To: <56A9411B.5020707@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Thanks for your answer. Sorry for delay - was OOO.
The patch is very simple: is necessary to add words ", this is the default =
value" after description of the tausworthe generator:


 999 random_generator=3Dstr    Fio supports the following engines for gener=
ating
1000                 IO offsets for random IO:
1001=20
1002                 tausworthe      Strong 2^88 cycle random number genera=
tor,
			        this is the default value.
1003                 lfsr            Linear feedback shift register generat=
or
1004                 tausworthe64    Strong 64-bit 2^258 cycle random numbe=
r
1005                                 generator

Could you please add it to one of your future commits, since I'm not famili=
ar enough with patching?

Thank you.

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, January 28, 2016 12:14 AM
To: Ruvinsky, Konstantin; fio@vger.kernel.org
Subject: Re: FW: default value for random_generator

On 01/27/2016 05:21 AM, Ruvinsky, Konstantin wrote:
> Hi,
>
> In the description of random_generator=3Dstr in HowTo (=20
> http://git.kernel.dk/?p=3Dfio.git;a=3Dblob;f=3DHOWTO;h=3D7c24c1b74296aa33=
cdff9
> 7eca9458defd291b6ca;hb=3DHEAD ) is not written now what is its default va=
lue.

$ fio --cmdhelp=3Drandom_generator

care to send a patch to add it to the HOWTO/man page?
     random_generator: Type of random number generator to use
                 type: string (opt=3Dbla)
              default: tausworthe
         valid values: tausworthe Strong Tausworthe generator
                     : lfsr       Variable length LFSR
                     : tausworthe64 64-bit Tausworthe variant

Care to send a patch to update the HOWTO/man page?

--
Jens Axboe


