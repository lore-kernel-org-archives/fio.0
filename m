Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60544 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBTJgO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 04:36:14 -0500
Received: by mail-pd0-f172.google.com with SMTP id p10so1578959pdj.31
        for <fio@vger.kernel.org>; Thu, 20 Feb 2014 01:36:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTxqD8+B7BbUCAE5Md2Ro8y4c1FNYV_AZnOT1OvpJd4H2vQ_Q@mail.gmail.com>
References: <CAFTxqD8+B7BbUCAE5Md2Ro8y4c1FNYV_AZnOT1OvpJd4H2vQ_Q@mail.gmail.com>
Date: Thu, 20 Feb 2014 10:36:13 +0100
Message-ID: <CAFTxqD-R2AzHnq8B-QEGhkLSb_ftzjQ6evAgOiQn9DR0koHKXw@mail.gmail.com>
Subject: Re: IOPS measurement / maybe some dumb questions
From: "Pal, Laszlo" <vlad@vlad.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

During the last two days I've tried to use fio to measure IOPS of some
specific equipment plus generate some fancy graph to represent. I've
checked the example files and also googled everything, but I can't
find a working solution

I've used several example .fio files, it's generating logs, but when I
try to generate interpretation I'm getting various error messages from
gnuplot. The latest one is this:

[vlad@tohuvabohu fio]$ fio2gnuplot -p tiobench
1 files Selected with pattern 'tiobench'
 |-> tiobench

Traceback (most recent call last):
  File "/usr/bin/fio2gnuplot", line 517, in <module>
    sys.exit(main(sys.argv))
  File "/usr/bin/fio2gnuplot", line 495, in main
    blk_size=compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir,min_time,max_time)
  File "/usr/bin/fio2gnuplot", line 196, in compute_temp_file
    time, perf, x, block_size = line[1]
ValueError: too many values to unpack

I'm using fedora20

---------
Basically I have two quesrtions, what is the best job definition for
basic IOPS measurement like this

Measurement Description
Total IOPS Total number of I/O operations per second (when performing
a mix of read and write tests)
Random Read IOPS Average number of random read I/O operations per second
Random Write IOPS Average number of random write I/O operations per second
Sequential Read IOPS Average number of sequential read I/O operations per second
Sequential Write IOPS Average number of sequential write I/O
operations per second

-------

even more important, how can I generate graphs from the data collected?


Thank you

Vlad
