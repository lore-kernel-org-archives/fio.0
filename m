Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55648 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab2KNU5t (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Nov 2012 15:57:49 -0500
Message-ID: <50A405C4.50100@kernel.dk>
Date: Wed, 14 Nov 2012 13:57:40 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: All clients impatient
References: <201211141929.qAEJTMtO29407865@zion.americas.sgi.com> <50A3F7C8.4070103@kernel.dk>
In-Reply-To: <50A3F7C8.4070103@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: emery@sgi.com
Cc: fio@vger.kernel.org

On 2012-11-14 12:58, Jens Axboe wrote:
> Should work without group_reporting as well with the below patch. Can
> you confirm?

Committed the patch, with a few modifications. So fio git should work
for you now, regardless of whether group_reporting=1 is used or not. I
suspect you want it on in any case, as you are only interested in the
aggregate results for the clients.

-- 
Jens Axboe

