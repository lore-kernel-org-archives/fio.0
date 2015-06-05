Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35337 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbFEFvV (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Jun 2015 01:51:21 -0400
Received: by lbbtu8 with SMTP id tu8so23706812lbb.2
        for <fio@vger.kernel.org>; Thu, 04 Jun 2015 22:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB-428kC-cZ0wQczthe=-RwGO_sn9F7e3BdyWa2f4a3ZkgAu0g@mail.gmail.com>
References: <CAB-428kC-cZ0wQczthe=-RwGO_sn9F7e3BdyWa2f4a3ZkgAu0g@mail.gmail.com>
Date: Fri, 5 Jun 2015 06:51:20 +0100
Message-ID: <CALjAwxgjQhgnR+XmtJKtvrMpkwJLzY1v1W-TEiVaz3ZOZEgWzA@mail.gmail.com>
Subject: Re: [Suggestion] Aggregated Client/Server Stats Reporting
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 4 June 2015 at 15:25, Alireza Haghdoost <haghdoost@gmail.com> wrote:
> I am using fio in client/server mode to drive an intensive workload
> and measure performance. However, lacking the aggregated performance
> stats reporting is unpleasant and make my time hard to convince people
> use fio instead of IOMeter in this use case.

I'm guessing trying to use group_reporting
(https://github.com/axboe/fio/blob/fio-2.2.8/HOWTO#L1379 ) didn't
help?

-- 
Sitsofe | http://sucs.org/~sits/
