Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:38742 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373Ab2FAKGq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 1 Jun 2012 06:06:46 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 434879F67F
	for <fio@vger.kernel.org>; Fri,  1 Jun 2012 12:06:44 +0200 (CEST)
Received: from localhost (ate.tks.local [192.168.10.78])
	by iris.tks.local (Postfix) with ESMTP id E5851405BA
	for <fio@vger.kernel.org>; Fri,  1 Jun 2012 12:06:43 +0200 (CEST)
Received: from mail.thomas-krenn.com ([127.0.0.1])
	by localhost (ate.TKS.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jcWb-B8QbepX for <fio@vger.kernel.org>;
	Fri,  1 Jun 2012 12:06:34 +0200 (CEST)
Received: from [10.0.0.4] (88-117-51-253.adsl.highway.telekom.at [88.117.51.253])
	by mail.thomas-krenn.com (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Fri,  1 Jun 2012 12:06:34 +0200 (CEST)
Message-ID: <4FC8942A.6090805@thomas-krenn.com>
Date: Fri, 01 Jun 2012 12:06:34 +0200
From: =?ISO-8859-15?Q?Georg_Sch=F6nberger?= 
	<gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
Subject: Error running Fio SSD example
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello again,

I am having some troubles with running the fio example "ssd-test". I
changed the global section to decrease the size:
[global]
bs=4k
ioengine=libaio
iodepth=4
size=100M
direct=1
runtime=60
filename=ssd.test.file

If I am running Fio I get the following error:
----------------------------------------
fio.git/examples$ fio ssd-test
seq-read: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
rand-read: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
seq-write: (g=2): rw=write, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
rand-write: (g=3): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
fio-2.0.8
Starting 4 processes
fio: pid=17997, err=22/file:filesetup.c:529, func=open(ssd.test.file),
error=Invalid argument
fio: pid=17998, err=22/file:filesetup.c:529, func=open(ssd.test.file),
error=Invalid argument
fio: pid=17999, err=22/file:filesetup.c:529, func=open(ssd.test.file),
error=Invalid argument
fio: pid=18000, err=22/file:filesetup.c:529, func=open(ssd.test.file),
error=Invalid argument


Run status group 0 (all jobs):

Run status group 1 (all jobs):

Run status group 2 (all jobs):

Run status group 3 (all jobs):
----------------------------------------
My test setup is:
-Fio
  fio.git$ fio --version
  fio-2.0.8
-libaio1
  0.3.109-2ubuntu1
-OS
  Distributor ID:    Ubuntu
  Description:    Ubuntu 12.04 LTS
  Release:    12.04
  Codename:    precise

-Georg

 
