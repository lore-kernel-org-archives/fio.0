Return-Path: <prvs=386b976bd=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/7] zbd: introduce per-device "max_open_zones" limit
Date: Mon, 4 May 2020 01:41:14 +0000
Message-ID: 
 <BY5PR04MB690028920E402F350BD5FDD6E7A60@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-3-adobriyan@gmail.com>
 <BY5PR04MB690042CF7A2990BE21B0DBCDE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200501185208.GB32674@avx2>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Alexey,=0A=
=0A=
On 2020/05/02 3:52, Alexey Dobriyan wrote:=0A=
> On Fri, May 01, 2020 at 01:34:32AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/04/30 21:41, Alexey Dobriyan wrote:=0A=
>>> It is not possible to maintain equal per-thread iodepth. The way code=
=0A=
>>> is written, "max_open_zones" acts as a global limit, and one thread=0A=
>>> opens all "max_open_zones" for itself and others starve for available=
=0A=
>>> zones and _exit_ prematurely.=0A=
>>>=0A=
>>> This config is guaranteed to make equal number of zone resets/IO now:=
=0A=
>>> each thread generates identical pattern and doesn't intersect with othe=
r=0A=
>>> threads:=0A=
>>>=0A=
>>> 	zonemode=3Dzbd=0A=
>>> 	zonesize=3D...=0A=
>>> 	rw=3Dwrite=0A=
>>>=0A=
>>> 	numjobs=3DN=0A=
>>> 	offset_increment=3DM*zonesize=0A=
>>>=0A=
>>> 	[j]=0A=
>>> 	size=3DM*zonesize=0A=
>>>=0A=
>>> Patch introduces "global_max_open_zones" which is per-device config=0A=
>>> option. "max_open_zones" becomes per-thread limit. Both limits are=0A=
>>> checked for each open zone so one thread can't starve others.=0A=
>>=0A=
>> It makes sense. Nice one.=0A=
>>=0A=
>> But the change as is will break existing test scripts (e.g. lots of SMR =
drives=0A=
>> are being tested with this).=0A=
> =0A=
> It won't break single-threaded ones, that's for sure.=0A=
=0A=
Yes, but things like:=0A=
=0A=
fio --ioengine=3Dpsync --rw=3Drandwr --max_open_zones=3D128 --numjobs=3D32=
=0A=
=0A=
will change behavior. With your change, instead of 32 threads writing rando=
mly=0A=
to a total of 128 zones, you will get 32 threads each writing randomly to 1=
28=0A=
zones, with a total of 32*128=3D4096 zones.=0A=
=0A=
SMR drives and zonemode=3Dzbd have now been around for a while and there ar=
e a lot=0A=
of fio scripts deployed in production for system validation/tests, as well =
as in=0A=
drive development for testing. If we can avoid breaking that, we absolutely=
 must.=0A=
=0A=
My proposal to keep max_open_zones as the per device maximum and introducin=
g a=0A=
thread_max_open_zones limit keeps backward compatibility with existing scri=
pts=0A=
while still allowing your change.=0A=
=0A=
> =0A=
>> I think we can avoid this breakage simply: leave=0A=
>> max_open_zones option definition as is and add "job_max_open_zones" or=
=0A=
>> "thread_max_open_zones" option (no strong feelings about the name here, =
as long=0A=
>> as it is explicit) to define the per thread maximum number of open zones=
. This=0A=
>> new option could actually default to max_open_zones / numjobs if that is=
 not 0.=0A=
> =0A=
> I'd argue that such scripts are broken.=0A=
=0A=
See the above example. It is a perfectly valid script, not broken at all.=
=0A=
Varying the number of max_open_zones allows measuring the performance varia=
tion=0A=
of a drive with the number of implicitly open zones. It is a common one tha=
t I=0A=
have seen a lot in drive development and production. There are likely other=
=0A=
valid ones too. Assuming that all current uses of max_open_zones with multi=
-jobs=0A=
workloads are broken would be a mistake.=0A=
=0A=
> =0A=
> If sustained numjobs*max_open_zones QD is desired than it is not=0A=
> guaranteed as threads will simply exit at indeterminate times,=0A=
> which break LBA space coverage as well.=0A=
> =0A=
> Right now, numjobs=3D + max_open_zones=3D means "max open zones by at mos=
t=0A=
> "numjobs" threads.=0A=
=0A=
I understand that. And we should keep it that way for the reasons mentioned=
=0A=
above. Modifying your change with the option thread_max_open_zones will nic=
ely=0A=
enhance. E.g.=0A=
=0A=
fio --ioengine=3Dlibaio --iodepth=3D8 --rw=3Drandwr --thread_max_open_zones=
=3D1 --numjobs=3D8=0A=
=0A=
Will result in 8 threads writing a single randomly chosen zone at QD=3D8. A=
nd that=0A=
is the same as your proposed:=0A=
=0A=
fio --ioengine=3Dlibaio --iodepth=3D8 --rw=3Drandwr --max_open_zones=3D1 --=
numjobs=3D8=0A=
=0A=
but without breaking the existing meaning of max_open_zones as a per drive/=
file=0A=
limit.=0A=
=0A=
I totally agree with your change. It is a nice one. But let's preserve=0A=
max_open_zones meaning as the per device limit. No need to change it.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
=0A=
=0A=

