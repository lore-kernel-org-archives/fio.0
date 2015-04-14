Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:32878 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWSo (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Apr 2015 18:18:44 -0400
Received: by qkx62 with SMTP id 62so42253241qkx.0
        for <fio@vger.kernel.org>; Tue, 14 Apr 2015 15:18:43 -0700 (PDT)
MIME-Version: 1.0
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Tue, 14 Apr 2015 16:17:56 -0600
Message-ID: <CADAGN7Xbgknwxb1p6T28G5ohLC4mT3P-8FH5o2zFg_ZQhJqQaA@mail.gmail.com>
Subject: Looping blktrace binary files
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to loop a binary blktrace file and I'm unable to get my
desired result.  The blktrace file I have is ~15minutes in length,
here is my script to try and loop multiple times, but it always runs
once and then exits.

[global]
ioengine=libaio
direct=1
loops=2

[sdd]
read_iolog=sdd.blktrace.bin
replay_redirect=/dev/sdd
replay_no_stall=0

I'm using fio 2.1.4 (I run into issues trying to run the blktrace file
with the most current version of fio).  I've also tried setting
time_based and a runtime, but the script always runs only once, no
matter the runtime specified.  Any suggestions?

Regards,
Brandon
