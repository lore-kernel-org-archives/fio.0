Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60024 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757723Ab2CPWJd (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 16 Mar 2012 18:09:33 -0400
Received: by lahj13 with SMTP id j13so3602783lah.19
        for <fio@vger.kernel.org>; Fri, 16 Mar 2012 15:09:31 -0700 (PDT)
Message-ID: <4F63BA21.1090600@gmail.com>
Date: Fri, 16 Mar 2012 23:09:37 +0100
From: Hoppetauet <hoppetauet@gmail.com>
MIME-Version: 1.0
Subject: Parsing FIO output
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello!

I'm in the process of benchmarking a cloud, and have written scripts 
that capture FIO output from X runs (using the --minimal option).

I run 4 different tests, for seq read/write and random read/write. I've 
found that the write output is in field $25 and the read output is in 
$6, but I'm struggling with min, max and stddev of the latency (clat). 
Also, I've read that it changes from usec to msec where it's convenient. 
Any tips as to getting out the values in msec always?

Thanks
