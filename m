Return-Path: <fio-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37010 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeDQK2h (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Tue, 17 Apr 2018 06:28:37 -0400
Subject: Re: How to use ceph rados ioengine? How to config rados.job for
 parallel reading and writing?
References: <CAAOwsrdmf4HgJqVnGvz5GU58h-BrpHk1SnckWvYYsje2mOvhFg@mail.gmail.com>
 <CALjAwxj4un3+tPfFBX2Qscf9yJ68UWL3dbZJw5BW4QwKbhWBeg@mail.gmail.com>
From: Igor Fedotov <ifedotov@suse.com>
Message-ID: <1d19c53a-75bf-9198-ae42-3eb142c1c041@suse.com>
Date: Tue, 17 Apr 2018 13:28:25 +0300
MIME-Version: 1.0
In-Reply-To: <CALjAwxj4un3+tPfFBX2Qscf9yJ68UWL3dbZJw5BW4QwKbhWBeg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, =?UTF-8?B?6ams5bCR5qWg?= <shaonan.ma@gmail.com>

Hi Ma,

On 4/16/2018 11:23 AM, Sitsofe Wheeler wrote:
> (CC'ing Igor)
>
> On 16 April 2018 at 07:56, 马少楠 <shaonan.ma@gmail.com> wrote:
>> Hi List,
>>
>> I am a beginner, and now I am testing performance of rados of ceph. I
>> use the ioengine of rados but when I used the example in Github, the
>> ceph pool is empty as following:
>>
>> data:
>>      pools:   1 pools, 100 pgs
>>      objects: 0 objects, 0 bytes
>>      usage:   72611 MB used, 349 TB / 349 TB avail
>>      pgs:     100 active+clean
>>
>> $ ceph df
>> GLOBAL:
>>      SIZE     AVAIL     RAW USED     %RAW USED
>>      349T      349T       72611M          0.02
>> POOLS:
>>      NAME       ID     USED     %USED     MAX AVAIL     OBJECTS
>>      ecpool     1         0         0          221T           0
>>
>> And my configure file rados.job is as following:
>>
>> [global]
>> ioengine=rados
>> clientname=admin
>> pool=ecpool
>> busy_poll=0
>> rw=write
>> bs=4M
>>
>> [job1]
>> size=100G
>> io_size=100G
>> iodepth=2048
>>
>> I want to know whether the result that fio got could be considered
>> effective without any ojbect been written in the pool.
RADOS plugin performs a cleanup on completion and removes all the 
written objects.

You can check more detailed Ceph reports to see amount of data written 
to cluster, please try

ceph df detail

or

rados df


>> And I want to ask what I need to do if I want to test parallel reading
>> and write of rados. Should I create N pools in ceph and create N jobs
>> in fio configure file?
You can probably create multiple jobs operating on a single pool as well.
Or even try R/W mode within a single job (rw = rw or rw = randrw).

>> Thanks.
>>
>> Regards,
>> Shaonan Ma

