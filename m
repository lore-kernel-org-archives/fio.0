Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:46537 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbeJ0Gh6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Oct 2018 02:37:58 -0400
From: <eliezer@integritech.solutions>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions> <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions> <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com> <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com> <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com> <555423228.215547.1540355274473@email.1and1.com> <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com> <C7097D32-CB26-49DF-BA3C-A52EAA5A361F@integritech.solutions> <D36925B2-A77A-47AD-BDD6-4A45558DC32E@emc.com> <2234B3B7-5680-4238-A48C-BED3EA5EA733@integritech.solutions>
In-Reply-To: <2234B3B7-5680-4238-A48C-BED3EA5EA733@integritech.solutions>
Subject: RE: fio on vmware esxi
Date: Fri, 26 Oct 2018 16:59:09 -0500
Message-ID: <000601d46d77$201945d0$604bd170$@integritech.solutions>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'Beierl, Mark'" <Mark.Beierl@dell.com>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>, 'fio' <fio@vger.kernel.org>

Mark, Sitsofe,

So I've been testing FIO on VMware using the different ioengines below and found something interesting.
-psync
-pvsync
-sync
-posixaio

The OS is a VMware ESXi:
VMware ESXi 6.5.0 build-8294253

FIO version compiled via Docker (thanks to Mark and Sitsofe):
fio-3.11-22-g425d

I mounted 3 storage devices (2 are different block storage types) on the same baremetal ESXi server:
-500 IOPS NFS
-1000 IOPS Reliant Tier iSCSI Block Storage
-1000 IOPS Perf Tier iSCSI Block Storage

I run FIO with the following parameters and used the different engines I listed above:
--randrepeat=1 
--ioengine=posixaio 
--direct=1 
--sync=1  
--name=mytest
--filename=mytestfile.fio
 --overwrite=1 
--iodepth=64 
--size=100MB 
--readwrite=randrw 
--rwmixread=50 
--rwmixwrite=50
 --bs=16k

Here are the results:

NFS:::
-ioengine=psync on a 500 IOPS NFS storage:::      read=245 write=256 IOPS*
-ioengine=pvsync on a 500 IOPS NFS Storage::::   read=252 write=263 IOPS*
-ioengine=sync on a 500 IOPS NFS Storage::::        read=258 write=270 IOPS*
-ioengine=posixaio on a 500 IOPS NFS Storage:::: read=172 write=180 IOPS

BLOCK STORAGE:::
1000 IOPS Reliant Tier
-ioengine=psync on a 1000 IOPS Reliant storage:::     read=249 write=260 IOPS
-ioengine=pvsync on a 1000 IOPS Reliant storage:::    read=321 write=335 IOPS
-ioengine=sync on a 1000 IOPS Reliant storage:::        read=236 write=246 IOPS
-ioengine=posixaio on a 1000 IOPS Reliant storage:::  read=535 write=559 IOPS*

1000 IOPS Perf Tier
-ioengine=psync on a 1000 IOPS Perf storage:::     read=177 write=185 IOPS
-ioengine=pvsync on a 1000 IOPS Perf storage:::    read=176 write=184 IOPS
-ioengine=sync on a 1000 IOPS Perf storage:::      read=145 write=152 IOPS
-ioengine=posixaio on a 1000 IOPS Perf storage:::  read=528 write=551 IOPS*

Based on the FIO results I posted above, I've concluded that the suitable FIO engine for Block Storage is "posixaio"; and for NFS it can be psync or pvsync or sync.
If I use the FIO engine "posixaio" on VMware to test block storage, I'm seeing the expected IOPS.  
However, if I use the same FIO engine ("posixaio") to test NFS, I'm NOT seeing the expected IOPS.  I'd have to use either psync, or pvsync, or sync to see the IOPS I'm expecting.
  These tests are on the same baremetal server running the version of VMWare I posted above.

Can someone please shed some light on why FIO results is skewed when "posixaio" engine is used to test an NFS storage?   The same goes with ioengines psync/pvsync/sync skews IOPS  results on a block storage device?

Thanks in advance.

Eliezer





