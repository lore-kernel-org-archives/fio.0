Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC12265CD9
	for <fio@vger.kernel.org>; Thu, 13 Mar 2025 11:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741864880; cv=none; b=bs6hlZUiMiMveBzDU0YrSs6xdzVooEA1IaGLFt+92rCLaKrlK0BQHG1I/2rOsj2GwHaDH6gRYyIT1EG7WpSvEah0+j91KXnY/7b/nKrxePuBHJEpyLuGHvxS46kLdZ74T5UCUA7ZsHsJsSVhFfRP/7nwPu+RI+As7yg32OVnPRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741864880; c=relaxed/simple;
	bh=s+wMJa5YKQhSZVorODSpPDq5VDZ5LODa65O1NUeoK7M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=W57vyn04hFYdGhG2jsbHWEpRF5NvGAUycuBUj3/o+fYdXVXSI4PKo0kyZiq+kXz1fdLG56pm7CO55hfRtA9c+GeksczPmqCZaos7SzxMJbaG8flINjTs1QLwGXNxQQZYZ+vmYuj+4Ph8KnWpm8+FNYt5Db8XXUXQ/X9ZoskbiGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=markbutterworth.net; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=markbutterworth.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-86b68e51af4so354515241.1
        for <fio@vger.kernel.org>; Thu, 13 Mar 2025 04:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741864877; x=1742469677;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kEDoAEH0qxcjoeZRlJYDGAn8oge+E/m+FlZcNq2WR3E=;
        b=wDlAvTzxLsqSLljclCUcpizwLDkqsndv5bbIXL1osGsH1Au7O0cngB80aPzTbphcgD
         Y0s5tGd44e/vez8v2jnzuO3h+3hcikbZexgUUAd/BhqTL95BXMBxyfjM+e/aqoAMsb7q
         MAN+AvdAQFPgn6qWl8UqGWGAQeCiM/5DtSJ59mdshJOBZI8iD4fqY5WHnXWy6Ft0eCds
         aD9zxMhK77Gb8kz+7cD/o0Z3hYtLQMoNvk+ROUt3ECkkOZlcKI6UwIiJrShK9TfzpFbl
         jmez94GgXyFnapw7lsB/oEYqWBVcRnEhSFLBMLCb2vIkQtm0uzrqh8ZGxR8SZaAPp5a7
         TDow==
X-Gm-Message-State: AOJu0Yx91EbK3tovG6qn3emF4TsHTTW2bOqq/SauPCdP56EmYWMinK85
	vOWLJ/0rcOBiYSjBVnf8h0y5xM73V7XEEp0rBm9ULUpmxf8S8i96NkgKgA8r6wzoxjZGRnsVkdd
	3qbvdO2cjPG464rUUgd/LGdZEh+z1EcqjxAs=
X-Gm-Gg: ASbGncsMjm/h+JUBKHOWXFe8TrJD6ZupA97BuWaza3a01bUhl0FBdyhA4Tm8vwPkJkY
	fZDvjhwYlLHDoUvBDUnKQzYId51+PQruiHwWZ5T6dWF8WQAHXTfqrK7xAzg//Tu76QSYJRZQqCu
	9xgEVSaPOJtns4lenAcDX9/+cky1H6JlsBBgCNqigSLA==
X-Google-Smtp-Source: AGHT+IEipE2yqIP/T9SeDBAfwWDIKLzhrOtsloMKpNICgLr9eYJRgvCxZIG0ahmDU4TtOGE7E0ImBbd/FxIqCo8oeyM=
X-Received: by 2002:a05:6102:5798:b0:4c1:b001:b53 with SMTP id
 ada2fe7eead31-4c34d340ff6mr11275923137.18.1741864876748; Thu, 13 Mar 2025
 04:21:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: mrkbutty <mark@markbutterworth.net>
Date: Thu, 13 Mar 2025 11:21:04 +0000
X-Gm-Features: AQ5f1Jr7AqhD9bmYWYGPbKRLZ_7ePmn2wscNXI1q3xKXvnwbNw6dVOtLbguX8ng
Message-ID: <CAEUwzWg6yJqaEp4FQa-RU8qQn7dDCMXPD8VNi-AoCnRBLzU0Jw@mail.gmail.com>
Subject: Can fio report service time?
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

AFAIK fio provides, lat, slat and clat but not the device service time.

