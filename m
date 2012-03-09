Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40118 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab2CIWXI (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 9 Mar 2012 17:23:08 -0500
Received: by vcqp1 with SMTP id p1so1838255vcq.19
        for <fio@vger.kernel.org>; Fri, 09 Mar 2012 14:23:08 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Mar 2012 14:23:08 -0800
Message-ID: <CAKa9NmsJFzHbiSKfG3aJX4xqsj4M7Y_tL=CwUPhpnrxLbLHLnw@mail.gmail.com>
Subject: Repro blocks/offsets in multiple runs
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am looking for an option that enables fio to use same set of
blocks/offsets across multiple runs of the test.
This will be useful if I want am trying to fix a perf issue and want
to rerun the test to verify the patch. For such cases an exact repro
of the i/o pattern is important.

Thanks,
Vikram.
