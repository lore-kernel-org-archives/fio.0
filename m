Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51617 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaABREZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Jan 2014 12:04:25 -0500
Received: by mail-qa0-f48.google.com with SMTP id w5so13464886qac.0
        for <fio@vger.kernel.org>; Thu, 02 Jan 2014 09:04:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C58868.4050800@nellans.org>
References: <266864ba.12fb3.1435264174a.Coremail.tech8891@163.com>
	<52C58868.4050800@nellans.org>
Date: Thu, 2 Jan 2014 12:04:24 -0500
Message-ID: <CABFR9T32n5c-9DSVzUvviHoUOJs4OxiZKBJvb-85Ax1-uxsVRA@mail.gmail.com>
Subject: Re: very unstable IOPS in the same test on the same machine
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO <fio@vger.kernel.org>

On Thu, Jan 2, 2014 at 10:40 AM, David Nellans <david@nellans.org> wrote:
>
>> Problem summary:
>>   The IOPS is very unstable since I changed the number of  jobs from 2 to
>> 4.  even I changed it back,  the IOPS performance also can't return back.
>> # cat 1.fio
>> [global]
>> rw=randread
>> size=128m
>>
>> [job1]
>>
>> [job2]
>>
>> when I run fio 1.fio,  the iops is around 31k.  and then I add the
>> following 2 entries:
>> [job3]
>>
>> [job4]
>>
>> The IOPS dropped to around 1k.
>>
>> Even I remove these 2 jobs,  the IOPS still be around 1k.
>>
>> Only if  I removed all the jobn.n.0 files,  and re-run with 2 jobs
>> setting,  the IOPS can be 31k again.
>
>
>> # bash blkinfo.sh  /dev/sda
>> Vendor     : LSI
>> Model      : MR9260-8i
>> Nr_request : 128
>> rotational : 1
>
>
> It looks like you're testing against a LSI megaraid SAS controller, which
> presumably has magnetic drives attached.  When you add more jobs to your
> config its going to cause the heads on the drives (you don't say how many
> you have) to thrash more as they try and interleave requests that are going
> to land on different portions of the disk.  So its not unsurprising that
> you'll see IOPS drop off.
>
> A lot of how and where the IOPS will drop off is going to depend on the raid
> config of the drives you have attached to the controller however. Generally
> speaking 31k IOPS at 128MB I/O's (which will be split into
> something smaller like 1MB typically) is well beyond what you should expect
> 8 HDD's to do unless you're getting lots of hits in the DRAM buffer on the
> raid controller. Enterprise HDD's (even 15k ones) generally can only sustain
> <= 250 random read IOPS, so even with perfect interleaving on an 8 drive
> raid-0, 31k seem suspicious, 1k seems perfectly realistic however!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Just a point of observation, if we are talking a raid device which the
MR9260 does appear to be then you open a very large set of
permutations/combinations for settings that will impact performance.

In general if your talking 128M for one job then that Job in theory
can fit into the cache of the raid controller.  Performance there can
be nice and snappy.  The second you go beyond what fits in the cache
on the raid controller your performance is going to start dropping
rapidly.  By going to multiple jobs using random IO you pretty much
run the risk of negating the raid cache all together, which may be
whats causing your sudden drop off.

A useful starting point may be to disable read and write cache on your
arrays and re-run your performance so you can get a baseline of what
your disks can do and then turn caching back on and re-run the tests
and compare them.

Heres a list of things that I can think of that drive the # of
permutations/combinations.
# of disks involved (do you have enough to saturate the pci lane)
# of disks on each expander on the raid adapter (do you have enough
disks to saturate the expander on the card, assuming the card has 1
expander per channel)
SAS vs SATA (obvious performance difference between the devices, not
to mention SATA really isnt as fast)
chunk/stripe size (you should tailor this to match the data transfer
sizes, but sometimes raid code just works better for one vs another)
disk cache enabled vs disabled (if your running raid you should have
disk cache disabled but that causes SATA performance to normally tank,
you disable the cache since during any sort of power outage the raid
cache code cant tell if the data made it to the media or not, ie data
corruption issue)
raid cache size, read enabled and or write enabled vs disabled (more
cache is usually better and turning it on for reads and writes usually
helps but raid code can have goofey default values if you dont have a
battery installed)
raid type (some raid types lend themselves to better performance than
others, more than likely raid 0 is usually the fastest)
transfer size of data (if your sending down 512 byte chunks of data
thats a bunch of work vs 16k etc ... theres usually a sweetspot for
iops vs transfer size)
read vs write of the data (reads tend to be quicker than writes though
if your dealing strictly with ram that changes the difference)
random vs sequential of the data (sequential is usually faster by a
long shot, though as you increase the # of jobs you run the risk of
making the raid code think its random data)

Peace,
Roger
