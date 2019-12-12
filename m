Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41844 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbfLLIet (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Dec 2019 03:34:49 -0500
Received: by mail-wr1-f44.google.com with SMTP id c9so1714874wrw.8
        for <fio@vger.kernel.org>; Thu, 12 Dec 2019 00:34:47 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV5JBE_3rhk1o-x95gSxp3jTc7XrXridimgimAWgA6CdJA@mail.gmail.com>
In-Reply-To: <CAHEKYV5JBE_3rhk1o-x95gSxp3jTc7XrXridimgimAWgA6CdJA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 12 Dec 2019 08:34:51 +0000
Message-ID: <CALjAwxh-T=+gbLrJiKxte_R1uXCLgZpLP-R6o-e6OAOUDMmKMA@mail.gmail.com>
Subject: Re: Reading tech specs for a drive
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mauricio Tavares <raubvogel@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 11 Dec 2019 at 21:57, Mauricio Tavares <raubvogel@gmail.com> wrote:
>
> So I am trying to figure out why a hard drive I am testing using fio
> is not getting the same specs as the official ones. Hard drive in
> question is https://www.intel.com/content/www/us/en/products/memory-stora=
ge/solid-state-drives/data-center-ssds/dc-p4500-series/dc-p4500-4tb-aic-3d1=
.html

It's hard to say much without seeing your fio line and output but even
then it would be best to know what command line/job file Intel used
(if they did in fact use fio).

> 1. When it says "Random Read (100% Span)", does that mean
> rwmixread=3D100 reads while "Random Write (100% Span)" gives
> rwmixread=3D0?

Likely yes (or you could just not use rw=3Drandrw rwmixread=3D<foo> and
just use either rw=3Dread or rw=3Dwrite) but only Intel know for sure.

> 2. Is there a way to find out the other settings they used? Looking at
> https://software.intel.com/en-us/articles/evaluate-performance-for-storag=
e-performance-development-kit-spdk-based-nvme-ssd#inpage-nav-3
> they recommend for this hard drive
>
>   Intel SSD DC P4500 series: numjob=3D2, iodepth=3D256
>
> I do not know if that is for their spdk perf program or also fio. But
> further down on the same page they are talking about different
> blocksizes and iodepths for testing for IPS, bandwidth, and latency
> than the ones they recommended for the P4500 drive.

You'll have to ask them (maybe via the spdk mailing list -
https://lists.01.org/hyperkitty/list/spdk@lists.01.org/ ). I'll note
that page also says:

> Why is the performance obtained by perf better than that of fio?
>
> The biggest difference between the two tools is that fio is integrated wi=
th Linux* fio tools so that it can test SPDK devices with the fio_plugin en=
gine. However, due to the problem of fio's own architecture, SPDK can't be =
fully utilized. And the whole application framework of fio still uses its o=
wn architecture instead of SPDK application framework.
>
> [...] For example, in the thread model just mentioned, in perf, the threa=
d model provided by DPDK is used to bond the CPU core to the thread by usin=
g CPU affinity, which is no longer subject to kernel scheduling. Therefore,=
 the advantage of asynchronous lock-free can be fully exploited. This is wh=
y the performance measured by perf is higher than that of fio, especially w=
hen using a single thread (single core) to test multiple disks at the same =
time.

It's worth noting that fio can also "bond the CPU core to the thread
by using CPU affinity" (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-cpus-allowe=
d
) so there's probably more than is covered by that sentence. Dedicated
tools will always be able to beat fio but it would be nicer to have a
fuller explanation...

>
> And that confuses the hell out of me. =3D)
>
> They also mentioned preconditioning the hard drive. How is that done?

Preconditioning is done to reduce the impact of accidentally comparing
a "full" SSD (which will likely have a lot of garbage collection to
do) to an empty one (which should have very little garbage collection
to do). https://www.google.com/search?q=3Dssd+preconditioning turns up
some good links about it:
https://www.snia.org/sites/default/education/tutorials/2011/fall/SolidState=
/EstherSpanjer_The_Why_How_SSD_Performance_Benchmarking.pdf
and https://www.seagate.com/gb/en/tech-insights/lies-damn-lies-and-ssd-benc=
hmark-master-ti/
give a good background and
https://www.snia.org/sites/default/files/technical_work/PTS/SSS_PTS_2.0.1.p=
df
goes into great detail.

--=20
Sitsofe | http://sucs.org/~sits/

