Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751701AbdKTQQO (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Nov 2017 11:16:14 -0500
Subject: Re: [Cbt] Poor libRBD write performance
References: <034AAD465C6CBE4F96D9FB98573A79A62C2C92E0@FMSMSX108.amr.corp.intel.com>
From: Mark Nelson <mnelson@redhat.com>
Message-ID: <8024d5cc-daeb-be4a-5f88-28d91e69d46e@redhat.com>
Date: Mon, 20 Nov 2017 10:16:12 -0600
MIME-Version: 1.0
In-Reply-To: <034AAD465C6CBE4F96D9FB98573A79A62C2C92E0@FMSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Moreno, Orlando" <orlando.moreno@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "ceph-users@lists.ceph.com" <ceph-users@lists.ceph.com>
Cc: "'cbt@lists.ceph.com'" <cbt@lists.ceph.com>

On 11/20/2017 10:06 AM, Moreno, Orlando wrote:
> Hi all,
>
>
>
> I=EF=BF=BDve been experiencing weird performance behavior when using FIO =
RBD
> engine directly to an RBD volume with numjobs > 1. For a 4KB random
> write test at 32 QD and 1 numjob, I can get about 40K IOPS, but when I
> increase the numjobs to 4, it plummets to 2800 IOPS. I tried running the
> same exact test on a VM using FIO libaio targeting a block device
> (volume) attached through QEMU/RBD and I get ~35K-40K IOPS in both
> situations. In all cases, CPU was not fully utilized and there were no
> signs of any hardware bottlenecks. I did not disable any RBD features
> and most of the Ceph parameters are default (besides auth, debug, pool
> size, etc).
>
>
>
> My Ceph cluster is running on 6 nodes, all-NVMe, 22-core, 376GB mem,
> Luminous 12.2.1, Ubuntu 16.04, and clients running FIO job/VM on similar
> HW/SW spec. The VM has 16 vCPU, 64GB mem, and the root disk is locally
> stored while the persistent disk comes from an RBD volume serviced by
> the Ceph cluster.
>
>
>
> If anyone has seen this issue or have any suggestions please let me know.

Hi Orlando,

Try seeing if disabling the RBD image exclusive lock helps (if only to=20
confirm that's what's going on).  I usually test with numjobs=3D1 and run=20
multiple fio instances with higher iodepth values instead to avoid this.=20
  See:

https://www.spinics.net/lists/ceph-devel/msg30468.html

and

http://lists.ceph.com/pipermail/ceph-users-ceph.com/2015-September/004872.h=
tml

Mark

>
>
>
> Thanks,
>
> Orlando
>
>
>
> _______________________________________________
> Cbt mailing list
> Cbt@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/cbt-ceph.com
>
