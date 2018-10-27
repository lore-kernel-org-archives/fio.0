Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f170.google.com ([209.85.221.170]:35736 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbeJ1FQx (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 28 Oct 2018 01:16:53 -0400
Received: by mail-vk1-f170.google.com with SMTP id b207so1129936vke.2
        for <fio@vger.kernel.org>; Sat, 27 Oct 2018 13:34:42 -0700 (PDT)
MIME-Version: 1.0
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions>
 <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions>
 <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com> <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com>
 <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com> <555423228.215547.1540355274473@email.1and1.com>
 <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com>
 <C7097D32-CB26-49DF-BA3C-A52EAA5A361F@integritech.solutions>
 <D36925B2-A77A-47AD-BDD6-4A45558DC32E@emc.com> <2234B3B7-5680-4238-A48C-BED3EA5EA733@integritech.solutions>
 <000601d46d77$201945d0$604bd170$@integritech.solutions> <AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 27 Oct 2018 21:34:23 +0100
Message-ID: <CALjAwxiu6BUBF6JffLm-H19oYrs+nv6cX9QsTwJ9ij_LBq-5ZQ@mail.gmail.com>
Subject: Re: fio on vmware esxi
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: eliezer@integritech.solutions, Mark Beierl <Mark.Beierl@dell.com>, fio <fio@vger.kernel.org>

On Fri, 26 Oct 2018 at 23:30, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
> > I run FIO with the following parameters and used the different engines I listed above:
> > --randrepeat=1
> > --ioengine=posixaio
> > --direct=1
> > --sync=1
> > --name=mytest
> > --filename=mytestfile.fio
> >  --overwrite=1
> > --iodepth=64
> > --size=100MB
> > --readwrite=randrw
> > --rwmixread=50
> > --rwmixwrite=50
> >  --bs=16k
> >
> ...
> > -ioengine=psync on a 1000 IOPS Perf storage:::     read=177 write=185 IOPS
> > -ioengine=pvsync on a 1000 IOPS Perf storage:::    read=176 write=184 IOPS
> > -ioengine=sync on a 1000 IOPS Perf storage:::      read=145 write=152 IOPS
> > -ioengine=posixaio on a 1000 IOPS Perf storage:::  read=528 write=551 IOPS*
> >
> > Based on the FIO results I posted above, I've concluded that the suitable FIO engine for Block Storage
> > is "posixaio"; and for NFS it can be psync or pvsync or sync.
> > If I use the FIO engine "posixaio" on VMware to test block storage, I'm seeing the expected IOPS.
> > However, if I use the same FIO engine ("posixaio") to test NFS, I'm NOT seeing the expected IOPS.  I'd
> > have to use either psync, or pvsync, or sync to see the IOPS I'm expecting.
> >   These tests are on the same baremetal server running the version of VMWare I posted above.
> >
> > Can someone please shed some light on why FIO results is skewed when "posixaio" engine is used to test
> > an NFS storage?   The same goes with ioengines psync/pvsync/sync skews IOPS  results on a block
> > storage device?
>
> NFS might introduce all sorts of problems.  For the block device cases...
>
> Synchronous engines like sync do not honor the iodepth; you need to use
> jobs= to get multiple concurrent IOs.  posixaio is an  asynchronous engine,
> so it is honoring your iodepth (it spawns threads for you).
>
> Also, if your storage devices do any sort of buffering and caching, the
> tiny 100 MiB size is likely to result in lots of cache hits, distorting
> the results.

On the NFS front, perhaps you requesting direct=1 the kernel is
actually using synchronous buffered I/O behind the scenes and all
those syncs are slowing it down? Does using sync=0 show less of a
difference between engines?

-- 
Sitsofe | http://sucs.org/~sits/

