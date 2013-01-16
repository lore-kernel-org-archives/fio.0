Return-Path: <fio-owner@vger.kernel.org>
Received: from server506a.appriver.com ([50.56.144.13]:54073 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3APVkZ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 16 Jan 2013 16:40:25 -0500
From: Carl Zwanzig <cpz@coraid.com>
Subject: RE: Multi-thread vs. Single-thread job config
Date: Wed, 16 Jan 2013 21:36:45 +0000
Message-ID: <A7A1D348E34E024BBC74480FB93A2EABD77E@DAGN05A-E6.exg6.exghost.com>
References: <CAB-428kduvROVr6oqVYsBaZAEA0WqUddLiB=yNiJNTw_TdYM0g@mail.gmail.com>
 <CAB-428k3dw2TLm_5-7ELzdffCNpHb02ZSzsK73=GD-YVkOgWWA@mail.gmail.com>
 <CF1923A4-1E21-476D-AF9E-AC12920DD274@joshcarter.com>
In-Reply-To: <CF1923A4-1E21-476D-AF9E-AC12920DD274@joshcarter.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Josh Carter <public@joshcarter.com>, Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Josh Carter

> I believe the effect you're seeing is that multiple threads will make the
> IO look more random at the block device. Your configuration uses
> sequential writes, but with numjobs=4 you'll have each job writing at a
> different place in the device. 

I concur. Multiple jobs aimed at the same device will make the workload partially random.

BTW, I omit the directory option and put the full path on the filename option. Gives clarity and seems more predictable (i.e. filename=/dev/sdh).	I think directory is only useful if you're doing multiple files on a filesystem.  (I also spawn separate fio instances instead of using numjobs.)

z!

