Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbcKJGWw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Nov 2016 01:22:52 -0500
Subject: Re: fio bug report
References: <ee28d36c-8fd0-66cd-10c2-817a75f7d9c0@suse.de>
 <CALjAwxh+8eAF9xSjEi4_J9hZbtt8cFBRQN6SAneeu+fn=c87tQ@mail.gmail.com>
From: Denis Polom <dpolom@suse.de>
Message-ID: <01aa68f3-b9fb-1308-e1b0-e43f34b2bc8e@suse.de>
Date: Thu, 10 Nov 2016 07:22:48 +0100
MIME-Version: 1.0
In-Reply-To: <CALjAwxh+8eAF9xSjEi4_J9hZbtt8cFBRQN6SAneeu+fn=c87tQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi

command:

pdsh -f 3 -R ssh -w ceph@artemis,callisto,demeter sudo /usr/bin/fio 
--ioengine=rbd --clientname=admin --pool=cbt-librbdfio 
--rbdname=cbt-librbdfio-`hostname -s`-0 --invalidate=0 --rw=read 
--runtime=600 --ramp_time=None --numjobs=1 --direct=1 --bs=4194304B 
--iodepth=64 --end_fsync=0 
--write_iops_log=/tmp/cbt/00000000/LibrbdFio/osd_ra-00004096/op_size-04194304/concurrent_procs-003/iodepth-064/read/output.0 
--write_bw_log=/tmp/cbt/00000000/LibrbdFio/osd_ra-00004096/op_size-04194304/concurrent_procs-003/iodepth-064/read/output.0 
--write_lat_log=/tmp/cbt/00000000/LibrbdFio/osd_ra-00004096/op_size-04194304/concurrent_procs-003/iodepth-064/read/output.0 
--name=librbdfio-`hostname -s`-0  > 
/tmp/cbt/00000000/LibrbdFio/osd_ra-00004096/op_size-04194304/concurrent_procs-003/iodepth-064/read/output.0


Yes it is possible to bisect down to fio release that makes a problem.

Thank you

dp


On 11/08/2016 08:25 AM, Sitsofe Wheeler wrote:
> Hi,
>
> On 7 November 2016 at 11:21, Denis Polom <dpolom@suse.de> wrote:
>> on version fio-2.13-1.25.x86_64 I found following bug:
>>
>> when fio is executed with options to write to files (etc : --write_iops_log,
>> --write_bw_log, --write_lat_log) it creates files with wrong value for one
>> of the coordinates. So creating the graphs by gnuplot is not possible.
>>
>> file context example:
>>
>> 341692, 0, 1, 1048576
>> 342510, 0, 1, 1048576
>> 343728, 0, 1, 1048576
>> 344551, 0, 1, 1048576
>>
>> In old fio version fio-2.8-1.34.x86_64 was everything fine:
>>
>> 339208, 86, 1, 1048576
>> 340561, 26, 1, 1048576
>> 341692, 54, 1, 1048576
>> 342510, 72, 1, 1048576
> Could you include a minimal job file that reproduced the problem?
> Further do you think it's possible to bisect down to the fio release
> that introduced the issue?
>

