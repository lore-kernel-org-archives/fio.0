Return-Path: <jeff.furlong@hgst.com>
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: fio bw and iops logs broken
Date: Tue, 7 Jun 2016 16:50:18 +0000
Message-ID: <CY1PR0401MB146609693F20B1E27CCBDEB7F75D0@CY1PR0401MB1466.namprd04.prod.outlook.com>
References: <BN3PR0401MB14570C741575E615FE199142F75C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <57563A9F.8090906@kernel.dk> <57563EB7.70804@kernel.dk>
In-Reply-To: <57563EB7.70804@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Indeed, the fix in the current git resolves the issue.  Thanks.

Regards,
Jeff


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk] =

Sent: Monday, June 6, 2016 8:26 PM
To: Jeff Furlong <jeff.furlong@hgst.com>; fio@vger.kernel.org
Subject: Re: fio bw and iops logs broken

On 06/06/2016 09:08 PM, Jens Axboe wrote:
> On 06/06/2016 04:07 PM, Jeff Furlong wrote:
>> Hi All,
>> Somewhere between fio-2.11 and fio-2.11-14-gf031 the bw and iops logs =

>> no longer get written.
>>
>> # fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Dwrite
>> --iodepth=3D32 --size=3D100% --numjobs=3D1 --bs=3D1m --filename=3D/dev/n=
vme0n1 =

>> --group_reporting --write_bw_log=3Dtest_job --write_iops_log=3Dtest_job =

>> --write_lat_log=3Dtest_job --log_avg_msec=3D1000 --disable_lat=3D0
>> --disable_clat=3D0 --disable_slat=3D0 --runtime=3D10s --ramp_time=3D5s =

>> --output=3Dtest_job
>>
>> # ls -l
>> -rw-r--r--  1 root root 1537 Jun  6 15:01 test_job
>> -rw-r--r--  1 root root    0 Jun  6 15:01 test_job_bw.1.log
>> -rw-r--r--  1 root root  199 Jun  6 15:01 test_job_clat.1.log
>> -rw-r--r--  1 root root    0 Jun  6 15:01 test_job_iops.1.log
>> -rw-r--r--  1 root root  200 Jun  6 15:01 test_job_lat.1.log
>> -rw-r--r--  1 root root  254 Jun  6 15:01 test_job_slat.1.log
>>
>> See above file sizes of zero for the bw and iops logs.  However, =

>> lat/slat/clat are written.  Thoughts on which recent commit broke the =

>> functionality?  Thanks.
>
> I'll take a look.

Got broken earlier today, with the ramp time fix. The two functions have op=
posite return values... Current -git should work, this is the fix:

http://git.kernel.dk/cgit/fio/commit/?id=3D6a89b401289ef823c51760c71018b43d=
0c17532b

--
Jens Axboe

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality N=
otice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or l=
egally privileged information of WDC and/or its affiliates, and are intende=
d solely for the use of the individual or entity to which they are addresse=
d. If you are not the intended recipient, any disclosure, copying, distribu=
tion or any action taken or omitted to be taken in reliance on it, is prohi=
bited. If you have received this e-mail in error, please notify the sender =
immediately and delete the e-mail in its entirety from your system.


