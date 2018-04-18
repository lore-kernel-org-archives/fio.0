Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:60696 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752911AbeDRLz0 (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Wed, 18 Apr 2018 07:55:26 -0400
Subject: Re: help about how to use latency options
References: <1df8fc47-5ac6-fa99-ee0b-16abfc6a76bb@suse.com>
 <CALjAwxj56y_2eFaqz0aXpT3Pixgcy2QGgndhqTmnwB9g4ixj3w@mail.gmail.com>
 <86719d5b-6a45-91f5-112a-d95d5159ff05@suse.com>
 <CALjAwxgEj-bNV=dO1wU8K5rVbns-fMrMvc0J8=TJmdM4BX4Opw@mail.gmail.com>
From: Larry Chen <lchen@suse.com>
Message-ID: <3b549c9e-b06b-300a-3863-b8d74eb0a550@suse.com>
Date: Wed, 18 Apr 2018 19:55:15 +0800
MIME-Version: 1.0
In-Reply-To: <CALjAwxgEj-bNV=dO1wU8K5rVbns-fMrMvc0J8=TJmdM4BX4Opw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks
  :-)

On 04/16/2018 04:28 PM, Sitsofe Wheeler wrote:
> Hi,
>
> fio needs to know what the period it should be sampling the latency
> over. If the latency was OK in the current latency window it can up
> the iodepth by one and start a new latency window thus repeating the
> process. Without a window you will (by definition) have no samples to
> look at!
>
> On 11 April 2018 at 10:01, Larry Chen <lchen@suse.com> wrote:
>> Hi Sitsofe,
>> Thanks for your explain.
>> I found that if latency_target is specified, latency_window must be along
>> with latency_target option.
>> If not, fio will exit immediately.
>> Why the case is like that?

