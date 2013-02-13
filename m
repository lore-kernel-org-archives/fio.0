Return-Path: <fio-owner@vger.kernel.org>
Received: from server506f.appriver.com ([50.56.144.36]:63629 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934187Ab3BMRGj convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 13 Feb 2013 12:06:39 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: How to get IOPS when using terse output
Date: Wed, 13 Feb 2013 17:07:37 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EAB012B1B@DAGN05A-E6.exg6.exghost.com>
References: <511B6E9C.3000903@gmail.com>
In-Reply-To: <511B6E9C.3000903@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Peter Xu <xzpeter@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

As I mentioned, I use an awk script to extract the relevant parts

B/W columns $7 and $48
IOPS columns $8 and $49
completion latency columns $16 and $57

z!


