Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48072 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaDTRIx convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 20 Apr 2014 13:08:53 -0400
Received: by mail-ie0-f182.google.com with SMTP id y20so3228248ier.27
        for <fio@vger.kernel.org>; Sun, 20 Apr 2014 10:08:52 -0700 (PDT)
Received: from [192.168.1.141] (c-24-5-169-218.hsd1.ca.comcast.net. [24.5.169.218])
        by mx.google.com with ESMTPSA id i16sm14230234igf.11.2014.04.20.10.08.50
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 20 Apr 2014 10:08:51 -0700 (PDT)
From: Vasu Kulkarni <vasu.kulkarni@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: runtime resets eta after countdown
Message-Id: <F73CB16A-07C1-4E7B-AD65-2045F7538FBF@gmail.com>
Date: Sun, 20 Apr 2014 10:08:49 -0700
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I see the following issue with my testing,  runtime always resets  eta to some higher number after countdown to 0

[randon_rw1]
rw=randrw
iodepth=8
runtime=24
ioengine=sync
filename=/dev/mapper/mpathdeo:/dev/mapper/mpathdep


or

[randon_rw1]
rw=randrw
iodepth=4
runtime=24
ioengine=sync
filename=/dev/mapper/mpathdeo
filename=/dev/mapper/mpathdep

both devices have 8 paths

mpathdep (23035376338373633) dm-7 FUSIONIO,ION LUN
size=382G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 alua' wp=rw
|-+- policy='queue-length 0' prio=130 status=active
| |- 0:0:1:5 sdk  8:160  active ready running
| |- 1:0:1:5 sdl  8:176  active ready running
| |- 1:0:0:5 sdaa 65:160 active ready running
| `- 0:0:0:5 sdab 65:176 active ready running
`-+- policy='queue-length 0' prio=1 status=enabled
  |- 1:0:2:5 sdar 66:176 active ready running
  |- 0:0:2:5 sdas 66:192 active ready running
  |- 0:0:3:5 sdbi 67:192 active ready running
  `- 1:0:3:5 sdbh 67:176 active ready running
mpathdeo (26361306637636532) dm-6 FUSIONIO,ION LUN
size=345G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 alua' wp=rw
|-+- policy='queue-length 0' prio=130 status=active
| |- 0:0:2:4 sdap 66:144 active ready running
| |- 1:0:2:4 sdaq 66:160 active ready running
| |- 1:0:3:4 sdbf 67:144 active ready running
| `- 0:0:3:4 sdbg 67:160 active ready running
`-+- policy='queue-length 0' prio=1 status=enabled
  |- 1:0:1:4 sdj  8:144  active ready running
  |- 0:0:1:4 sdi  8:128  active ready running
  |- 0:0:0:4 sdy  65:128 active ready running
  `- 1:0:0:4 sdz  65:144 active ready running


runtime gradually decreases from 24 seconds to 1 seconds and then eta is reset back to 4hours,  if there is only one device the runtime works properly

[root@auto-rhel65 ~]# fio /automation/fio/ioprofile1.fio 
randon_rw1: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=4
fio-2.1.7
Starting 1 process
^Cbs: 1 (f=1): [m] [0.2% done] [30232KB/30788KB/0KB /s] [7558/7697/0 iops] [eta 04h:02m:32s]


[root@auto-rhel65 ~]# fio -v
fio-2.1.7

[root@auto-rhel65 ~]# uname -a
Linux auto-rhel65 2.6.32-422.el6.x86_64 #1 SMP Mon Oct 7 17:58:55 EDT 2013 x86_64 x86_64 x86_64 GNU/Linux




