Return-Path: <fio-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:54970 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbZFVKlM (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 22 Jun 2009 06:41:12 -0400
Received: from rsk.demon.co.uk ([80.176.90.227] helo=[192.168.0.2])
	by anchor-post-3.mail.demon.net with esmtp (Exim 4.69)
	id 1MIgxd-0000QB-oQ
	for fio@vger.kernel.org; Mon, 22 Jun 2009 10:41:13 +0000
Subject: unexpected results from simple test?
From: Richard Kennedy <richard@rsk.demon.co.uk>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 11:41:12 +0100
Message-Id: <1245667272.2704.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I been running a hopefully simple fio test, but I don't understand the
results.

the test :-

fio --name=f1 --directory=/sda --rw=rw --size=400m
	--name=f2 --directory=/sdb --rw=write --size=1g --startdelay=10

on linux 2.6.30-git

running this takes quite while, 'time fio ...' gives
real	3m49.174s
user	0m0.838s
sys	0m7.990s

(edited highlights of the fio output)
f1: (groupid=0, jobs=1): err= 0: pid=5181
  read : io=200MiB, bw=23,480KiB/s, iops=5,870, runt=  8722msec
  write: io=200MiB, bw=23,499KiB/s, iops=5,874, runt=  8715msec
f2: (groupid=0, jobs=1): err= 0: pid=5182
  write: io=1,024MiB, bw=77,231KiB/s, iops=19,307, runt= 13577msec

The jobs seem to finish reasonable quickly, but then fio seem to be
stuck waiting for something. CPU usage is 100% but the CPU frequency
stays at the lowest level and the system is really sluggish in its
response. It does recover in time but this test does seem to torture my
system.

strace shows fio repeating this :-
open and read several disk stats, such as 

open("/sys/block/sdb/stat", O_RDONLY)   = 10
fstat(10, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff9ef70c000
read(10, "   45168    22897  2239004   1505"..., 4096) = 99
close(10)                               = 0
munmap(0x7ff9ef70c000, 4096)            = 0

then...

gettimeofday({1245665343, 22984}, NULL) = 0
gettimeofday({1245665343, 23015}, NULL) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
gettimeofday({1245665343, 23086}, NULL) = 0
gettimeofday({1245665343, 23115}, NULL) = 0
gettimeofday({1245665343, 23150}, NULL) = 0
setitimer(ITIMER_REAL, {it_interval={0, 0}, it_value={0, 250000}}, NULL) = 0
rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)
wait4(5321, 0x7fffcfed49d4, WNOHANG, NULL) = 0
nanosleep({0, 10000000}, NULL)          = 0
wait4(5321, 0x7fffcfed49d4, WNOHANG, NULL) = 0
nanosleep({0, 10000000}, NULL)          = 0
...
wait4(5321, 0x7fffcfed49d4, WNOHANG, NULL) = 0
nanosleep({0, 10000000}, NULL)          = 0

then back to the open & reads..

The machine is a AMD X2 64bit with 3G memory & fio is 1.26.

Any ideas what's going on? or suggestions to help track it down?

thanks

Richard 
 

