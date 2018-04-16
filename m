Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:44904 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754042AbeDPI3E (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Apr 2018 04:29:04 -0400
Received: by mail-ua0-f182.google.com with SMTP id r16so9535940uak.11
        for <fio@vger.kernel.org>; Mon, 16 Apr 2018 01:29:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <86719d5b-6a45-91f5-112a-d95d5159ff05@suse.com>
References: <1df8fc47-5ac6-fa99-ee0b-16abfc6a76bb@suse.com>
 <CALjAwxj56y_2eFaqz0aXpT3Pixgcy2QGgndhqTmnwB9g4ixj3w@mail.gmail.com> <86719d5b-6a45-91f5-112a-d95d5159ff05@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 16 Apr 2018 09:28:33 +0100
Message-ID: <CALjAwxgEj-bNV=dO1wU8K5rVbns-fMrMvc0J8=TJmdM4BX4Opw@mail.gmail.com>
Subject: Re: help about how to use latency options
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Larry Chen <lchen@suse.com>
Cc: fio <fio@vger.kernel.org>

Hi,

fio needs to know what the period it should be sampling the latency
over. If the latency was OK in the current latency window it can up
the iodepth by one and start a new latency window thus repeating the
process. Without a window you will (by definition) have no samples to
look at!

On 11 April 2018 at 10:01, Larry Chen <lchen@suse.com> wrote:
> Hi Sitsofe,
> Thanks for your explain.
> I found that if latency_target is specified, latency_window must be along
> with latency_target option.
> If not, fio will exit immediately.
> Why the case is like that?

-- 
Sitsofe | http://sucs.org/~sits/
