Return-Path: <fio-owner@vger.kernel.org>
Received: from server505h.appriver.com ([98.129.35.13]:2787 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755636Ab3AJSF6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 10 Jan 2013 13:05:58 -0500
Received: from [98.129.35.1] (HELO smtp.exg5.exghost.com)
  by server505.appriver.com (CommuniGate Pro SMTP 5.4.8)
  with ESMTPS id 280563080 for fio@vger.kernel.org; Thu, 10 Jan 2013 12:00:55 -0600
From: Carl Zwanzig <cpz@coraid.com>
Date: Thu, 10 Jan 2013 12:00:53 -0600
Subject: problems writing on windows
Message-ID: <27A430545AF420468AEE097737EE633A0C47E3D471@MBX29.exg5.exghost.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello,

I'm having what sounds like the same problem reported by Dallas Clement back in April- writes to a physical drive don't seem to do anything:

C:\Users\Administrator>"\Program Files\fio\fio.exe" --name asd --filename=\\.\PhysicalDrive3 --rw=write --size=1g --bs=64k --thread
asd: (g=0): rw=write, bs=64K-64K/64K-64K/64K-64K, ioengine=windowsaio, iodepth=1

fio-2.0.12.2
Starting 1 thread

asd: (groupid=0, jobs=1): err= 0: pid=2108: Thu Jan 10 09:46:42 2013
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=1/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):

C:\Users\Administrator>

Read works as expected (there may be a bug in the ETA display but I'm ignoring that right now). Using fio-2.0.12.2 on windows 2008, running in a cmd box. Unfortunately, I don't have windows dev tools readily available, so I'd prefer to stay out of the code. Thoughts?

Thanks,

z!



