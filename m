Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59608 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0FWMtf (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Jun 2010 08:49:35 -0400
Message-ID: <4C2202DF.30004@fusionio.com>
Date: Wed, 23 Jun 2010 14:49:35 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: --latency-log
References: <20100623044026.DB65571923@kuma.localdomain>
In-Reply-To: <20100623044026.DB65571923@kuma.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: fio@vger.kernel.org

On 2010-06-23 06:40, YAMAMOTO Takashi wrote:
> hi,
> 
> the --latency-log option merely sets the write_lat_log global variable,
> which doesn't seem to be used at all.

So question is how to handle that... The equivalent bw option logs
aggregate bandwidth. Either we drop it, or we make td->o.write_lat_log
inherit this setting.

-- 
Jens Axboe

