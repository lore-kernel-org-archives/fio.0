Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:35968 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbaJGRjQ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 7 Oct 2014 13:39:16 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: FIO - Client and Server - Suggestion
Date: Tue, 7 Oct 2014 17:38:26 +0000
Message-ID: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9BB4722AE96D8B4CA3C8F2BFB482819E@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

One small suggestion:

Running Client and Server architecture on FIO, we need to have all config
files "locally" to run it.


Nossa Senhora:tools neto$ ls
151 152 fio



Nossa Senhora:tools neto$ ./fio --client 10.61.109.151 151 --client
10.61.109.152 152
hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
flags=1
hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
flags=1
<s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
iodepth=1
ioengine=libaio, iodepth=1

If we are doing a test in an HPC environment with hundred of files,
wouldn't be easier to try to point to a single location for the file and
access it remotely (we won't need to copy it locally).


For example:

./fio --client 10.61.109.151 --remote-config /root/fio/151 --client
10.61.109.152 --remote-config /root/fio/152


Thoughts?

Thank you,

neto


