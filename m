Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14573713E0FDB73C2E788A9B8F400@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB145727ED714B57825C91A8E78F430@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxiXzC8ar21smWAOMadiAUSqeLECNpu1ZzTvc2t1e20VXg@mail.gmail.com> <BN3PR0401MB14573713E0FDB73C2E788A9B8F400@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 21 Oct 2017 05:21:39 +0100
Message-ID: <CALjAwxiXinxTL6jeSNNoMCmu5--5CKBdWapSX-hOQ2+KYCJ6Ng@mail.gmail.com>
Subject: Re: fio offset with ba
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hmm,

I see a few choices for trying to solve alignment of the offset and
forced alignment of sequential blocks:
* Introduce an "offset_align" option solely for aligning the "initial"
offset and stop trying to use blockalign in the offset. Document it
well to stop confusion with blockalign.
* Document blockalign as ONLY working for random I/O or
* Do blockalign for sequential I/O on a per I/O basis (potentially
creating gappy I/O). This is also the request from
https://github.com/axboe/fio/issues/341 . Technically this is has a
big overlap with zoned I/O and the existing "generated offset" used in
rw option but perhaps it's just different enough to be justified?

Thoughts?

On 21 October 2017 at 01:13, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Yes, the bits around line 845 show the min() being used.  It seems get_st=
art_offset() is used for the first IO and subsequent IO's, making things di=
fficult.  I believe the correct fix here would be to set the ba specific to=
 the io type.  The ba parameter allows for read/write/trim alignments.  So =
if io_u->ddir=3D=3DDDIR_READ then we could just align to o->ba[DDIR_READ]. =
 But I don't see how we would access io_u at this point, we don't know of t=
he potential io_u at this time?  It could be a mixed read/write/trim.
>
> Lacking that, brute force would suggest:
>
>                 if (fio_option_is_set(o, ba)) {
>                         align_bs =3D (unsigned long long) o->ba[DDIR_READ=
];
>                         if(o->ba[DDIR_READ] !=3D o->ba[DDIR_WRITE])
>                                 align_bs =3D (unsigned long long) o->ba[D=
DIR_READ] * (unsigned long long) o->ba[DDIR_WRITE];
>                         if(align_bs !=3D (unsigned long long) o->ba[DDIR_=
TRIM])
>                                 align_bs =3D align_bs * (unsigned long lo=
ng) o->ba[DDIR_TRIM];
>
> But I see another problem in that o->ba[DDIR_READ] is not set for sequent=
ial workloads.  In fixup_options() we have:
>
>         if (!o->ba[DDIR_READ] || !td_random(td))
>                 o->ba[DDIR_READ] =3D o->min_bs[DDIR_READ];
>         if (!o->ba[DDIR_WRITE] || !td_random(td))
>                 o->ba[DDIR_WRITE] =3D o->min_bs[DDIR_WRITE];
>         if (!o->ba[DDIR_TRIM] || !td_random(td))
>                 o->ba[DDIR_TRIM] =3D o->min_bs[DDIR_TRIM];
>
> I don't follow that code, other than if sequential, set ba to min_bs?  If=
 we remove that code and use above change, we can get the starting LBA to b=
e aligned to the ba in the case of
>
> fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Dread --iode=
pth=3D1 --size=3D100% --bs=3D4k --filename=3D/dev/nvme1n1 --number_ios=3D8 =
--offset=3D50% --log_offset=3D1 --write_iops_log=3Dtest_job --ba=3D8k
>
> # cat test_job_iops.1.log
> 0, 1, 0, 4096, 1600315899904
>
> It seems to be a hack, so I didn't create a patch for it.  Would like to =
better understand what I'm missing before breaking something.
>
> Thanks.
>
> Regards,
> Jeff
>
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Friday, October 20, 2017 2:01 PM
> To: Jeff Furlong <jeff.furlong@wdc.com>
> Cc: fio@vger.kernel.org
> Subject: Re: fio offset with ba
>
> Hi,
>
> On 20 October 2017 at 20:08, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>>
>> I don't quite follow the logic in the calculate offset function.  The of=
fset parameter recently allows a percentage.  Suppose we set it to 50% and =
want to block align the IO's starting at 50% of device capacity, then block=
 aligned to 8KB.
>>
>> # fio -version
>> fio-3.1-60-g71aa
>>
>> # blockdev --getsize64 /dev/nvme1n1
>> 3200631791616
>>
>> # fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Dread
>> --iodepth=3D1 --size=3D100% --bs=3D4k --filename=3D/dev/nvme1n1 --runtim=
e=3D1s
>> --offset=3D50% --log_offset=3D1 --write_iops_log=3Dtest_job --ba=3D8k
>>
>> # cat test_job_iops.1.log
>> 0, 1, 0, 4096, 1600315895808
>> 0, 1, 0, 4096, 1600315899904
>> 0, 1, 0, 4096, 1600315904000
>> 0, 1, 0, 4096, 1600315908096
>>
>> So we can see the device has 3200631791616 bytes, 50% of which is
>> 1600315895808 bytes, which happens to be 4KB aligned, but not 8KB
>> aligned.  Even though we set the --ba=3D8k parameter, the offset LBA as
>> logged in the iops.1.log shows
>
> Hmm I see the same problem with this job:
> fio --name=3Dtest_job --ioengine=3Dnull --rw=3Dread --iodepth=3D1
> --size=3D3200631791616 --bs=3D4k --number_ios=3D1 --offset=3D50% --ba=3D8=
k --debug=3Dio
>
> [...]
> io       15013 fill_io_u: io_u 0x236ad80:
> off=3D1600315895808/len=3D4096/ddir=3D0io       15013 /test_job.0.0io
> 15013
>
> I think your guess about only impacting random I/O is probably right beca=
use fio --name=3Dtest_job --randrepeat=3D0 --ioengine=3Dnull --rw=3Drandrea=
d
> --iodepth=3D1 --size=3D3200631791616 --bs=3D4k --number_ios=3D1 --offset=
=3D50% --ba=3D8k --debug=3Dio
>
> picks offsets that are 8k aligned.
>
>> 4KB alignment.  Does --ba work for all IO's or only random IO's?  If all=
, does get_start_offset() control the raw offset value?  I don't see why th=
e min(ba, bs) is used in the calculation, but perhaps I am missing somethin=
g.  Thanks.
>
> Where is min(ba, bs) done - do you mean the bits around https://github.co=
m/axboe/fio/commit/89978a6b26f81bdbd63228e2e2a86f604ee46c56#diff-4abbf03724=
6dd2e450dc3f6a2ac77180R845?
> I agree you probably want to take the maximum of all the block alignments=
 but what if one of the smaller ones is not a multiple of the largest one?
>
> Would you like to propose a patch?
>
> --
> Sitsofe | http://sucs.org/~sits/

--=20
Sitsofe | http://sucs.org/~sits/

