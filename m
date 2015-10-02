Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:54975 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbJBOEs convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 2 Oct 2015 10:04:48 -0400
From: Fabrice Bacchella <fabrice.bacchella@orange.fr>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: IO merge in engine
Message-Id: <599D12BD-A1A9-42D7-ADE1-70ADACA9E177@orange.fr>
Date: Fri, 2 Oct 2015 16:04:45 +0200
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

When writing my new hdfs engine, I met a problem with IO merge.

If I submit IO that are bigger that what the hdfs can manage, I return them to fio as incomplete IO, the net engine works the same way :
in engines/net.c, line 668+
			io_u->resid = io_u->xfer_buflen - ret;
			io_u->error = 0;
			return FIO_Q_COMPLETED;

But the fio count them as two or more fast IO. I'm not sure it's a good measurement because if I'm simulating an application with fio, I expect to get the full IO latency and operations/s count. I don't mesure to mesure sub-io for that. For example, reducing the maximum transfer size will increase IO/s and reduce latency, even if the simulated application really sees reduced performance, because more of it's high level IO operation generated more real IO.

Is there a way to prevent that in fio, or is that up to my engine to manage that and merge IO ?