Return-Path: <fio-owner@vger.kernel.org>
Received: from dish-sg.nttdocomo.co.jp ([202.19.227.74]:13637 "EHLO
        dish-sg.nttdocomo.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbhDND2L (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Apr 2021 23:28:11 -0400
Subject: Re: [Question] Sequential mesuaring and filename option
References: <059fa98d-9088-5daa-834e-5c87d60bb836@nttcom.co.jp_1>
 <7875665d-82ca-2bf5-faf2-21c67dfc613e@criteo.com>
From: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Message-id: <6bf156f9-5771-0afe-92c5-d8bb1e04b69f@nttcom.co.jp_1>
Date: Wed, 14 Apr 2021 11:29:37 +0900
MIME-version: 1.0
In-reply-to: <7875665d-82ca-2bf5-faf2-21c67dfc613e@criteo.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-US
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2021/04/13 23:21, Erwan Velu wrote:
> Le 13/04/2021 à 08:13, Nakajima Akira a écrit :
>> Hi.
>>
>> I'm using fio for the first time. Sorry for the basic question.
>>
>> On RHEL 8.3
>> # fio -filename=/mnt/testfile -direct=1 -ioengine=libaio -rw=write
>> -bs=1m -size=5G -numjobs=1 -runtime=60 -group_reporting -name=test
>> IOPS=366, BW=366MiB/s
>>
>> But when -numjobs=10
>> IOPS=3358, BW=3358MiB/s
>> This is 5 times faster than the physical speed of the HDD I am using
>> (600MB/s).
>> Similar results are obtained with Sequential write.
>> Random read/write is fine.(Results are within 600MB/s)
>>
>> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Ffio.readthedocs.io%2Fen%2Flatest%2Ffio_man.html%23target-file-device&amp;data=04%7C01%7Ce.velu%40criteo.com%7Cdd41a8193e6048f16cc408d8fe441b34%7C2a35d8fd574d48e3927c8c398e225a01%7C1%7C1%7C637538915767435166%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;sdata=7jscmG7bnj%2BSBE%2BgbwVWNbz%2BTQhhckXAP%2Bl7xa%2F%2FuHo%3D&amp;reserved=0
>>
>> I refer above and use -directory=/mnt/testdir instead of -filename
>> gave good results.
>>
>> Am I using the -filename option incorrectly?
> 
> 
> Hey,
> 
> You are performing your benchmark against the filesystem which uses the
> memory as cache. So here, you are benchmarking your memory (which is
> correlated by the 3GB/sec speed).
> 
> You can use direct=1 to avoid using the buffer as per
> https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-type
> 
> If you want to test the disk itself, not the filesystem, it would be
> better to use the block device directly (/dev/sd<x>) and remove this
> unecessary layer.
> 
> Erwan,
> 

Hi.

I am using direct=1.
I'd like to test LUKS2 encryption speed, so need xfs/ext4 filesystem.

Thanks.
Nakajima.


