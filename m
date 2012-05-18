Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2ERKBT (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 18 May 2012 06:01:19 -0400
Message-ID: <4FB61DD8.7020800@kernel.dk>
Date: Fri, 18 May 2012 12:00:56 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Why fio triggers reading of device serial number
References: <4FB5EA0D.7030402@redhat.com> <4FB5EC0B.7010304@redhat.com>
In-Reply-To: <4FB5EC0B.7010304@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Asias He <asias@redhat.com>
Cc: fio@vger.kernel.org

On 05/18/2012 08:28 AM, Asias He wrote:
> Hi, List
> 
> I noticed that fio triggers reading of device serial number when fio
> starts (one read) and stops (lots of read). I was wondering if fio was
> reading the sysfs attribute directly in fio's code,
> e.g./sys/block/vda/serial, or it triggered something which make udevd to
> read it.
> 
> trace-cmd shows it seems udevd is reading:
> 
> udevd-6856  [006] xxx: function:    dev_attr_show
> udevd-6856  [006] xxx: function:        virtblk_serial_show
> 
> Any ideas? Thanks.

Probably mtime changing of the special file inode, causing some udev
rule to attempt to re-read the id/serial. Fio doesn't read the serial
number.

-- 
Jens Axboe

