Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:47527 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbeLBDx5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Dec 2018 22:53:57 -0500
Received: from JUNENHP640W7 ([76.30.173.5]) by mrelay.perfora.net (mreueus001
 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MZF1O-1go63F1TK8-00KvZ9 for
 <fio@vger.kernel.org>; Sat, 01 Dec 2018 17:41:01 +0100
From: <eliezer@integritech.solutions>
Subject: RE: fio 3.12-27g68af on vmware esxi 6.0 build causing segmentation fault
Date: Sat, 1 Dec 2018 10:40:57 -0600
Message-ID: <000101d48994$a3239410$e96abc30$@integritech.solutions>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'fio' <fio@vger.kernel.org>

Hello Folks:

Getting a "segmentation fault" error when running latest fio version
(3.12.27-g68af) on vmware 6.0:

> ./fio --bs=16k --size=10GB --readwrite=randrw --ioengine=posixaio
--filename=test10GB.fio --direct=1 --sync=1 --rwmixread=50 --rwmixwrite=50
--direct=1 --sync=1 --name=testvmw6 
testvmw6: (g=0): rw=randrw, bs=(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0KiB, (T)
16.0KiB-16.0KiB, ioengine=posixaio, iodepth=1
fio-3.12-27-g68af
Segmentation fault

On the following vmware version:
> vmware -v
VMware ESXi 6.0.0 build-5050593

Using fio version below:
> ./fio -version
fio-3.12-27-g68af

> ./fio --enghelp
Available IO engines:
        cpuio
        mmap
        sync
        psync
        vsync
        pvsync
        pvsync2
        null
        net
        netsplice
        ftruncate
        filecreate
        posixaio
        falloc
        e4defrag
        splice
        mtd
        sg

FIO binary built from Docker using the following Dockerfile (Kudos to Mark
Beierl!)

===
FROM multiarch/alpine:x86_64-v3.6 (--- I also tried v3.8 ---)

RUN apk --no-cache add --update \
    git \
    alpine-sdk \
    coreutils \
    linux-headers \
    libaio \
    libaio-dev \
    zlib-dev

RUN git clone http://git.kernel.dk/fio.git fio
RUN cd fio && ./configure --esx
RUN cd fio && EXTFLAGS="-static" make -j $(grep -c ^processor /proc/cpuinfo)
install
===

Do I need to use an older fio version and Dockerfile config to run fio on
vmware 6.0, or is the segmentation error due to something else?  Not sure
how to debug this further.  Any insight how to debug this further is very
much appreciated.

Regards,
Eliezer


