Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51750 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2IUNCV (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 09:02:21 -0400
Received: by lbbgj3 with SMTP id gj3so3821212lbb.19
        for <fio@vger.kernel.org>; Fri, 21 Sep 2012 06:02:19 -0700 (PDT)
Message-ID: <505C6557.1070003@vpseer.com>
Date: Fri, 21 Sep 2012 20:02:15 +0700
From: Konstantin Boyandin <konstantin@vpseer.com>
MIME-Version: 1.0
Subject: Re: fio 2.0.9 fails: shmget: No space left on device
References: <505C54AE.9010701@vpseer.com> <505C5A6A.5020904@kernel.dk> <505C5EB8.5010701@vpseer.com> <505C5F9C.30404@kernel.dk>
In-Reply-To: <505C5F9C.30404@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

Hello Jens,

On 09/21/2012 07:37 PM, Jens Axboe wrote:
> On 09/21/2012 02:34 PM, Konstantin Boyandin wrote:
>> Hello Jens,
>>
>> On 09/21/2012 07:15 PM, Jens Axboe wrote:
>>> On 09/21/2012 01:51 PM, Konstantin Boyandin wrote:
>>>> Hello,
>>>>
>>>> When trying to run the command line
>>>>
>>>> fio --bs=4k --size=128m --direct=1 --runtime=10 --rw=randread
>>>> --numjobs=32 --group_reporting --time_based --name=128m
>>>>
>>>> I see only this:
>>>>
>>>> shmget: No space left on device
>>>> error: failed to setup shm segment
>>>
>>> Hmmm. Can you send me the output of:
>>>
>>> $ grep . /proc/sys/kernel/shm*
>>
>> /proc/sys/kernel/shmall:2097152
>> /proc/sys/kernel/shmmax:33554432
>> /proc/sys/kernel/shmmni:4096
>> /proc/sys/kernel/shm_rmid_forced:0
>>
>>> $ ipcs -l
>>
>> ------ Shared Memory Limits --------
>> max number of segments = 4096
>> max seg size (kbytes) = 32768
>> max total shared memory (kbytes) = 8388608
>> min seg size (bytes) = 1
>>
>> ------ Semaphore Limits --------
>> max number of arrays = 128
>> max semaphores per array = 250
>> max semaphores system wide = 32000
>> max ops per semop call = 32
>> semaphore max value = 32767
>>
>> ------ Messages: Limits --------
>> max queues system wide = 6365
>> max size of message (bytes) = 8192
>> default max size of queue (bytes) = 16384
>>
>>> $ ipcs -m
>>
>> ------ Shared Memory Segments --------
>> key        shmid      owner      perms      bytes      nattch     status
>>
>> The VM wasn't restarted after the fio failed run.
>>
>> fio was run by root user.
> 
> Oh, try with this please.
> 
> diff --git a/init.c b/init.c
> index da1f472..b3215f5 100644
> --- a/init.c
> +++ b/init.c
> @@ -254,7 +254,7 @@ static int setup_thread_area(void)
>  		shm_id = shmget(0, size, IPC_CREAT | 0600);
>  		if (shm_id != -1)
>  			break;
> -		if (errno != EINVAL && errno != ENOMEM) {
> +		if (errno != EINVAL && errno != ENOMEM && errno != ENOSPC) {
>  			perror("shmget");
>  			break;
>  		}

The patch worked fine, thank you!
fio works now as expected.

Sincerely,
Konstantin
