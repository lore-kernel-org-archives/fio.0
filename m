Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D9E14AA8
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658713; cv=none; b=ndefZ3wbfMKMfllVkoHfQR/1GLcBorKYyDkYzC3XDHkzq2L7t92Vq+AUm0FCoOSXVFN1E9Fa0/xrZRk2cRybEnQ1qmXj054+uN0gk0pZEzozECztlJ+dQvZXGiEcK6TuOafy+zR5454LzlQro4lMsnLx70mZ4Lz4Sg9c+vaxha4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658713; c=relaxed/simple;
	bh=QanA2pm1j1u7ZBBrADgOSDIbBDdaQMdr1Nk7cn0bAps=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cKliSilWxJ0FzSvb1EMW4Jv3/23SZR/mDeVElhsS1DeN/aJLMvcPlW/ssfshhaWBNKfZ7UYHliBvPZMqWwzuDRm6JoeWKf8I8mXDc/bjQxw9zrJjuQmVJjIKlRhtD3EWYeQ45oYSLoEm7Qg1pOu5NnGklyS3jeJn7xzlCh+2Y+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=koM4Ql5s; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="koM4Ql5s"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-42ee2012bf0so20955251cf.0
        for <fio@vger.kernel.org>; Tue, 05 Mar 2024 09:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709658709; x=1710263509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9VXTZ8tfPc6OkoNbJWv3MxFuOzNw/7ALkmDU7irNNOk=;
        b=koM4Ql5suHU0xqkSEafvl8pVsQh990TuV6uUr7baKD23ZmG/PqzxRHPDhIBsWquZN2
         mjqJepCLojwfuJlaYkfAL2OjBjB9mNXR6KkKlXYF1USGieAZatFineS5IwtEoR5WfRXq
         pcVlSQKTRdhaZIg1qKgqVJpp4EaSFOAmLD23Ik63lUlQoJQVVWRGPmopTwgamxVNQ2ee
         ct06EZNg7oo6efGh92SvT1hOnLAG6ZJalwJRtYBwiuc8soGpdzzreClhyiuS7Ih09H4/
         yJUTL0WX/hK5NrQy7s0khsoRqNxTb2p4wtRzuXi7r+ZOutKSXyjKKjcxyhpc1uu7S7uP
         4+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709658709; x=1710263509;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9VXTZ8tfPc6OkoNbJWv3MxFuOzNw/7ALkmDU7irNNOk=;
        b=T8n5q9TzPJrXh+61320Pv0y62t39xf00xS8jt85QYToDdGaxLmhxffSmcRPRGtRCNF
         LTNaBuAvhcUi3r8X79ItafAXpUKLSmqKI5hOrbhp2PBTu13FBU5Jf9Q/FFwf2V8vER/+
         /7DG3sWYO4mKuk5sK+yo6GodLtmMNh9T2CHhDPFYuHKqHkYSR4rRpwMZAXY6HtRvSDFZ
         yY26jrziukqPJKD8wUXFvIUHDvFiq/NNjEpevg8ENp3bcayOqgbV75FiklDM9WzciHfL
         JreSPCxJnBs60xWcJCGAtzilzLQ6n2GW9JoOQb/ua/u7p0aWpWXhfrr/G4yUwbP4rOsZ
         7pug==
X-Forwarded-Encrypted: i=1; AJvYcCWEZhRbHtyCYWIUGB94Knj38HmEMf37yH26XTqVlCLLmLv4uoeI43OGW3s4HBJo2x3QVXhugb3kZ62N2x87ti1GdD3t
X-Gm-Message-State: AOJu0YzV50sr6tHyGA7lQIoL37ZSTgdMI9Kboc8xHhI7RvAUUt1oIhQj
	FjjotY2F527vpP6/K+1e6o/uMuwxwl6VtF5yM7Im14NjLfLfCueQrzTp/feD
X-Google-Smtp-Source: AGHT+IFHX/dwT/+cH5+Xrp1e4TO9moO1W5v4CoP2SZVjIJnjllhGDcp3K5DLId4OZzWEHMbBNRDcAQ==
X-Received: by 2002:ac8:5c05:0:b0:42e:f6c2:e68b with SMTP id i5-20020ac85c05000000b0042ef6c2e68bmr3660830qti.14.1709658709411;
        Tue, 05 Mar 2024 09:11:49 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id k8-20020ac81408000000b0042f0945e558sm141933qtj.4.2024.03.05.09.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 09:11:48 -0800 (PST)
