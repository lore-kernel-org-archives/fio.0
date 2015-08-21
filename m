Return-Path: <fio-owner@vger.kernel.org>
Received: from mx141.netapp.com ([216.240.21.12]:23310 "EHLO mx141.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbbHUOop convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 21 Aug 2015 10:44:45 -0400
From: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO Histogram - latency
Date: Fri, 21 Aug 2015 14:44:42 +0000
Message-ID: <D1FCB149.D7E1%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D1FCA977.D7C4%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D1FCA977.D7C4%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB871AD6801C87478647A8988E683C9E@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>



>Hi All,
>
>This is neto from Brazil
>
>How are you?
>
>I need to simulate a random IO with jobs=64, iodepth=2, 100 LUNs, 75%
>reads and 25% writes (random).
>
>But I need to have a completely histogram for the % of the IOs that
>happened in x us ...
>
>Which option in FIO should I use to have something like that?
>
>I checked the man pages and I saw: read_iolog and write_iolog
>
>But I am not sure...
>
>I really appreciate any help on this matter.
>
>Thank you very much,
>
>neto
>
>--

Hi All,

This is neto from Brazil

How are you?

I think I figure it out.

I will run more tests. Actually I already did, but under a Hypervisor the
percentiles are kinda strange :(

I will update with my results.

Thanks

All the best,

neto 

