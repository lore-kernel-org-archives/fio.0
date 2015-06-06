Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33650 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbbFFNaM (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Jun 2015 09:30:12 -0400
Received: by qkhg32 with SMTP id g32so54794066qkh.0
        for <fio@vger.kernel.org>; Sat, 06 Jun 2015 06:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgjQhgnR+XmtJKtvrMpkwJLzY1v1W-TEiVaz3ZOZEgWzA@mail.gmail.com>
References: <CAB-428kC-cZ0wQczthe=-RwGO_sn9F7e3BdyWa2f4a3ZkgAu0g@mail.gmail.com>
 <CALjAwxgjQhgnR+XmtJKtvrMpkwJLzY1v1W-TEiVaz3ZOZEgWzA@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Sat, 6 Jun 2015 08:29:30 -0500
Message-ID: <CAB-428koubWB28tS_AAcSPdpAJRQCCYNEFgKx3r3m6wjM=Z7hA@mail.gmail.com>
Subject: Re: [Suggestion] Aggregated Client/Server Stats Reporting
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Jun 5, 2015 at 12:51 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> I'm guessing trying to use group_reporting
> (https://github.com/axboe/fio/blob/fio-2.2.8/HOWTO#L1379 ) didn't
> help?
>

group_reporting does aggregate the performance metrics for multiple
jobs in one server. However, it does not aggregate numbers for
multiple servers.
