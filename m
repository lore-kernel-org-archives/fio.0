Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51082 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2CTXEs convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 20 Mar 2012 19:04:48 -0400
Received: by bkcik5 with SMTP id ik5so454581bkc.19
        for <fio@vger.kernel.org>; Tue, 20 Mar 2012 16:04:47 -0700 (PDT)
MIME-Version: 1.0
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Tue, 20 Mar 2012 16:04:16 -0700
Message-ID: <CAPLs8y8Qb4yrPijEaVTukQvPmKDs08wTXVCr4MEYFmBKUrpVSA@mail.gmail.com>
Subject: commandline option to print format of --minimal output
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Do you think adding a --print-minimal-format commandline option to
print something like:

terse-version;fio-version;jobname;groupid;error;read-total-io-kb;read-bw-kb-s;read-iops;read-runtime-msec;read-slat-min;read-slat-max
... etc.

would be useful?

How do you guys extract info from the ';'-separated string? Do you
say: I know the position of 'read-iops' is 8 and I'll just extract the
8-th field?

-- 
 .
..: Lucian
