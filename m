Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f43.google.com ([209.85.166.43]:36753 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEFSy7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 May 2019 14:54:59 -0400
Received: by mail-io1-f43.google.com with SMTP id e19so2248834iob.3
        for <fio@vger.kernel.org>; Mon, 06 May 2019 11:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAPqbHXjNdcEwM_nfVaRu6BxVzg2HjBVZo0jdPGqJV=xw4=UHfw@mail.gmail.com>
 <CALjAwxgYk51y7hap2aHKwMrKWPjDdkS0CAyk=wf4-5DW6OaDwg@mail.gmail.com>
In-Reply-To: <CALjAwxgYk51y7hap2aHKwMrKWPjDdkS0CAyk=wf4-5DW6OaDwg@mail.gmail.com>
From: Prabhakaran <prabhugce@gmail.com>
Date: Mon, 6 May 2019 12:54:46 -0600
Message-ID: <CAPqbHXhjmOR5hfXbTYcDTjhqH=1HDVKGCe_FOwgd+udCEuCb1g@mail.gmail.com>
Subject: Re: Sequential Writes and Random Reads in parallel
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Sitsofe,

Looks like percentage_random option would not work, as I would be
needing IOPs log data for sequential and random separate. Your
alternate option, with having separate jobs and controlling the ratio
using flow, works fine. But, I'm seeing a significant performance drop
when flow is introduced, although random and sequential ratio looks
fine. Below is the comparison table with values in IOPs.

Rnd=3D50%, Seq=3D50%
----------------------------
[global]
ioengine=3Dlibaio
                                                      9
disable_slat=3D1
disable_lat=3D1
thread
cpus_allowed=3D0-7
cpus_allowed_policy=3Dsplit
direct=3D1
ramp_time=3D1m
runtime=3D5m
unified_rw_reporting=3D1
[seq_wr]
bs=3D128kb
ba=3D128kb
rw=3Dwrite
iodepth=3D256
time_based=3D1
log_avg_msec=3D0
refill_buffers
write_bw_log=3Dseq_wr
write_iops_log=3Dseq_wr
write_lat_log=3Dseq_wr
flow=3D-50
[rnd_rd]
bs=3D4kb
ba=3D4kb
rw=3Drandread
iodepth=3D256
time_based=3D1
log_avg_msec=3D0
randrepeat=3D0
norandommap
refill_buffers
write_bw_log=3Drnd_rd
write_iops_log=3Drnd_rd
write_lat_log=3Drnd_rd
flow=3D50

Output:
Rnd - 1318 iops
Seq - 1318 iops

Rnd=3D100%
---------------
[global]
ioengine=3Dlibaio
disable_slat=3D1
disable_lat=3D1
thread
cpus_allowed=3D0-7
cpus_allowed_policy=3Dsplit
direct=3D1
ramp_time=3D1m
runtime=3D5m
unified_rw_reporting=3D1
[rnd_rd]
bs=3D4kb
ba=3D4kb
rw=3Drandread
iodepth=3D256
time_based=3D1
log_avg_msec=3D0
randrepeat=3D0
norandommap
refill_buffers
write_bw_log=3Drnd_rd
write_iops_log=3Drnd_rd
write_lat_log=3Drnd_rd

Output:
Rnd - 204131 iops

As you can see, with pure random, the IOPs is at 204131. And when flow
is set to 50%, iops drops down to 1318 for random. I would expect
something like 100k iops for random as that workload is set to
function for 50%. Is my assumption wrong?

Thanks,
Prabhu

On Fri, 26 Apr 2019 at 02:06, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Fri, 26 Apr 2019 at 06:34, Prabhakaran <prabhugce@gmail.com> wrote:
> >
> > Hi,
> >
> > I=E2=80=99m trying to do both Random and Sequential operations simultan=
eously
> > in one job. In specific, I would like to do Sequential Writes and
> > Random Reads in parallel. Here is what I have got so far.
> >
> > [global]
> > ioengine=3Dlibaio
> > disable_slat=3D1
> > disable_lat=3D1
> > thread
> > direct=3D1
> >
> > [job2]
> > stonewall
> > bs=3D128kb,4kb
> > ba=3D128kb,4kb
> > rw=3Drandrw
> > iodepth=3D256
> > runtime=3D5s
> > time_based=3D1
> > log_avg_msec=3D0
> > randrepeat=3D0
> > norandommap
> > refill_buffers
> > write_bw_log=3Djob2
> > write_iops_log=3Djob2
> > write_lat_log=3Djob2
> > bs_is_seq_rand=3D1
> > rwmixread=3D1
> > percentage_random=3D50
> >
> > I=E2=80=99m assuming the above job would do 128k Sequential and 4k Rand=
om (50%
> > each), writes and reads (with reads=3D1%) combined for both Sequential
> > and Random, for 5s.
> > I=E2=80=99m still not able to do just Sequential Writes and Random Read=
s alone
> > in parallel.
> >
> > Thanks,
> > Prabhu
>
> percentage_random can be split into reads/writes/trims with commas
> (see https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-perc=
entage-random
> ) so that might help you out... Alternatively because you have a 50/50
> split you can use two separate jobs and tie them together with flow
> (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow
> ).
>
> --
> Sitsofe | http://sucs.org/~sits/

