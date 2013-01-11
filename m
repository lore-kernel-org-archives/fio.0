Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47635 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3AKJFC (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Jan 2013 04:05:02 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so334738eek.39
        for <fio@vger.kernel.org>; Fri, 11 Jan 2013 01:05:01 -0800 (PST)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Fri, 11 Jan 2013 08:58:49 +0000
Message-ID: <CANUChTws0KGNRVQ=N_WH70LeoN-Kv2V6wjFbnf_VCA4OU9D8wQ@mail.gmail.com>
Subject: Running Fio to Particular LBA's
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm using Fio to run to raw devices in both Linux & Windows, one thing
that I am unable to do is to specify an LBA range to run to.

I know that there are the 'zonesize' and 'zoneskip' arguments, but I'm
struggling to see how they work. In essence I would like to have a
number of jobs running to different parts of the disk.

In a basic example:  from LBA 0 to 1/2 of MaxLBA I would like to run a
sequential workload and from 1/2 MaxLBA+1 to MaxLBA I would like to
run a random workload.

Can this be done with existing arguments?

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