Message-ID: <706651ae-3f53-4cc6-aa06-43a49f8e2078@gmail.com>
Date: Tue, 5 Mar 2024 12:11:48 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fio version change gives different throughput results
Content-Language: en-US
To: Thomas Weber <thomas.weber@de.ibm.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <3309778342f6bfdefe0b7a1de1fcddab10902c37.camel@de.ibm.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <3309778342f6bfdefe0b7a1de1fcddab10902c37.camel@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/24 08:53, Thomas Weber wrote:
> Hi all,
> 
> I noticed a change in the reported throughput when switching from fio version 3.17 to 3.36.
> 
> I narrowed it down to fio-3.26 which seem to introduce the throughput change.
> 
> The exemplary fio workload attached gives me different results since then.
> 
> Was that change intended?
> 
> Thanks Thomas
> 
> fio-3.25:
> Run status group 0 (all jobs):
>     READ: bw=3658MiB/s (3835MB/s), 3658MiB/s-3658MiB/s (3835MB/s-3835MB/s), io=429GiB (460GB), run=120001-120001msec
>    WRITE: bw=2438MiB/s (2557MB/s), 2438MiB/s-2438MiB/s (2557MB/s-2557MB/s), io=286GiB (307GB), run=120001-120001msec
> 
> fio-3.26:
> Run status group 0 (all jobs):
>     READ: bw=474MiB/s (497MB/s), 474MiB/s-474MiB/s (497MB/s-497MB/s), io=55.5GiB (59.6GB), run=120001-120001msec
>    WRITE: bw=317MiB/s (332MB/s), 317MiB/s-317MiB/s (332MB/s-332MB/s), io=37.1GiB (39.9GB), run=120001-120001msec
> 
> 
> FIO_FREEPARM1=description=na FIO_FREEPARM2=description=na FIO_FREEPARM3=description=na FIO_FREEPARM4=runtime=120 FIO_FREEPARM5=time_based FIO_TARGETSPEC=directory=./fsstress_data FIO_NUMJOB=1 FIO_BS=64k FIO_SIZE=1g FIO_DIRECT=0 FIO_IOENGINE=sync FIO_IODEPTH=1 fio ./fs-stress2.fiojob --output-format=normal,terse --terse-version=3 --warnings-fatal --eta=never
> 
> fs-stress2.fiojob file:
> [global]
> ioengine=${FIO_IOENGINE}
> iodepth=${FIO_IODEPTH}
> size=${FIO_SIZE}
> direct=${FIO_DIRECT}
> numjobs=${FIO_NUMJOB}
> ${FIO_TARGETSPEC}
> 
> # free parameters that can be overwritten including the var= specifier
> ${FIO_FREEPARM1}
> ${FIO_FREEPARM2}
> ${FIO_FREEPARM3}
> ${FIO_FREEPARM4}
> ${FIO_FREEPARM5}
> 
> # environment setup
> norandommap
> allrandrepeat=1
> startdelay=50ms-2s
> ramp_time=5s
> 
> [smallstuff-seq-slow]
> rw=rw
> nrfiles=1000
> openfiles=25
> filesize=1k-1m
> bssplit=4k/20:128k/80
> rwmixread=60
> 

There was a bug fix in fio-3.26 which seems relevant to your configuration:

https://github.com/axboe/fio/commit/4ef1562a013513fd0a0048cca4048f28d308a90f

commit 4ef1562a013513fd0a0048cca4048f28d308a90f
Author: Adam Kupczyk <akupczyk@redhat.com>
Date:   Mon Dec 28 14:55:17 2020 +0100

     io_u: Fix bad interaction with --openfiles and non-sequential file 
selection policy

     Problem happens when --openfiles is set and file_service_type != 
FIO_FSERVICE_SEQ.
     In function __get_next_file, we decrement file_service_left and if 
0, we select
     next file to operate on.
     However, get_next_file_rand can return -EBUSY if too many files are 
already opened,
     and __get_next_file exits with error.

     In next invocation of __get_next_file, we decrement 
file_service_left again (from 0),
     wrapping around to 2^32-1, effectively locking __get_next_file to 
always select the same.

     Algorithm to observe bad behavior:
     fio --randseed=1 --ioengine=libaio --rw=randwrite --nrfiles=256 
--bs=4k --size=256m \
     --loops=50 --allow_file_create=1 --write_iolog=log.txt 
--file_service_type=normal:20 \
     --filename_format=object.\$filenum --name=x --openfiles=100

     cat log.txt |grep write |cut -f 1 -d " " |sort |uniq -c | sort -n | 
sed "s/[.]/ /" \
     | while read a b c; do echo $c $b $a; done |sort -n
     ....
     70 object 17
     71 object 19
     72 object 22
     73 object 65296
     74 object 65255
     75 object 33
     76 object 27
     77 object 25
     78 object 65243
     79 object 36
     80 object 49
     81 object 47
     ....

     Signed-off-by: Adam Kupczyk <akupczyk@redhat.com>

