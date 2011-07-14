Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:15829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1GNCtX (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 Jul 2011 22:49:23 -0400
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id p6E2nMSi032717
	for <fio@vger.kernel.org>; Wed, 13 Jul 2011 19:49:22 -0700
Received: from ywn13 (ywn13.prod.google.com [10.192.14.13])
	by kpbe12.cbf.corp.google.com with ESMTP id p6E2nJFT002582
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 13 Jul 2011 19:49:21 -0700
Received: by ywn13 with SMTP id 13so3762329ywn.21
        for <fio@vger.kernel.org>; Wed, 13 Jul 2011 19:49:21 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Jul 2011 19:49:21 -0700
Message-ID: <CAAK6Zt2ZJnHEAbNhHpXCiOzBGVfeVhA3yto-8OPTGz-KKZW+Sg@mail.gmail.com>
Subject: Calling Linux io_getevents without blocking
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to recreate a workload which would call the io_getevents
function in Linux libaio without blocking, spinning until the result
comes up. There are two ways to make io_getevents return immediately
if there are no results: pass in a timeout of 0, or pass min_nr=0. (Of
course, this non-blocking way of invoking io_getevents wouldn't be
used by the cleanup routines, only during the main loop). I can't
figure out what the proper way to do this is. I don't see an option
that would allow this. I thought iodepth_batch_complete=0 would make
the min_nr be 0, but it seems that the minimum number in practice is
1, as lines 555-556 establish. It looks like if
iodepth_batch_complete=0, then full might be false and min_nr might
not be set to 1, but this often isn't the case in my testing. I don't
see how to set a different timeout from the default, which seems to be
NULL.

Am I missing something? What would be the proper way of allowing this
setting in a way that doesn't break other engines? One way I hacked up
is to make a new boolean option which sets min_events to 0 right after
line 556 if enabled (and similarly for the do_io main loop). Is there
a better way to do it? Otherwise, would you accept a patch that
implements this?

Thanks,
Dan
