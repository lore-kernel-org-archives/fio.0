Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:51871 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbdI1GZJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Sep 2017 02:25:09 -0400
Received: by mail-ua0-f173.google.com with SMTP id 72so307161uas.8
        for <fio@vger.kernel.org>; Wed, 27 Sep 2017 23:25:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDpb-vEKnC6r0PoAVo0_OdNJY-Ou7x1aZrpmX+-xS1Z_TQ@mail.gmail.com>
References: <CAKwzdDpb-vEKnC6r0PoAVo0_OdNJY-Ou7x1aZrpmX+-xS1Z_TQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 28 Sep 2017 07:24:38 +0100
Message-ID: <CALjAwxiYWT1E6rFObq+-yn51wQhXZNh_9_kk4t5ZrTN_XgJqCQ@mail.gmail.com>
Subject: Re: json+ max latency logging for bins
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 28 September 2017 at 02:04, abhishek koundal <akoundal@gmail.com> wrote:
> Can someone confirm if json+ format is used the latency reported in
> the bins (~1200) are mid-point not the max?

There's a brief description of the JSON+ format in the latest git
version of the HOWTO (see the JSON+ output section of the HOWTO
http://fio.readthedocs.io/en/latest/fio_doc.html#id3 ).

>  Does the --status-interval=1sec makes reporting average value in bins.

Averaged over what period? Bear in mind even with
--status-interval=<time> fio is reporting cumulative data since the
job started running ...

> Does adding the log_max_value=1 , will ensure that always max is
> recorded in the latency bin? I have used this for the non-json format
> but then average latency reporting per interval is lost.

I don't know for sure but I'd guess that value ONLY affects the logs
produced by *_bw_log and not the JSON outputs.

-- 
Sitsofe | http://sucs.org/~sits/
