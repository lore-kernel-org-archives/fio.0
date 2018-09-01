Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:43781 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbeIAJkl (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Sep 2018 05:40:41 -0400
Received: by mail-vk0-f54.google.com with SMTP id s17-v6so6200523vke.10
        for <fio@vger.kernel.org>; Fri, 31 Aug 2018 22:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAFF4W0Xhk_UArnwAMdj_GY_ZRxEtZG+5tE-0yn+5_qdHGQgftg@mail.gmail.com>
 <CALjAwxjUqfdtSBu_=_sCQv2RUGEy12LQsZmqXSiU=nKOSAy4TQ@mail.gmail.com> <CAFF4W0UuETBr4vu_23M1F-q56d++dDCsPV6aijLf-YZNqjPQug@mail.gmail.com>
In-Reply-To: <CAFF4W0UuETBr4vu_23M1F-q56d++dDCsPV6aijLf-YZNqjPQug@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 1 Sep 2018 06:29:32 +0100
Message-ID: <CALjAwxgXeD4ob7_QFuY=g+Pj=_OXq83DM-8_rqsoaWqoq=stHg@mail.gmail.com>
Subject: Re: Understaning direct option in fio for rw=read and rw=randread.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

Interesting question. Some of the terminology is just specific to fio
(e.g. "ioengine" refers to fio's exchangeable backends which allow you
to reuse fio's frontend core routines and monitoring).

"Storage Performance Basics for Deep Learning" blog post
(https://devblogs.nvidia.com/storage-performance-basics-for-deep-learning/
) by James Mauro of NVIDIA describes exploratory use of fio and is an
excellent introduction (which is curious given NVIDIA's usual domain).
It highlights why you want to use fio, what to look at, how to combine
it with other utilities and even discusses some pitfalls. The only
minor point is that James was using an old version of fio but that
doesn't diminish the article's usefulness :-)

http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.1.pdf
gives a thorough discussion on how to benchmark SSDs and covers
crucial topics such as preconditioning, the need to use random
patterns within the data etc.

On Fri, 31 Aug 2018 at 09:01, Mohanraj B <bmohanraj91@gmail.com> wrote:
>
> Hello,
>
> Thanks Sitsofe Wheeler for sharing useful info.
>
> The terminologies(ioengine, iodepth, etc) used in fio is bit
> overwhelming. Quite not clearly grasp how it works. Can you recommend
> any blogs or books to get deep understanding of the underlying
> concepts before dive in to fio.

-- 
Sitsofe | http://sucs.org/~sits/

