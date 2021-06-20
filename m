Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhFTRNK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 20 Jun 2021 13:13:10 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DB5C061574
        for <fio@vger.kernel.org>; Sun, 20 Jun 2021 10:10:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a11so16871293wrt.13
        for <fio@vger.kernel.org>; Sun, 20 Jun 2021 10:10:56 -0700 (PDT)
MIME-Version: 1.0
References: <DM6PR11MB475596F3188D1B1EE8D9F54FA9219@DM6PR11MB4755.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB475596F3188D1B1EE8D9F54FA9219@DM6PR11MB4755.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 20 Jun 2021 18:10:28 +0100
Message-ID: <CALjAwxi5UBBh8PKWWviPb_YokZxePVi03iMfGkpAh-HPD9t6tw@mail.gmail.com>
Subject: Re: Too Many Open Files
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Sat, 29 May 2021 at 16:03, Gruher, Joseph R
<joseph.r.gruher@intel.com> wrote:
>
> I have a 72-core server running CentOS 8, kernel 4.18.0-240, with FIO 3.2=
7.  I have 12 NVMe drives, each with 12 partitions, and am trying to run mu=
ltiple jobs for each partition, with numjobs=3D16 and iodepth=3D32.  I get =
a too many open files error from FIO.  Which is fine, that's a lot of threa=
ds.  If I change numjobs to 8, same error, if I change it to 4, FIO runs.  =
Is there a hard or dynamic limit in FIO, and if so, what is it, or how is i=
t calculated?  Thanks!
>
>
> [global]
> ioengine=3Dlibaio
> direct=3D1
> randrepeat=3D0
> thread=3D1

In this case I don't think you're hitting an fio limit but your system
likely has limits (e.g. a global maximum and a seperate per process
limit). I'm guessing 12 (disks) * 12 (partitions) * 16 (jobs) =3D 2304
files. 12 * 12 * 8 =3D 1152 files. The fact that 4 worked makes me think
you have some per user or per process limit which is a number like
1024. Does the information in https://unix.stackexchange.com/q/84227
help?


--
Sitsofe

