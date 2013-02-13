Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47060 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab3BMKpg (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 Feb 2013 05:45:36 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so625884pab.18
        for <fio@vger.kernel.org>; Wed, 13 Feb 2013 02:45:36 -0800 (PST)
Message-ID: <511B6E9C.3000903@gmail.com>
Date: Wed, 13 Feb 2013 18:44:44 +0800
From: Peter Xu <xzpeter@gmail.com>
MIME-Version: 1.0
Subject: How to get IOPS when using terse output
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, all,

I failed to find IOPS results for read/write under terse mode (with 
--minimal param when invoking fio program), while IOPS does exist in 
normal output without --minimal param.

It seems that I even cannot calculate it out only with the tersed output 
(since I don't know the total number of IO). Then, how should I get IOPS 
results when using terse output?

Yours,
Peter
