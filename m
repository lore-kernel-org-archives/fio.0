Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36292 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbcBIW1P (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Feb 2016 17:27:15 -0500
Received: by mail-wm0-f47.google.com with SMTP id p63so3875320wmp.1
        for <fio@vger.kernel.org>; Tue, 09 Feb 2016 14:27:14 -0800 (PST)
From: =?UTF-8?Q?Michal_=c5=a0mucr?= <msmucr@gmail.com>
Subject: missing waitpid() and server functionality at Windows
Message-ID: <56BA67C0.1030603@gmail.com>
Date: Tue, 9 Feb 2016 23:27:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, bruce@cran.org.uk

Hello,

previously I've used fio mainly at Linux and OS X, so I didn't have any 
issues with fio in server mode. Now I'm trying to simulate workload to 
shared storage for Windows clients and this functionality with remote 
control of fio instances running at Windows machines will be very handy.
Unfortunately it isn't possible to use it that way, because of missing 
waitpid() syscall implementation and forking in MinGw builds for Windows.

I've stumbled upon at some messages posted 2y ago, where Bruce explained it.
http://www.spinics.net/lists/fio/msg02565.html

I don't know, if I got it correctly, but can be a build with Cygwin 
toolchain possible workaround for this issue?
I've tried to compile current fio with Cygwin (so no MinGw toolchain) 
and compiler variables override, but failed badly.. It doesn't even pass 
through crc/test.c with lot of messed definitions. Is it currently 
possible to build with it or MinGW is currently only way for Windows 
compilation of fio?

Kind regards,

Michal
