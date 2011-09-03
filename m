Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:47001
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1ICD2q (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 Sep 2011 23:28:46 -0400
Message-ID: <4E619EE9.5030508@kernel.dk>
Date: Fri, 02 Sep 2011 21:28:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bad performance when reads and writes on same LUN
References: <116197A0179A3D4A95B135E5F0341FC11041B4DA@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <116197A0179A3D4A95B135E5F0341FC11041B4DA@SACMVEXC2-PRD.hq.netapp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: zhu.yanhai@gmail.com, "Rettl, Matthias" <Matthias.Rettl@netapp.com>, fio@vger.kernel.org

On 2011-09-02 21:24, Neto, Antonio Jose Rodrigues wrote:
> Thanks Jens, but why when we run READS only (not mixed) we don't have performance issues? (We run with direct=0)?

Let me repeat: please don't top post! Etiquette on most open source
lists are to bottom post, like you can see other people are doind.

Apparently you don't have performance problems with buffered reads since
you don't need a large queue depth to get good performance on reads
alone.

Since you seem a little lost, let me suggest that you start by
diagnosing the raw read vs write performance of the device. Get rid of
the file system, use filename=/dev/XXX directly to access that device.
Beware that it will eat the data that is currently on the device. Once
you get an idea for what the device can actually do, then you can start
to consider what impact the file system has on that (if any, I looked at
your job file, and each job would use separate files. so you should not
have any buffered vs direct unhappiness going on).


-- 
Jens Axboe

