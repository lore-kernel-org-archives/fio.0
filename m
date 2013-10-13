Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:42490 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3JMHDi (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 13 Oct 2013 03:03:38 -0400
Date: Sun, 13 Oct 2013 09:03:30 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <664855650.83197.1381647810495.JavaMail.root@thomas-krenn.com>
In-Reply-To: <CAF+0mv=YQqGT4=-_Zm+Smzw7aduVFrq4FxEgOz7fFuHG6Xn6+g@mail.gmail.com>
Subject: Re: Using fio to test SSD (SNIA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

Hi Matthew,

----- Original Message -----
> From: "Matthew Eaton" <m.eaton82@gmail.com>
> To: fio@vger.kernel.org
> Sent: Sunday, 13 October, 2013 4:34:05 AM
> Subject: Using fio to test SSD (SNIA)
> 
> Hi guys,
> 
> I'm using fio apply an enterprise SNIA test on a single SATA SSD but
> one thing that confuses me is how to choose the number of threads and
> oio per thread. What settings would you guys recommend?
> 
> I'm currently using 16 threads and 64 oio per thread so total oio is
> 1024. Is that overkill?
> 
> Also, I've been wondering since an SSD has a queue depth of 32, where
> are the oios >32 stored?
> 
> Thank you for any insight here.

I have written a Performance Test Tool using Fio implementing the complete Solid State Storage Performance Test Specification Enterprise v1.0 (http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.0.pdf).
The tool is Open Source, if you are interested in it. You can find it at http://git.thomas-krenn.com/TKperf_v1.git/
I am also preparing an Ubuntu package that is nearly finished. It will be on our Ubuntu Repo shortly.

Concerning jobs and outstanding IOs I am mostly using 2 jobs and 16 outstanding IOs. 
A limiting factor IMO are the IO scheduler and the driver dispatch queues. You have to keep in mind the the number of outstanding IOs at the application side can be different from that on the device side. Thats why Fio is also reporting the IO depths statistics:
[...]
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%

There you can inspect which IO depths fio used effectively.
Best Regards, Georg
