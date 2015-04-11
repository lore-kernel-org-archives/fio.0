Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35810 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbDKIh5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 11 Apr 2015 04:37:57 -0400
Received: by iejt8 with SMTP id t8so33888094iej.2
        for <fio@vger.kernel.org>; Sat, 11 Apr 2015 01:37:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxiad2R5HqkKDct8HzZiROrY9rYwaP9m_jdyY8ROaqXJKA@mail.gmail.com>
References: <CABtFm2VCPQUYukN+74snO6vOo__U1T1UG-p1HAkof5i+E3ax9A@mail.gmail.com>
	<CALjAwxiad2R5HqkKDct8HzZiROrY9rYwaP9m_jdyY8ROaqXJKA@mail.gmail.com>
Date: Sat, 11 Apr 2015 16:37:56 +0800
Message-ID: <CABtFm2VX=ayS2kqGX43YVfUSeaWgDsgmfbqPDbw=omUDM7LcEg@mail.gmail.com>
Subject: Re: FIO not generating multiple jobs for directories
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi, Thanks for the reply. I did some investigation by removing each
parameter and the problem seems to be with parameter overwrite when
its set to true.

if i remove the parameter from the job file and run, i get the
expected number of threads as specified.

# cat fio_testjob.fio
[fileio]
ioengine=libaio
rw=write
directory=/mnt/sdb:/mnt/sdc:/mnt/sdd:/mnt/sde
filesize=1m-40m
nrfiles=1024
file_service_type=random:64
random_generator=tausworthe
rate=,400m
bs=8k
numjobs=6
iodepth=32
scramble_buffers=1
blocksize_unaligned
blocksize_range=8k-124k
loops=1
percentage_random=100
random_distribution=random
norandommap
overwrite=1    <<<<<< Problem with this parameter If i remove, it just works.
fill_device=1
fsync=1024
prio=0

From the man page i do not see any relevance to the threads for the
param "overwrite"

       overwrite=bool
              If writing, setup the file first and do overwrites.
Default: false.

May be some issue here or my understanding is wrong.

On Sat, Apr 11, 2015 at 2:27 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 9 April 2015 at 05:18, Srinivasa Chamarthy <chamarthy.raju@gmail.com> wrote:
>> # cat fileio.fio
> <snip>
>>
>> Is there anything wrong with the parameters?
>
> Any chance you can minimize the jobfile such that it contains the
> minimum number of parameters that still show the problem?
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Srinivasa R Chamarthy
