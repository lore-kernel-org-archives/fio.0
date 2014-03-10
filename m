Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:37023 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaCJVM6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 10 Mar 2014 17:12:58 -0400
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3425.houston.hp.com (Postfix) with ESMTPS id 1EAB01C6
	for <fio@vger.kernel.org>; Mon, 10 Mar 2014 21:12:58 +0000 (UTC)
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: number_ios is checked on completion, not submission
Date: Mon, 10 Mar 2014 21:12:03 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Since number_ios is checked in io_u.c account_io_completion() rather than a submission function, fio actually runs the requested number of I/Os plus iodepth - 1.

Example: for a job specifying:
number_ios=5000
iodepth=128

the results are:
  read : io=20000KB, bw=222222KB/s, iops=56966, runt=    90msec
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.8%
     issued    : total=r=5127/w=0/d=0, short=r=0/w=0/d=0

Should that just be documented as such, or should this logic be moved to submission?
static void account_io_completion(struct thread_data *td, struct io_u *io_u,
...
        if (td->o.number_ios && !--td->o.number_ios)
                td->done = 1;

---
Rob Elliott    HP Server Storage


