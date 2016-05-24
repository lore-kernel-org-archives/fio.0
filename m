Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34137 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcEXElM (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 May 2016 00:41:12 -0400
Received: by mail-vk0-f48.google.com with SMTP id c189so6932405vkb.1
        for <fio@vger.kernel.org>; Mon, 23 May 2016 21:41:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANo=J17Bu7w2GM5Tb8aB41dvbCFq1n36c2f=+FQDJKpuS82Ydg@mail.gmail.com>
References: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
	<CANvN+enHvuNd5TC=Qxte22k52qR3XdLzyeGxQ5OLihwOM0XDRQ@mail.gmail.com>
	<CALjAwxgtwP+6K0qLnNzm2Z72gLGasd_oG6EH66bjV-Rc6rOEpw@mail.gmail.com>
	<CANo=J17Bu7w2GM5Tb8aB41dvbCFq1n36c2f=+FQDJKpuS82Ydg@mail.gmail.com>
Date: Tue, 24 May 2016 05:41:10 +0100
Message-ID: <CALjAwxjy6caqqdO+kJ3OOua41_ae_0QVpMBZ3Q3wMk0M+4OTeg@mail.gmail.com>
Subject: Re: testing thin provisioned block device
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tim Walker <tim.t.walker@seagate.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 24 May 2016 at 04:52, Tim Walker <tim.t.walker@seagate.com> wrote:
> This looks interesting.  Thanks!
> I will report back...

Other possibilities would be to use verify_backlog
(https://github.com/axboe/fio/blob/fio-2.10/HOWTO#L1467 ) so you're
re-reading periodically as you're going along or to use
io_limit/io_size
(https://github.com/axboe/fio/blob/fio-2.10/HOWTO#L495 ) with two
stonewalled jobs using the same seeds but where the first job was a
write and the second a read.

-- 
Sitsofe | http://sucs.org/~sits/
