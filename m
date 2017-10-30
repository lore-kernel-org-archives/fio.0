Return-Path: <paolo.valente@linaro.org>
Return-Path: <paolo.valente@linaro.org>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: buffer-cache builds up with invalidate=1 too
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CALjAwxgSaC=KdBp1wY4zybsJ-gx6rs97eQYWfL3OgOU=6WjY3g@mail.gmail.com>
Date: Mon, 30 Oct 2017 07:57:52 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <1907D71B-3B75-49B2-BD09-43BA66FBDCA4@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org> <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com> <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org> <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com> <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org> <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk> <CAD7QDb2mYJzVUbscNq72MLYzD_cPish+=5S_fu9awxm7Sz+hzw@mail.gmail.com> <ECE9D641-A649-4B25-8088-CCA6DF4BCB57@linaro.org> <201bb045-c776-f3cc-a710-ab9bed32fada@kernel.dk> <B356CDFD-F114-4B95-A106-02BC94C77B31@linaro.org> <CALjAwxgSaC=KdBp1wY4zybsJ-gx6rs97eQYWfL3OgOU=6WjY3g@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> Il giorno 28 ott 2017, alle ore 17:04, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>=20
> On 28 October 2017 at 09:37, Paolo Valente <paolo.valente@linaro.org> =
wrote:
>>=20
>> Tested, it does solve the problem.  As a side note, and if useful for
>> you, the throughput is much higher with sequential reads and direct=3D0=

>> (4.14-rc5, virtual disk on an SSD).  It happens because of merges,
>> which seem to not occur with direct=3D1.  I thought direct I/O =
skipped
>> buffering, but still enjoyed features as request merging, but =
probably
>> I'm just wrong.
>>=20
>> Thanks for addressing this caching issue,
>> Paolo
>=20
> I think the window for merging is smaller but non-zero with direct=3D1 =
-
> remember all the I/Os must arrive close enough together to be merged
> and if fio is doing its submit one in each batch/send one new as soon
> as one completes default behaviour the odds of that happening are very
> small.

Exactly, as I wrote in my previous reply, I have of course seen this
problem with sync, and reported it too soon, sorry.

Thanks for your help,
Paolo



> Do you have an iodepth greater than one and are you using an
> async I/O engine? For example:
>=20
> dd if=3D/dev/zero of=3D/mnt/iotrace/fio.tmp bs=3D1M count=3D1 =
oflag=3Dsync
> fio --filename /mnt/iotrace/fio.tmp --size=3D1M --rw=3Dwrite
> --ioengine=3Dlibaio --direct=3D1 --bs=3D512 --iodepth 32 --name=3Dmerge
> --time_based --runtime=3D15s --iodepth=3D32 --iodepth_batch=3D32
> --iodepth_low=3D1
> [...]
> Disk stats (read/write):
>  sdb: ios=3D0/172944, merge=3D0/14619, ticks=3D0/286476, =
in_queue=3D286200, util=3D97.74%
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/


