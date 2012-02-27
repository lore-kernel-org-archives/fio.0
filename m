Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <4F493E86.5080403@kernel.dk>
References: <CB6D6B02.7ADB1%ross@gridironsystems.com>
	<4F493E86.5080403@kernel.dk>
Date: Mon, 27 Feb 2012 12:56:22 -0800
Message-ID: <CAAK6Zt1iRA9NiiRVUAsvLaVbzBqEVzeAfP=UrUEf4Ese2PWBRQ@mail.gmail.com>
Subject: Re: Bug with small partitions?
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Ross Becker <ross@gridironsystems.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Nauman Rafique <nauman@google.com>
List-ID: <fio@vger.kernel.org>

On Sat, Feb 25, 2012 at 12:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-02-25 01:27, Ross Becker wrote:
>> I've found something very very odd, and I've tested it out and verified =
it
>> occurs with fio 1.54, 2.0.1 and 2.0.4.
>>
>> Host OS is Redhat 5.7, kernel version 2.6.18-274.17.1.el5
>>
>> I have 12 LUNs coming across fiber channel, each with multiple paths, an=
d
>> dm-multipath rolling them up into devices. =A0I partitioned them down to=
 100
>> megabytes each. =A0I then told fio to go do random 4k reads across the 1=
2
>> partitions; (/dev/mapper/somenamep1). =A0I had a 10 minute test specifie=
d,
>> and what occurred was that the time for the test to run started jumping
>> down dramatically each tick; it jumped from 10 minutes remaining to 3
>> minutes remaining to a minute and change, down to less than a minute. =
=A0I
>> cannot seem to get it to run for more than about 20 seconds, no matter
>> what I specify for the test run time. =A0I've been testing like this usi=
ng
>> the full size of the LUNs without any trouble. =A0I rebooted the system,
>> same behavior. =A0I created LVM volume groups and logical volumes (one
>> logical volume per volume group per LUN partition), and the same behavio=
r
>> occurred against those. =A0It's acting as if below a certain size, fio g=
ets
>> confused in it's timekeeping. =A0I used 1 gig partitions, and everything
>> worked normally. =A0Here's my fio config file that I'm getting these res=
ults
>> with:
>>
>> [global]
>> bs=3D4k
>> ioengine=3Dlibaio
>> iodepth=3D16
>> openfiles=3D1024
>> runtime=3D600
>> ramp_time=3D5
>> filename=3D/dev/mapper/dh0_extra_10p1:/dev/mapper/dh0_extra_11p1:/dev/ma=
pper/
>> dh0_extra_12p1:/dev/mapper/dh0_extra_20p1:/dev/mapper/dh0_extra_21p1:/de=
v/m
>> apper/dh0_extra_22p1:/dev/mapper/dh1_extra_30p1:/dev/mapper/dh1_extra_31=
p1:
>> /dev/mapper/dh1_extra_32p1:/dev/mapper/dh1_extra_40p1:/dev/mapper/dh1_ex=
tra
>> _41p1:/dev/mapper/dh1_extra_42p1
>>
>>
>>
>> [rand-read]
>> rw=3Drandread
>> numjobs=3D12
>> file_service_type=3Drandom
>> direct=3D1
>> disk_util=3D0
>> gtod_cpu=3D1
>> norandommap=3D1
>> thread
>> group_reporting
>
> So I tried reproducing this, by creating 12 100MB files and using those
> instead. The rest of the job file is the same. It seems to run as
> expected, and the ETA looks fairly accurate given the rate of IO that
> is going on. It shows 3min20sec from the get go, and it exits after 223
> seconds. So not too far off.
>
> The primary "problem" here is that you are probably expecting the
> runtime to be the runtime, when it is just a cap of the job. If the job
> finishes before the specified runtime, it exits. With the bigger
> partitions, this likely didn't happen for you. You want to add
> time_based=3D1 to force fio to keep going (it essentially restarts if it
> completes before time). If you do that, it should run the full 600
> seconds, as specified. It does here :-)
>
> --
> Jens Axboe
>

One issue I've seen with time_based tests is that opening and closing
the file can lead to a significant reduction in throughput. For my
tests, I have two options: make the file very large (what I'm
currently doing) and adding a new option to avoid opening and closing
the file on each iteration (what I'm planning, since it doesn't always
work to make the file larger). Are there any other recommendations? Is
there already an option for this?

Dan

