Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:35442 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbdIDVsD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Sep 2017 17:48:03 -0400
Received: by mail-ua0-f178.google.com with SMTP id c27so4167928uah.2
        for <fio@vger.kernel.org>; Mon, 04 Sep 2017 14:48:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457AD82F545E4C85F2CA5858F9C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 4 Sep 2017 22:47:31 +0100
Message-ID: <CALjAwxikXWD2WTE5d6+8U3=AQz+G7Wq1+FwBxdrHXeRK1+oDsA@mail.gmail.com>
Subject: Re: fio patch question on filesetup: align layout buffer
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 30 August 2017 at 23:27, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> I see the patch at http://git.kernel.dk/cgit/fio/commit/?id=8c43ba6259409244de64f0b1d388a029e38cf3e5 and just wondered if it is still compatible with:
>
> .. option:: iomem_align=int, mem_align=int
>
[...]
>
> For example, if we set mem_align to something larger than page_size or bs, what does fio_memalign use?  And if we set mem_align to something between page_size and bs, what does fio_memalign use?  Thanks.

What do you think of
https://github.com/sitsofe/fio/commit/8fed4ccc87e39144643b1e32caddd882e6197e58
?

-- 
Sitsofe | http://sucs.org/~sits/
