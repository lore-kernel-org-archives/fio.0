Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40019 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2DATbZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 1 Apr 2012 15:31:25 -0400
Received: by bkcik5 with SMTP id ik5so1885347bkc.19
        for <fio@vger.kernel.org>; Sun, 01 Apr 2012 12:31:24 -0700 (PDT)
Message-ID: <4F78AD0A.7070904@gmail.com>
Date: Sun, 01 Apr 2012 21:31:22 +0200
From: Hoppetauet <hoppetauet@gmail.com>
MIME-Version: 1.0
Subject: Sequential write problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello

I'm running some benchmarks on virtual machines
I made a script that runs fio N times, with the following job file

[seqwrite]
rw=write
size=${SIZE}
directory=${DIRECTORY}
bs=${BS}
overwrite=1
refill_buffers

The first run gives about 30MB/s, which is what dd tells me is correct 
for the disk at hand
however, from the second to last runs, I get about double that, which 
suggests some sort of caching effect

Is the data that's written to the file not random? I thought 
refill-buffers and overwrite would ensure that

The virtual machines are ubuntu oneiric 11.10, and my fio version is 2.06

Thanks

