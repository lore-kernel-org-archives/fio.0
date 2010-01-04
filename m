Return-Path: <fio-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:43315 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0ADOe0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 4 Jan 2010 09:34:26 -0500
Subject: Re: io scheduler merges control
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
In-Reply-To: <328428.66762.qm@web55006.mail.re4.yahoo.com>
References: <328428.66762.qm@web55006.mail.re4.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 09:34:07 -0500
Message-ID: <1262615647.3908.3.camel@cail>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: fio@vger.kernel.org

On Thu, 2009-12-24 at 11:12 -0800, john smith wrote:
> IOPS-reported numbers for a test vary (more than 30% in my case) from one run to another depending on kernel io scheduler merges (reported in "Disk stats/merges=reads/writes") making it hard to measure/compare performance of block drivers, for instance.
> 
> I don't see any way to turn off kernel io scheduler merges (cfq or others)
> and I'd ask if you would consider adding support for it, disabling the merges per individual device, using sys-fs maybe?
> 
> If you do, adding an option to fio for controlling the merges would be useful too,
> 
> thanks,
> John

Hi John - 

FYI: there is /sys/block/*/queue/nomerges - when set to one ('echo 1
> /sys/block/<dsf>/queue/nomerges) - a lot of the merging attempts are
not performed. [Note, _some_ simple merge attempts _are_ still attempted
regardless of its setting...]

Regards,
Alan

