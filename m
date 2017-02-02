Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36255 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbdBBWg4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Feb 2017 17:36:56 -0500
Received: by mail-vk0-f49.google.com with SMTP id t8so1454860vke.3
        for <fio@vger.kernel.org>; Thu, 02 Feb 2017 14:36:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
References: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 2 Feb 2017 22:36:24 +0000
Message-ID: <CALjAwxgQVhaviwg0wEqsqqHCsyksf0ES+E6-S3ON7HhUMn17ng@mail.gmail.com>
Subject: Re: NCQ Priority Support and FIO
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brandon Schwartz <schwartz.xn@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Perhaps you could use multiple threads and utilise the flow
(http://fio.readthedocs.io/en/sphinx-doc/fio_doc.html#cmdoption-arg-flow
) control on pairs of threads?

On 2 February 2017 at 22:29, Brandon Schwartz <schwartz.xn@gmail.com> wrote:
>
> 60% RandomRead / 40% RandomWrite but of those reads, have 15% be high priority
>
> Or is there a way to get this sort of priority testing done with
> current FIO?

-- 
Sitsofe | http://sucs.org/~sits/
