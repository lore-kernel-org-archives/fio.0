Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:44023 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbdKTRBJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Nov 2017 12:01:09 -0500
Received: by mail-yb0-f177.google.com with SMTP id q84so121644ybc.10
        for <fio@vger.kernel.org>; Mon, 20 Nov 2017 09:01:09 -0800 (PST)
MIME-Version: 1.0
Reply-To: dillaman@redhat.com
In-Reply-To: <034AAD465C6CBE4F96D9FB98573A79A62C2C933C@FMSMSX108.amr.corp.intel.com>
References: <034AAD465C6CBE4F96D9FB98573A79A62C2C92E0@FMSMSX108.amr.corp.intel.com>
 <CA+aFP1Bugm_HjOh=EusFSasx1rZucs7e7KHKD3Gq9o5VmnZ+Aw@mail.gmail.com> <034AAD465C6CBE4F96D9FB98573A79A62C2C933C@FMSMSX108.amr.corp.intel.com>
From: Jason Dillaman <jdillama@redhat.com>
Date: Mon, 20 Nov 2017 12:01:05 -0500
Message-ID: <CA+aFP1D03CVHACckU+M0LU0jP=CQNpFph8Ks+V1o+_aoskHE5Q@mail.gmail.com>
Subject: Re: [ceph-users] Poor libRBD write performance
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Moreno, Orlando" <orlando.moreno@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "ceph-users@lists.ceph.com" <ceph-users@lists.ceph.com>, "cbt@lists.ceph.com" <cbt@lists.ceph.com>

On Mon, Nov 20, 2017 at 12:00 PM, Moreno, Orlando
<orlando.moreno@intel.com> wrote:
> Hi Jason,
>
> You're right, thanks for pointing that out. I could've sworn I saw the same problem with exclusive-lock disabled, but after trying it again, disabling the feature does fix the write performance :)
>
> So does this mean that when an RBD is attached to a VM, it is considered a single client connection?

Yes, the VM (QEMU) is a single client to librbd.

> Thanks,
> Orlando
>
> -----Original Message-----
> From: Jason Dillaman [mailto:jdillama@redhat.com]
> Sent: Monday, November 20, 2017 9:10 AM
> To: Moreno, Orlando <orlando.moreno@intel.com>
> Cc: fio@vger.kernel.org; ceph-users@lists.ceph.com; cbt@lists.ceph.com
> Subject: Re: [ceph-users] Poor libRBD write performance
>
> I suspect you are seeing this issue [1]. TL;DR: never use "numjobs" >
> 1 against an RBD image that has the exclusive-lock feature enabled.
>
> [1] http://lists.ceph.com/pipermail/ceph-users-ceph.com/2016-August/012123.html
>
> On Mon, Nov 20, 2017 at 11:06 AM, Moreno, Orlando <orlando.moreno@intel.com> wrote:
>> Hi all,
>>
>>
>>
>> I’ve been experiencing weird performance behavior when using FIO RBD
>> engine directly to an RBD volume with numjobs > 1. For a 4KB random
>> write test at
>> 32 QD and 1 numjob, I can get about 40K IOPS, but when I increase the
>> numjobs to 4, it plummets to 2800 IOPS. I tried running the same exact
>> test on a VM using FIO libaio targeting a block device (volume)
>> attached through QEMU/RBD and I get ~35K-40K IOPS in both situations.
>> In all cases, CPU was not fully utilized and there were no signs of
>> any hardware bottlenecks. I did not disable any RBD features and most
>> of the Ceph parameters are default (besides auth, debug, pool size, etc).
>>
>>
>>
>> My Ceph cluster is running on 6 nodes, all-NVMe, 22-core, 376GB mem,
>> Luminous 12.2.1, Ubuntu 16.04, and clients running FIO job/VM on
>> similar HW/SW spec. The VM has 16 vCPU, 64GB mem, and the root disk is
>> locally stored while the persistent disk comes from an RBD volume
>> serviced by the Ceph cluster.
>>
>>
>>
>> If anyone has seen this issue or have any suggestions please let me know.
>>
>>
>>
>> Thanks,
>>
>> Orlando
>>
>>
>> _______________________________________________
>> ceph-users mailing list
>> ceph-users@lists.ceph.com
>> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
>>
>
>
>
> --
> Jason



-- 
Jason
