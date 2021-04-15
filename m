Return-Path: <fio-owner@vger.kernel.org>
Received: from dish-sg.nttdocomo.co.jp ([202.19.227.74]:27623 "EHLO
        dish-sg.nttdocomo.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhDOCqP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Apr 2021 22:46:15 -0400
Subject: Re: [Question] Sequential mesuaring and filename option
References: <059fa98d-9088-5daa-834e-5c87d60bb836@nttcom.co.jp_1>
 <7875665d-82ca-2bf5-faf2-21c67dfc613e@criteo.com>
 <6bf156f9-5771-0afe-92c5-d8bb1e04b69f@nttcom.co.jp_1>
 <CALjAwxj_-Q1HteM1MdcmxfeuAD54jvQMNpQi5Rt78sC-9ZRgHw@mail.gmail.com>
From: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Message-id: <f2e9d44d-9d1f-46a2-3112-a1982c559ac5@nttcom.co.jp_1>
Date: Thu, 15 Apr 2021 11:45:18 +0900
MIME-version: 1.0
In-reply-to: <CALjAwxj_-Q1HteM1MdcmxfeuAD54jvQMNpQi5Rt78sC-9ZRgHw@mail.gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-US
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Erwan Velu <e.velu@criteo.com>


On 2021/04/15 2:57, Sitsofe Wheeler wrote:
 >
 >
 > On Wed, 14 Apr 2021 at 13:21, Nakajima Akira 
<nakajima.akira@nttcom.co.jp <mailto:nakajima.akira@nttcom.co.jp>> wrote:
 >
 >     On 2021/04/13 23:21, Erwan Velu wrote:
 >      > Le 13/04/2021 à 08:13, Nakajima Akira a écrit :
 >      >> Hi.
 >      >>
 >      >> I'm using fio for the first time. Sorry for the basic question.
 >      >>
 >      >> On RHEL 8.3
 >      >> # fio -filename=/mnt/testfile -direct=1 -ioengine=libaio 
-rw=write
 >      >> -bs=1m -size=5G -numjobs=1 -runtime=60 -group_reporting 
-name=test
 >      >> IOPS=366, BW=366MiB/s
 >      >>
 >      >> But when -numjobs=10
 >      >> IOPS=3358, BW=3358MiB/s
 >      >> This is 5 times faster than the physical speed of the HDD I 
am using
 >      >> (600MB/s).
 >      >> Similar results are obtained with Sequential write.
 >      >> Random read/write is fine.(Results are within 600MB/s)
 >      >>
 >      >>
 > 
https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Ffio.readthedocs.io%2Fen%2Flatest%2Ffio_man.html%23target-file-device&amp;data=04%7C01%7Ce.velu%40criteo.com%7Cdd41a8193e6048f16cc408d8fe441b34%7C2a35d8fd574d48e3927c8c398e225a01%7C1%7C1%7C637538915767435166%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;sdata=7jscmG7bnj%2BSBE%2BgbwVWNbz%2BTQhhckXAP%2Bl7xa%2F%2FuHo%3D&amp;reserved=0
 > 
<https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Ffio.readthedocs.io%2Fen%2Flatest%2Ffio_man.html%23target-file-device&amp;data=04%7C01%7Ce.velu%40criteo.com%7Cdd41a8193e6048f16cc408d8fe441b34%7C2a35d8fd574d48e3927c8c398e225a01%7C1%7C1%7C637538915767435166%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;sdata=7jscmG7bnj%2BSBE%2BgbwVWNbz%2BTQhhckXAP%2Bl7xa%2F%2FuHo%3D&amp;reserved=0>
 >      >>
 >      >> I refer above and use -directory=/mnt/testdir instead of 
-filename
 >      >> gave good results.
 >      >>
 >      >> Am I using the -filename option incorrectly?
 >      >
 >      >
 >      > Hey,
 >      >
 >      > You are performing your benchmark against the filesystem which
 >     uses the
 >      > memory as cache. So here, you are benchmarking your memory 
(which is
 >      > correlated by the 3GB/sec speed).
 >      >
 >      > You can use direct=1 to avoid using the buffer as per
 >      > https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-type
 >     <https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-type>
 >      >
 >      > If you want to test the disk itself, not the filesystem, it 
would be
 >      > better to use the block device directly (/dev/sd<x>) and 
remove this
 >      > unecessary layer.
 >      >
 >      > Erwan,
 >      >
 >
 >     Hi.
 >
 >     I am using direct=1.
 >     I'd like to test LUKS2 encryption speed, so need xfs/ext4 filesystem.
 >
 >
 > I don't know if caching is happening nonetheless (maybe it will 
because the data has to be transformed before it can reach the disk due 
to encryption). One approach is to do I/O over an area three times that 
of your physical RAM (in your case you can just adjust size) to defeat 
the benefit of caching and to force flushing. Does that change the 
results at all?
 >
 > --
 > Sitsofe


Hi.

Sorry. Due to my company's email sender domain restrictions,
  it could not be sent to gmail.


Above is the result on unencrypted ext4/xfs.
Similar results are obtained on encrypted ext4/xfs.


Since the memory is 24GB, I tried it with 72GB + α = 76GB.

# fio -filename=/testfile -direct=1 -ioengine=libaio -rw=write -bs=1m 
-size=76G -runtime=60 -numjobs=1 -group_reporting -name=a
   write: IOPS=195, BW=195MiB/s (205MB/s)(11.4GiB/60023msec)

# fio -filename=/testfile -direct=1 -ioengine=libaio -rw=write -bs=1m 
-size=76G -runtime=60 -numjobs=10 -group_reporting -name=a
   write: IOPS=1622, BW=1622MiB/s (1701MB/s)(95.1GiB/60042msec)

# fio -filename=/testfile -direct=1 -ioengine=libaio -rw=write -bs=1m 
-size=76G -runtime=300 -numjobs=10 -group_reporting -name=a
   write: IOPS=1879, BW=1880MiB/s (1971MB/s)(551GiB/300004msec)


Up to numjobs = about 10, it increases in proportion to the value of 
numjobs.


Thanks.
Nakajima.


