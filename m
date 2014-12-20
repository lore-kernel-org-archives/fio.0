Return-Path: <gschoenberger@thomas-krenn.com>
Date: Sat, 20 Dec 2014 09:26:32 +0100 (CET)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>
Message-ID: <1921541814.317725.1419063992558.JavaMail.zimbra@thomas-krenn.com>
In-Reply-To: <54919A81.8010007@kernel.dk>
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com> <548EFB15.8080704@kernel.dk> <54915786.3010009@enovance.com> <54919A81.8010007@kernel.dk>
Subject: Re: SSD write latency lower than read latency
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: fio@vger.kernel.org
Cc: Erwan Velu <erwan@enovance.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Erwan Velu" <erwan@enovance.com>, "Georg Sch=C3=B6nberger" <gschoenb=
erger@thomas-krenn.com>, fio@vger.kernel.org
> Sent: Wednesday, 17 December, 2014 4:00:17 PM
> Subject: Re: SSD write latency lower than read latency
>=20
> On 12/17/2014 03:14 AM, Erwan Velu wrote:
> >
> > Le 15/12/2014 16:15, Jens Axboe a =C3=A9crit :
> >> Your guess is exactly right, that's what most flash based devices
> >> (worth their salt) do. That's also why sync write latencies are mostly
> >> independent of the type of nand used, whereas the read latency will
> >> easily reflect that.
> > But here the runtime is very limited to 60. I can imagine that if we
> > push the runtime to a longer time, the cache will not be enough to hide
> > the real latency of the device. The cache is said to be 1GB by
> > disassembling the device, maybe if we push the devices with bigger
> > iodepth & a longer run, maybe we can show the performance of the NAND :
> > once the cache is getting new data faster than it can write, the cache
> > will be more occupied, if we can achieve at feeding it completely then
> > we are done. I had the case with a poor MLC (128GB) that had 500MB of
> > SLC cache. On some pattern I was hitting the MLC at 5MB/sec ...
> >
> > Note that in theirs specs, the write latency (65=C2=B5s) is very close =
to the
> > read latency (50 =C2=B5s):
> > http://ark.intel.com/products/75679/Intel-SSD-DC-S3500-Series-160GB-2_5=
in-SATA-6Gbs-20nm-MLC
> >
> >
> > On the pdf
> > (http://www.intel.fr/content/dam/www/public/us/en/documents/product-spe=
cifications/ssd-dc-s3500-spec.pdf),
> > we also see in the QoS sheet, that writes are said to be slower than
> > reads (up to 10x with iodepth=3D32).
>=20
> Yes, that's a given, there's a potentially huge difference between the
> single write sync latency (which can be shaved down to the cost of issue
> + irq + complete + wakeup), and eg write at steady state where you might
> have to delay/stall writes if GC can't keep up.
>=20
>=20

Thanks for your confirmation about the write cache, it's always good to kno=
w where
things come from. According to steady state and GC, I am testing according =
to the SNIA
specification:
* http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.0.pdf
with TKperf, my report is at
* http://www.thomas-krenn.com/de/wikiDE/images/5/52/TKperf-Report-IntelDCS3=
500.pdf

Regarding iodepth, I am using 1 job with 1 outstanding IO - as stated in th=
e specification -
to circumvent IO scheduler influences. I thought higher queue depths will a=
lways lead to=20
higher latencies, correct? (https://www.kernel.org/doc/Documentation/block/=
stat.txt)
Therefore testing with 1 nj/1 iod will generate comparable latency results,=
 or not?

Another question, is there a chance to turn off this cache?
It seems it is not the regular device write cache, as I turned it off with =
"hdparm -W"
and latencies seem to produce the same results (just on a quick test).

- Georg