Is there a way to make it report this or do I have to use iostat?

For example, below with a lot of jobs and high iodepth we see fio
reports avg lat/clat of around 6.3ms, which I assume includes OS block
device queuing.
However, iostat shows the device in question is servicing IO at a rate
of 0.3ms (r_await).

# $(iostat -xdty -p nvme1c1n1 2 5 > iostat.out &) &&
/scripts/fio/fio-3.38/fio --ioengine=posixaio --name test
--group_reporting --per_job_logs=0 --time_based=1 --runtime=10
--numjobs=32 --iodepth=128 --filename
=/dev/nvme1n1
test: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=posixaio, iodepth=128
...
fio-3.38
Starting 32 processes
Jobs: 32 (f=32): [R(32)][100.0%][r=1841MiB/s][r=471k IOPS][eta 00m:00s]
test: (groupid=0, jobs=32): err= 0: pid=2014545: Thu Mar 13 11:08:39 2025
  read: IOPS=645k, BW=2518MiB/s (2640MB/s)(24.6GiB/10006msec)
    slat (nsec): min=60, max=318733, avg=392.27, stdev=1055.24
    clat (usec): min=38, max=16833, avg=6311.17, stdev=3806.39
     lat (usec): min=38, max=16833, avg=6311.57, stdev=3806.29
    clat percentiles (usec):
     |  1.00th=[  660],  5.00th=[  840], 10.00th=[ 1172], 20.00th=[ 1582],
     | 30.00th=[ 2671], 40.00th=[ 7439], 50.00th=[ 7570], 60.00th=[ 7635],
     | 70.00th=[ 7701], 80.00th=[ 7832], 90.00th=[ 8848], 95.00th=[14353],
     | 99.00th=[14877], 99.50th=[15008], 99.90th=[15139], 99.95th=[15270],
     | 99.99th=[15401]
   bw (  MiB/s): min= 1562, max=10445, per=100.00%, avg=2545.01,
stdev=66.08, samples=620
   iops        : min=400122, max=2673946, avg=651523.08,
stdev=16917.29, samples=620
  lat (usec)   : 50=0.01%, 100=0.10%, 250=0.31%, 500=0.13%, 750=2.37%
  lat (usec)   : 1000=4.37%
  lat (msec)   : 2=18.96%, 4=5.33%, 10=58.84%, 20=9.58%
  cpu          : usr=2.34%, sys=0.16%, ctx=346449, majf=2, minf=2195
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=2.6%, 16=11.5%, 32=24.8%, >=64=61.1%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=98.8%, 8=0.3%, 16=0.2%, 32=0.1%, 64=0.1%, >=64=0.7%
     issued rwts: total=6449569,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=128

Run status group 0 (all jobs):
   READ: bw=2518MiB/s (2640MB/s), 2518MiB/s-2518MiB/s
(2640MB/s-2640MB/s), io=24.6GiB (26.4GB), run=10006-10006msec

Disk stats (read/write):
  nvme1n1: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

# cat iostat.out
Linux 5.14.0-284.11.1.el9_2.x86_64 (hlg201)     03/13/2025
_x86_64_        (112 CPU)


03/13/2025 11:08:30 AM
Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz
w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s
drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1c1n1      997.00 203566.00     0.00   0.00    0.34   204.18
0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00
0.00   0.00    0.00     0.00    0.00    0.00    0.34  50.55


03/13/2025 11:08:32 AM
Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz
w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s
drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1c1n1      235.50  53304.00     0.00   0.00    0.37   226.34
0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00
0.00   0.00    0.00     0.00    0.00    0.00    0.09  29.60


03/13/2025 11:08:34 AM
Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz
w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s
drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1c1n1      291.50  64400.00     0.00   0.00    0.34   220.93
0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00
0.00   0.00    0.00     0.00    0.00    0.00    0.10  34.90


03/13/2025 11:08:36 AM
Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz
w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s
drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1c1n1      291.50  59320.00     0.00   0.00    0.33   203.50
0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00
0.00   0.00    0.00     0.00    0.00    0.00    0.10  32.60


03/13/2025 11:08:38 AM
Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz
w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s
drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1c1n1      285.50  60232.00     0.00   0.00    0.33   210.97
0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00
0.00   0.00    0.00     0.00    0.00    0.00    0.10  32.60


Regards Mark.
