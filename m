Return-Path: <fio-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40081 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbbAIXBz convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 9 Jan 2015 18:01:55 -0500
From: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>
Subject: Re: REPORT: FIO random read performance degradation without
 "norandommap" option
Date: Fri, 9 Jan 2015 23:01:51 +0000
Message-ID: <D0D59CE2.FF94%andrey.o.kudryavtsev@intel.com>
References: <D0D596A1.FF42%andrey.o.kudryavtsev@intel.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A72F566@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <178A0E75ACB480438B5AB0602174383C@intel.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Robert, thanks for the reply.
That=EF=BF=BDs exactly confirms my findings. Any idea if LBA map is generat=
ed for
every job in case of multiple numjobs?

The fact of the performance recovery after degradation was completely
confusing too. I=EF=BF=BDm glad the solution was so easy.

Jens, are there any chance to add the note into the documentation?

--=20
Andrey Kudryavtsev,

SSD Solution Architect
Intel Corp.=20



On 1/9/15, 2:49 PM, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
wrote:

>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Kudryavtsev, Andrey O
>> Sent: Friday, 09 January, 2015 4:42 PM
>> To: fio@vger.kernel.org
>> Subject: REPORT: FIO random read performance degradation without
>> "norandommap" option
>>
>> Colleagues,
>> I executed 2-hour runs of 4KRR to understand performance changes across
>> the time on the specific very fast NVMe SSD with 1.6TB capacity.
>> I noticed the side effect of =EF=BF=BDnorandommap=EF=BF=BD parameter per=
forming full
>>span
>> test on the block device.
>> Here is the example of the result with random map (I.e. without
>> "norandommap" option) within 120 minutes windows.
>> [cid:E6872B64-35D1-4447-A0CF-32E6411D9BDB]
>> (IOPS in blue)
>>
>> As soon as I enabled =EF=BF=BDnorandommap=EF=BF=BD option the curve has =
changed into the
>> straight line as expected.
>
>It takes resources to maintain the random map table.  I always run with
>norandommap unless using verify, which has to remember which ones have
>been accessed.
>
>Here's a description I gave someone a while back:
>With a huge device (e.g., 5.8 TB from RAID-0 made from 16 SSDs),
>if you do not use "norandommap", fio allocates a bitmap for all
>the disk blocks to keep track of where it has read or written.
>It uses this to avoid accessing the same blocks until all
>the blocks have been accessed, and to know which blocks it
>needs to verify if verify=3D<something> is enabled.
>
>For 5.8 TB, that is 1562714136 =3D 1.5 GB.  Not many of those
>huge allocations work, so it
>* hangs the system for a while
>* generates estimates like
>        [eta 1158050440d:06h:50m:22s]
>* and eventually reports
>        smalloc: failed adding pool
>        fio: failed allocating random map. If running a large number of
>jobs, try the 'norandommap' option or set 'softrandommap'. Or give a
>larger --alloc-size to fio.
>
>fio continues to run after that; I think it verifies only
>the devices for which the allocation worked and ignores
>the rest.
>
>
>---
>Rob Elliott    HP Server Storage
>
>

