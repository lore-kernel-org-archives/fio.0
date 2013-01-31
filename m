Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58926 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3AaNop (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Jan 2013 08:44:45 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so1470580eek.19
        for <fio@vger.kernel.org>; Thu, 31 Jan 2013 05:44:44 -0800 (PST)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Thu, 31 Jan 2013 13:44:24 +0000
Message-ID: <CANUChTxynLg7p5kK1vex9965qvYxyFagzk8QAtbh-2-=_Mdxhg@mail.gmail.com>
Subject: Output logs and keep command line display
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Not sure if I am missing a special argument somewhere, but I like the
command line display we get from Fio when it runs showing the type of
workload and job descriptions and percentage complete, etc.  Is it
possible to get the outputs that you get when using the --minimal
argument (in JSON, CSV formats) whilst still keeping the command line
display.

Having this would make it similar to Iometer, not in a graphical
sense, but in a way that you can see exactly what is occurring (and if
it has halted or crashed) whilst still having logs that could be
charted or plotted into reports.  Especially useful for extended test
runs (over several hours!)

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
