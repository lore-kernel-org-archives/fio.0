Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35293 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbETJDh (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 20 May 2015 05:03:37 -0400
Received: by labbd9 with SMTP id bd9so64191029lab.2
        for <fio@vger.kernel.org>; Wed, 20 May 2015 02:03:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55590055.1080005@micxer.de>
References: <55551D18.2000405@micxer.de>
	<CALjAwxgWOokmtXWtN3GvZnvNoC-FTCJX=c3xFiuH5PrB97_kBw@mail.gmail.com>
	<55590055.1080005@micxer.de>
Date: Wed, 20 May 2015 10:03:36 +0100
Message-ID: <CALjAwxjze_LWfTgp=PTn3uOfYwF_cUq3uDZoB1Q8QffCwpdojQ@mail.gmail.com>
Subject: Re: Testing write master and multiple read clients on NFS share
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michael Weinrich <micxer@micxer.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 17 May 2015 at 21:55, Michael Weinrich <micxer@micxer.de> wrote:
> Thanks for the hint. I also found another mistake in limiting the reads and
> writes where I only wanted to limit the writes and have the reads as fast as
> possible. But in general this is a viable approach to my problem?

I can't say for sure whether it models your workload (your example
made use of options I had to look up!) but it does look like an
interesting approach...

-- 
Sitsofe | http://sucs.org/~sits/
