Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34030 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbdKTQKQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Nov 2017 11:10:16 -0500
Received: by mail-yw0-f176.google.com with SMTP id k191so4477344ywe.1
        for <fio@vger.kernel.org>; Mon, 20 Nov 2017 08:10:16 -0800 (PST)
MIME-Version: 1.0
Reply-To: dillaman@redhat.com
In-Reply-To: <034AAD465C6CBE4F96D9FB98573A79A62C2C92E0@FMSMSX108.amr.corp.intel.com>
References: <034AAD465C6CBE4F96D9FB98573A79A62C2C92E0@FMSMSX108.amr.corp.intel.com>
From: Jason Dillaman <jdillama@redhat.com>
Date: Mon, 20 Nov 2017 11:10:15 -0500
Message-ID: <CA+aFP1Bugm_HjOh=EusFSasx1rZucs7e7KHKD3Gq9o5VmnZ+Aw@mail.gmail.com>
Subject: Re: [ceph-users] Poor libRBD write performance
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Moreno, Orlando" <orlando.moreno@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "ceph-users@lists.ceph.com" <ceph-users@lists.ceph.com>, "cbt@lists.ceph.com" <cbt@lists.ceph.com>

I suspect you are seeing this issue [1]. TL;DR: never use "numjobs" >
1 against an RBD image that has the exclusive-lock feature enabled.

[1] http://lists.ceph.com/pipermail/ceph-users-ceph.com/2016-August/012123.html

On Mon, Nov 20, 2017 at 11:06 AM, Moreno, Orlando
<orlando.moreno@intel.com> wrote:
> Hi all,
>
>
>
> I’ve been experiencing weird performance behavior when using FIO RBD engine
> directly to an RBD volume with numjobs > 1. For a 4KB random write test at
> 32 QD and 1 numjob, I can get about 40K IOPS, but when I increase the
> numjobs to 4, it plummets to 2800 IOPS. I tried running the same exact test
> on a VM using FIO libaio targeting a block device (volume) attached through
> QEMU/RBD and I get ~35K-40K IOPS in both situations. In all cases, CPU was
> not fully utilized and there were no signs of any hardware bottlenecks. I
> did not disable any RBD features and most of the Ceph parameters are default
> (besides auth, debug, pool size, etc).
>
>
>
> My Ceph cluster is running on 6 nodes, all-NVMe, 22-core, 376GB mem,
> Luminous 12.2.1, Ubuntu 16.04, and clients running FIO job/VM on similar
> HW/SW spec. The VM has 16 vCPU, 64GB mem, and the root disk is locally
> stored while the persistent disk comes from an RBD volume serviced by the
> Ceph cluster.
>
>
>
> If anyone has seen this issue or have any suggestions please let me know.
>
>
>
> Thanks,
>
> Orlando
>
>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
>



-- 
Jason
