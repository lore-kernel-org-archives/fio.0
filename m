Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34781 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcEWRlh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 May 2016 13:41:37 -0400
Received: by mail-vk0-f43.google.com with SMTP id c189so232623173vkb.1
        for <fio@vger.kernel.org>; Mon, 23 May 2016 10:41:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANvN+enHvuNd5TC=Qxte22k52qR3XdLzyeGxQ5OLihwOM0XDRQ@mail.gmail.com>
References: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
	<CANvN+enHvuNd5TC=Qxte22k52qR3XdLzyeGxQ5OLihwOM0XDRQ@mail.gmail.com>
Date: Mon, 23 May 2016 18:41:36 +0100
Message-ID: <CALjAwxgtwP+6K0qLnNzm2Z72gLGasd_oG6EH66bjV-Rc6rOEpw@mail.gmail.com>
Subject: Re: testing thin provisioned block device
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Tim Walker <tim.t.walker@seagate.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 23 May 2016 at 16:02, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
>
> To my knowledge, there's no prebuilt configuration to read only those blocks
> that have been written before.
>
> At the same time, when randommap is on, FIO keeps track of the blocks written,
> so it may be possible to limit the read generation to those by adding
> a bit of code.

I thought this type of facility had to exist so that verification
triggers (https://github.com/axboe/fio/blob/fio-2.10/HOWTO#L2214 ) via
verify_state_load could work?

-- 
Sitsofe | http://sucs.org/~sits/
