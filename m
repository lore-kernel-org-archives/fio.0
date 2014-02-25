Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55930 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYRV4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Feb 2014 12:21:56 -0500
Received: by mail-ve0-f181.google.com with SMTP id jw12so772454veb.40
        for <fio@vger.kernel.org>; Tue, 25 Feb 2014 09:21:55 -0800 (PST)
MIME-Version: 1.0
From: puvi <r.puvichakravarthy@gmail.com>
Date: Tue, 25 Feb 2014 22:51:35 +0530
Message-ID: <CAMYQYmqi-Re5oU9JSX1sm=E5f=ucrwRuf1BRmdo5y+JkhEouhw@mail.gmail.com>
Subject: Understanding cpu% in fio
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi All,

  Could you kindly help me understand the cpu% reported in FIO output.

  I'm using a dat file with the following global parameters.

[global]
buffered=1
bs=128k
iodepth=16
numjobs=1
group_reporting=1
size=2000m
rw=read
runtime=180
time_based

  and in the result I get something like this

  cpu          : usr=0.08%, sys=98.63%, ctx=46607, majf=0, minf=768

  and I monitor the system level utilization using vmstat and they
point to different values ( lesser values).

  Looking at the code I see that fio does cpu% as cpu_time( from
rusage) / total elapsed time. In the above case I have 128 jobfiles
running. Does fio add the cpu_time of all threads and then divide by
elapsed time ( ~180s) ? Kindly correct me if I'm wrong.

Thanks.

~Puvi
