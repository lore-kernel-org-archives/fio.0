Return-Path: <erwan@enovance.com>
Message-ID: <54915786.3010009@enovance.com>
Date: Wed, 17 Dec 2014 11:14:30 +0100
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: SSD write latency lower than read latency
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com> <548EFB15.8080704@kernel.dk>
In-Reply-To: <548EFB15.8080704@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Le 15/12/2014 16:15, Jens Axboe a =C3=A9crit :
> Your guess is exactly right, that's what most flash based devices=20
> (worth their salt) do. That's also why sync write latencies are mostly=20
> independent of the type of nand used, whereas the read latency will=20
> easily reflect that.=20
But here the runtime is very limited to 60. I can imagine that if we=20
push the runtime to a longer time, the cache will not be enough to hide=20
the real latency of the device. The cache is said to be 1GB by=20
disassembling the device, maybe if we push the devices with bigger=20
iodepth & a longer run, maybe we can show the performance of the NAND :=20
once the cache is getting new data faster than it can write, the cache=20
will be more occupied, if we can achieve at feeding it completely then=20
we are done. I had the case with a poor MLC (128GB) that had 500MB of=20
SLC cache. On some pattern I was hitting the MLC at 5MB/sec ...

Note that in theirs specs, the write latency (65=C2=B5s) is very close to=
 the=20
read latency (50 =C2=B5s):
http://ark.intel.com/products/75679/Intel-SSD-DC-S3500-Series-160GB-2_5in=
-SATA-6Gbs-20nm-MLC

On the pdf=20
(http://www.intel.fr/content/dam/www/public/us/en/documents/product-speci=
fications/ssd-dc-s3500-spec.pdf),=20
we also see in the QoS sheet, that writes are said to be slower than=20
reads (up to 10x with iodepth=3D32).

