Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49630 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbaBUPoN (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Feb 2014 10:44:13 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so3621026pad.39
        for <fio@vger.kernel.org>; Fri, 21 Feb 2014 07:44:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>
References: <CAFTxqD9pJB62TkFNAS+Ex=KyS0E=7PWyzWZatFK03ef22yQ7CA@mail.gmail.com>
Date: Fri, 21 Feb 2014 16:44:12 +0100
Message-ID: <CAFTxqD-PMRbo9M+DsDtZznx9VebYk5t5vbeSyhra3=hQ9Yn1_A@mail.gmail.com>
Subject: Fwd: strange discrepancy
From: "Pal, Laszlo" <vlad@vlad.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Finally I've figured out how to use FIO :) now, I can measure several
things, so I've started to get IOPS data for our hardware. The graphs
looks good, however I can see a very strange discrepancy at seq_write
part

The HW itself is an appliance built from supermicro components and
using software raid and running ubuntu squeezy based OS

FIO paramaters I'm currently using as the follows

[global]
ioengine=libaio
buffered=0
direct=1
bs=4k
blocksize_range=1k-64k
size=2048m

[seq_read]
rw=read
write_iolog=iops_seq_read
write_bw_log=iops_seq_read
write_lat_log=iops_seq_read
write_iops_log=iops_seq_read

[seq_write]
rw=write
write_iolog=iops_seq_write
write_bw_log=iops_seq_write
write_lat_log=iops_seq_write
write_iops_log=iops_seq_write

[random_read]
rw=randread
write_iolog=iops_rand_read
write_bw_log=iops_rand_read
write_lat_log=iops_rand_read
write_iops_log=iops_rand_read

[random_write]
rw=randwrite
write_iolog=iops_rand_write
write_bw_log=iops_rand_write
write_lat_log=iops_rand_write
write_iops_log=iops_rand_write

[random_rw]
rw=randrw
write_iolog=iops_rand_randrw
write_bw_log=iops_rand_randrw
write_lat_log=iops_rand_randrw
write_iops_log=iops_rand_randrw

------------------------------

the results as the follows

Random Read -- 86
Random Write -- 77
Sequential Read -- 2170
Sequential Write -- 45
Random RW -- 40

---------------------------------------------------------

I have two questions again.

The parameters above are good approach to determine IOPS for this system?

What can be the reason of the huge difference between Seq_read and Seq_write?

Thank you for your help
L:
