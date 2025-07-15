Received: from infra.glanzmann.de (infra.glanzmann.de [88.198.237.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF32C2D322E
	for <fio@vger.kernel.org>; Tue, 15 Jul 2025 05:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.237.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556673; cv=none; b=c55X1aRvCFZkYV8RjqrnFBkpddIx8Cz69Xvx/FOXISBHyef5mwDhIxkm0187yCzqEn5dEZUIjolqadnYmpCyuEzerwK0mf9CtzgjPMf1Gml6INHQjCzesYBk34A/zXB74BB7MC0NAZgkT2uRJD3VJbvCbAZP84U902Yd5ssZx1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556673; c=relaxed/simple;
	bh=YZjkQezutFWb2ipxU9xyFIKLGRAU/P+L8vD41MoOCXU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=arTqTIg54dTzlQ8vc7HAExlmK9cqvS3+4WnvvqinJ00j2zBkct2/tLO5vzHGm5iryqQYOHmpXPpGquP1P1MRIq47euTG91oULK0uusvprHBgAwHZiegaahJUlsL0jSRSyqEGZvdkKjtCSaIPYf1ckg8JfV44MXa98L5fhZVaT3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de; spf=pass smtp.mailfrom=glanzmann.de; dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b=O07aPT0i; arc=none smtp.client-ip=88.198.237.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=glanzmann.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=glanzmann.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=glanzmann.de header.i=@glanzmann.de header.b="O07aPT0i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=glanzmann.de;
	s=infra26101010; t=1752556665;
	bh=nDuJ8fHK+tNHbuy7Af5w8emcZzkY3MOEs80AZ+p2LKY=;
	h=Date:From:To:Subject:From;
	b=O07aPT0iSzx7cMFgCV8jFMPckqKWgid/73BzI7KTXFJhXQIaAQIciHdvR45FOfzYj
	 arEYQvdsfDfR29yqQs/hnJjuV3L68M7oNNAiHuK1a1CguzGMaFYFqhu/y3CcxwfCrs
	 zhO02biRj3kvzJo3+3fU3A2dgODn4hFQCISXuX7qx5nsrVZM1IQzJtM6g3ErrXtsoF
	 113UeBkk/c4TgrKRCAEbkM4+dkiWkJpCaNoDhNJOcKwo5MJNQbywRR8CDVOCHFI3aS
	 DNoHj+X2CDnhpqubXGABbzA/rNDDqpCoFchoyaAxQ34g1UFamVjJlcW1jv/cVczCat
	 zHJNaC9HzVnWBNh1C5smQZj3aMAmzfTlRNEMMTn9uQ2ojeBQcrSjsevMYrZqTBSvr/
	 wdpSElFON9eJUnZCkF+c3R1/9OL91IIB7KlIlbw13hTDWj3NuUQ+hB8F/BUVqq5ema
	 ZLY4NrcE4YUmaMVDJPf+UZLyBwPdXvgTIfHS+LNNiIWELKg9L52Wemp55Z4TBn2q8a
	 vO/uDm+AtY61vrkcZMOGyg5P/S2TNY4cr531J+P3XbyOK1bLEjMc1w+DxWbW1iQx7i
	 GjQQ9/r5JD30T22sdLEfLskn+k5EgyJ3sJpnVEw2kBll52QA7Kw7TbtUQLUhAmEBwP
	 paj7kXQOeEPQGzKKEseohD5U=
Received: by infra.glanzmann.de (Postfix, from userid 1000)
	id 9F0887A800B9; Tue, 15 Jul 2025 07:17:45 +0200 (CEST)
Date: Tue, 15 Jul 2025 07:17:45 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: fio@vger.kernel.org
Subject: Evenly distribute jobs and iodepth over a 1 TiB device so that every
 byte is written to in parallel
Message-ID: <aHXkeSsuqlIj2R64@glanzmann.de>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,
I have a 1 TiB NVMe namespace from a NetApp connected via two distinct
direct links to a Linux system over NVMe/TCP. I would like to generate
read and write I/O using multiple jobs/iodepth so that every byte of the
device is being written to in parallel with the maximum number of
available parallel inflight I/Os. The NetApp does deduplication
and compression by default so I want to generate random data. Because I
think if I don't do refill_buffers, the NetApp gets that the same data
is used over and over again and dedups it. I tried:

fio --ioengine=libaio --refill_buffers --filesize=25G --ramp_time=2s \
--runtime=1m --numjobs=40 --direct=1 --verify=0 --randrepeat=0 \
--group_reporting --filename=/dev/nvme0n1 --name=1mhqd --blocksize=1m \
--iodepth=1638 --readwrite=write

So I'm on a Linux system with 40 hyperthreads and a mellanox 2x 25
Gbit/s card hooked up to the NetApp:

(live) [~] ip -br a s
...
eth6             UP             192.168.0.100/24
eth7             UP             192.168.1.100/24

(live) [~] nvme list-subsys /dev/nvme0n1
nvme-subsys0 - NQN=nqn.1992-08.com.netapp:sn.e0a0273a60b711f09deed039ead647e8:subsystem.svm1_subsystem_553
               hostnqn=nqn.2014-08.org.nvmexpress:uuid:20f011e6-9ab8-584f-abb0-a260d2d685c4
\
 +- nvme0 tcp traddr=192.168.0.2,trsvcid=4420,src_addr=192.168.0.100 live optimized
 +- nvme1 tcp traddr=192.168.1.2,trsvcid=4420,src_addr=192.168.1.100 live optimized

na2501::*> network interface show
            Logical    Status     Network            Current       Current Is
Vserver     Interface  Admin/Oper Address/Mask       Node          Port    Home
----------- ---------- ---------- ------------------ ------------- ------- ----
...
svm1
            lif_svm1_2660 up/up   192.168.1.2/24     na2501-02     e4c     true
            lif_svm1_9354 up/up   192.168.0.2/24     na2501-01     e4c     true

So when I run the above command the NetApp only reports a few hundered GiB of
physically allocated space:

na2501::*> aggr show -fields physical-used
aggregate      physical-used
-------------- -------------
dataFA_4_p0_i1 169.5GB

So, I ran:

(live) [~] pv < /dev/urandom > /dev/nvme0n1
1.00TiB 0:59:14 [ 294MiB/s] [======================>] 100%

And afterwards more physical space was used:

na2501::*> aggr show -fields physical-used
aggregate      physical-used
-------------- -------------
dataFA_4_p0_i1 1.15TB

So, what is the best way to use fio to write random data to every byte of this
1 TiB device in parallel?

	- Is there a command line parameter?
	- Or should I create 40 25.6 GiB (1024/40) partitions and give them as
	  colon separated list to fio?

I also would like to determine the number of queues and queue depth? Is there a
command available. When I run:

fio --ioengine=libaio --refill_buffers --filesize=8G --ramp_time=2s \
--runtime=1m --numjobs=40 --direct=1 --verify=0 --randrepeat=0 \
--group_reporting --filename=/dev/nvme0n1 --name=4khqd --blocksize=4k \
--iodepth=1638 --readwrite=randwrite

And also watch 'iostat -xm 2' I can see aqu-sz is 194.87 per path and
391.96 for the multipathed device nvme0n1. So I kind of know it but
would like to have a command on Linux that shows me the available queues
and queue depths.

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.67    0.00    6.48   85.13    0.00    6.72

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme0c0n1        0.00      0.00     0.00   0.00    0.00     0.00 60855.00    237.71     0.00   0.00    3.20     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00  194.87 100.00
nvme0c1n1        0.00      0.00     0.00   0.00    0.00     0.00 58719.00    229.37     0.00   0.00    3.32     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00  194.94 100.00
nvme0n1          0.00      0.00     0.00   0.00    0.00     0.00 119570.50    467.07     0.00   0.00    3.28     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00  391.96 100.00

Cheers,
        Thomas

