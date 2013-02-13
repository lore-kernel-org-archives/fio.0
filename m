Return-Path: <fio-owner@vger.kernel.org>
Received: from server506g.appriver.com ([50.56.144.37]:59297 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934139Ab3BMQgE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 13 Feb 2013 11:36:04 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: How to get IOPS when using terse output
Date: Wed, 13 Feb 2013 16:36:54 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB012AD8@DAGN05A-E6.exg6.exghost.com>
References: <511B6E9C.3000903@gmail.com>
In-Reply-To: <511B6E9C.3000903@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Peter Xu <xzpeter@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>


Hello,

IOPS is definitely in the terse output. IIRC it's the column just after the bandwidth (don't remember the column # off hand; I have a awk script to pull out the interesting data). Look at the bottom of the HOWTO file for the layout of terse output.

z!

________________________________________
From: fio-owner@vger.kernel.org [fio-owner@vger.kernel.org] on behalf of Peter Xu [xzpeter@gmail.com]
Sent: Wednesday, February 13, 2013 2:44 AM
To: fio@vger.kernel.org
Subject: How to get IOPS when using terse output

Hi, all,

I failed to find IOPS results for read/write under terse mode (with
--minimal param when invoking fio program), while IOPS does exist in
normal output without --minimal param.

It seems that I even cannot calculate it out only with the tersed output
(since I don't know the total number of IO). Then, how should I get IOPS
results when using terse output?
