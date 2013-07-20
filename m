Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3GTDHb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Jul 2013 23:07:31 -0400
Date: Fri, 19 Jul 2013 21:07:26 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/5] net: Add UDP multicast support
Message-ID: <20130720030726.GA28005@kernel.dk>
References: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374258250-9801-1-git-send-email-sbohrer@rgmadvisors.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: fio@vger.kernel.org, tomk@rgmadvisors.com

On Fri, Jul 19 2013, Shawn Bohrer wrote:
> Allow UDP readers to listen to UDP multicast traffic if hostname is set
> to a valid UDP multicast address.

Looks good! Can I get you to include a sample job file as well, plus
update the fio.1 man page in parallel with the HOWTO too?

I'm talking about the whole series, there was no 0/5 header patch
include so replying to this one.

-- 
Jens Axboe

