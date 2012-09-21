Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33546 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2IUMeF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 08:34:05 -0400
Received: by lbbgj3 with SMTP id gj3so3784547lbb.19
        for <fio@vger.kernel.org>; Fri, 21 Sep 2012 05:34:03 -0700 (PDT)
Message-ID: <505C5EB8.5010701@vpseer.com>
Date: Fri, 21 Sep 2012 19:34:00 +0700
From: Konstantin Boyandin <konstantin@vpseer.com>
MIME-Version: 1.0
Subject: Re: fio 2.0.9 fails: shmget: No space left on device
References: <505C54AE.9010701@vpseer.com> <505C5A6A.5020904@kernel.dk>
In-Reply-To: <505C5A6A.5020904@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>

Hello Jens,

On 09/21/2012 07:15 PM, Jens Axboe wrote:
> On 09/21/2012 01:51 PM, Konstantin Boyandin wrote:
>> Hello,
>>
>> When trying to run the command line
>>
>> fio --bs=4k --size=128m --direct=1 --runtime=10 --rw=randread
>> --numjobs=32 --group_reporting --time_based --name=128m
>>
>> I see only this:
>>
>> shmget: No space left on device
>> error: failed to setup shm segment
> 
> Hmmm. Can you send me the output of:
> 
> $ grep . /proc/sys/kernel/shm*

/proc/sys/kernel/shmall:2097152
/proc/sys/kernel/shmmax:33554432
/proc/sys/kernel/shmmni:4096
/proc/sys/kernel/shm_rmid_forced:0

> $ ipcs -l

------ Shared Memory Limits --------
max number of segments = 4096
max seg size (kbytes) = 32768
max total shared memory (kbytes) = 8388608
min seg size (bytes) = 1

------ Semaphore Limits --------
max number of arrays = 128
max semaphores per array = 250
max semaphores system wide = 32000
max ops per semop call = 32
semaphore max value = 32767

------ Messages: Limits --------
max queues system wide = 6365
max size of message (bytes) = 8192
default max size of queue (bytes) = 16384

> $ ipcs -m

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status

The VM wasn't restarted after the fio failed run.

fio was run by root user.

Sincerely,
Konstantin

