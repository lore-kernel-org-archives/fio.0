Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:59797 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbeJ0HXi (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Oct 2018 03:23:38 -0400
From: <eliezer@integritech.solutions>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions> <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions> <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com> <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com> <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com> <555423228.215547.1540355274473@email.1and1.com> <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com> <C7097D32-CB26-49DF-BA3C-A52EAA5A361F@integritech.solutions> <D36925B2-A77A-47AD-BDD6-4A45558DC32E@emc.com> <2234B3B7-5680-4238-A48C-BED3EA5EA733@integritech.solutions> <000601d46d77$201945d0$604bd170$@integritech.solutions> <AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB11690CF299A451394CCC5640ABF00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Subject: RE: fio on vmware esxi
Date: Fri, 26 Oct 2018 17:44:40 -0500
Message-ID: <000801d46d7d$7bf23f00$73d6bd00$@integritech.solutions>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'Elliott, Robert (Persistent Memory)'" <elliott@hpe.com>, "'Beierl, Mark'" <Mark.Beierl@dell.com>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>, 'fio' <fio@vger.kernel.org>

Thanks for the quick feedback Robert.  I appreciate it.

I forgot to add,  when I created a new NFS datastore in VMware ESXi 6.5 I have to NFS versions to choose from:

-NFS 3 allows the datastore to be accessed by ESX/ESXi hosts of version earlier than 6.0
-NFS 4.1 provides multipathing for servers and supports the Kerberos authentication protocol

The results FIO results I posted were from NFS v.3. so I continued testing...

I unmounted that NFS volume and remounted it as a new datastore using NFS v4.1 and I'm now showing the expected IOPS using the "posixaio" engine on NFS!  Great!

So, use "posixaio" FIO engine on NFS v 4.1;  don’t use "posixaio" engine on NFS v 3.

Eliezer 

-----Original Message-----
From: Elliott, Robert (Persistent Memory) [mailto:elliott@hpe.com] 
Sent: Friday, October 26, 2018 5:30 PM
To: 'eliezer@integritech.solutions'; 'Beierl, Mark'
Cc: 'Sitsofe Wheeler'; 'fio'
Subject: RE: fio on vmware esxi


> I run FIO with the following parameters and used the different engines I listed above:
> --randrepeat=1
> --ioengine=posixaio
> --direct=1
> --sync=1
> --name=mytest
> --filename=mytestfile.fio
>  --overwrite=1
> --iodepth=64
> --size=100MB
> --readwrite=randrw
> --rwmixread=50
> --rwmixwrite=50
>  --bs=16k
> 
...
> -ioengine=psync on a 1000 IOPS Perf storage:::     read=177 write=185 IOPS
> -ioengine=pvsync on a 1000 IOPS Perf storage:::    read=176 write=184 IOPS
> -ioengine=sync on a 1000 IOPS Perf storage:::      read=145 write=152 IOPS
> -ioengine=posixaio on a 1000 IOPS Perf storage:::  read=528 write=551 IOPS*
> 
> Based on the FIO results I posted above, I've concluded that the suitable FIO engine for Block Storage
> is "posixaio"; and for NFS it can be psync or pvsync or sync.
> If I use the FIO engine "posixaio" on VMware to test block storage, I'm seeing the expected IOPS.
> However, if I use the same FIO engine ("posixaio") to test NFS, I'm NOT seeing the expected IOPS.  I'd
> have to use either psync, or pvsync, or sync to see the IOPS I'm expecting.
>   These tests are on the same baremetal server running the version of VMWare I posted above.
> 
> Can someone please shed some light on why FIO results is skewed when "posixaio" engine is used to test
> an NFS storage?   The same goes with ioengines psync/pvsync/sync skews IOPS  results on a block
> storage device?

NFS might introduce all sorts of problems.  For the block device cases...

Synchronous engines like sync do not honor the iodepth; you need to use
jobs= to get multiple concurrent IOs.  posixaio is an  asynchronous engine, 
so it is honoring your iodepth (it spawns threads for you).

Also, if your storage devices do any sort of buffering and caching, the
tiny 100 MiB size is likely to result in lots of cache hits, distorting
the results.

---
Robert Elliott, HPE Persistent Memory




