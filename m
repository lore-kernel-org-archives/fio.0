Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:55972 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbdGRGKL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2017 02:10:11 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: pmemblk ioengine broken (pmemblk_bsize unknown)
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <CALjAwxik+EZL1WrB01ye_OaiELE44HmCm2NTC_hKX2v2rxvHmw@mail.gmail.com>
Date: Tue, 18 Jul 2017 00:10:05 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <D2DBB427-CB0C-4959-9266-9940D2254A51@bluestop.org>
References: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org> <CALjAwxik+EZL1WrB01ye_OaiELE44HmCm2NTC_hKX2v2rxvHmw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>




Sent from my iPhone
> On Jul 18, 2017, at 12:03 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> 
> Looks like pmemblk_bsize didn't show up until
> https://github.com/pmem/nvml/commit/463aa6bbae83942ca7819c3eb1a698f3dfcafd59#diff-753ccabb0b5b2cc0453fb0bb1ef10bf8
> which github says only went into 0.2+b3 and then subsequently
> 0.3...

Ah, thanks. I hadn't realized how outdated some packages in OpenSUSE Leap 42.2 are.

-- 
Rebecca
