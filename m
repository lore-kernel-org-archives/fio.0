Return-Path: <fio-owner@vger.kernel.org>
Received: from mx142.netapp.com ([216.240.21.19]:58165 "EHLO mx142.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbcBDXSU convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 4 Feb 2016 18:18:20 -0500
From: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO and replay_redirect
Date: Thu, 4 Feb 2016 23:17:52 +0000
Message-ID: <D2D945ED.1CD41%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D2D93BA8.1CCD9%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CAB-428=5_5Hohz0hYfapx9g9y1Wwx_RhX8fF3rex=W3jZ5kVgQ@mail.gmail.com>
In-Reply-To: <CAB-428=5_5Hohz0hYfapx9g9y1Wwx_RhX8fF3rex=W3jZ5kVgQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F6CBFF33F760A43A13B0FDF3F478CAC@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>



On 2/4/16, 6:11 PM, "Alireza Haghdoost" <alireza@cs.umn.edu> wrote:

>On Thu, Feb 4, 2016 at 4:32 PM, neto from Brazil
><Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>> Hi All,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> I have captured a blktrace from an Oracle workload. 18 dm devices.
>>
>> Steps to capture:
>>
>> blktrace <device 0> <device 1> ... -w 40
>> blkparse -i <device 0> -i <device 1> ... -o /dev/null -d
>>oracle_trace.out
>>
>> Trying to replay with FIO (here I have 2 devices - /dev/sdh and
>>/dev/sdi)
>>
>> Testing with one device:
>>
>> [workload]
>> ioengine=libaio
>> iodepth=1
>> size=100g
>> numjobs=1
>> direct=1
>> thread
>> read_iolog=/root/traces/oracle-s144/oracle_trace.out
>> replay_no_stall=1
>> replay_redirect=/dev/sdh
>>
>> [root@oraperf1 fio]# ./fio oracle-replay.cfg
>> workload: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio,
>>iodepth=1
>> fio-2.2.9-26-g669e
>> Starting 1 thread
>> fio: ioengines.c:422: td_io_open_file: Assertion `!fio_file_open(f)'
>> failed.
>> Aborted (core dumped)
>>
>>
>>
>>
>>
>> Questions:
>>
>> 1) The workload that I capture, all DM devices have 200GB size. My
>>devices
>> where I want to replay have 100GB. I believe I will need to match the
>>size
>> of all disks (where I captured the workload) with the destination where
>>I
>> am going to replay. For example: If I capture a workload with 18 LUNs
>> 200GB, to replay I need to have 18 LUNs with 200GB minimum.
>
>That is right. Your best bet to create one 100GB partition on each one
>of those 200GB DMs. Therefore, physically you have 200GB DM. However,
>the workload only goes to the first 100GB. Then capture new trace and
>try to replay your new trace.
>
>>
>> 2) I need to replay to more than one device. How can I do that with fio?
>> Seems to me replay_redirect is for a single specified device.
>
>replay with btreplay or blkreplay instead of fio.
>
>> 3) Any help why I am getting that error? fio: ioengines.c:422:
>> td_io_open_file: Assertion `!fio_file_open(f)' failed.
>>
>> Thank you very much for all help.
>>
>> All the best
>>
>> neto
>>


Hi Alireza,

This is neto from Brazil

How are you?

Actually I have to reply with FIO and I will explain why... :-)

The workload that I have been generating is HIGHLY compressible and I
would like to use FIO to control the % of the compressible for the
workload. Unfortunately, I won't be able to do that with blkreplay.

Thanks for your reply.

Thanks

neto

